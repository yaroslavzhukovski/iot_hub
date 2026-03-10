import json
import logging
import os
from functools import lru_cache
from typing import Any, Dict, Optional

import azure.functions as func
from azure.digitaltwins.core import DigitalTwinsClient
from azure.identity import DefaultAzureCredential

app = func.FunctionApp()


def _load_device_twin_map() -> Dict[str, str]:
    raw = os.getenv("IotIngest__deviceTwinMap", "{}")
    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        logging.warning(
            "IotIngest__deviceTwinMap is not valid JSON. "
            "Expected format: {\"deviceId\":\"twinId\"}."
        )
        return {}

    if not isinstance(parsed, dict):
        logging.warning("IotIngest__deviceTwinMap must be a JSON object.")
        return {}

    return {str(k): str(v) for k, v in parsed.items()}


DEVICE_TWIN_MAP = _load_device_twin_map()


@lru_cache(maxsize=1)
def _get_dt_client() -> DigitalTwinsClient:
    adt_url = os.getenv("AZURE_DIGITAL_TWINS_URL")
    if not adt_url:
        raise ValueError("Missing AZURE_DIGITAL_TWINS_URL app setting.")

    credential = DefaultAzureCredential(exclude_interactive_browser_credential=False)
    return DigitalTwinsClient(adt_url, credential)


def _decode_json_body(event: func.EventHubEvent) -> Dict[str, Any]:
    body = event.get_body()
    if isinstance(body, (bytes, bytearray)):
        payload_str = body.decode("utf-8")
    else:
        payload_str = str(body)
    return json.loads(payload_str)


def _extract_device_id(event: func.EventHubEvent, payload: Dict[str, Any]) -> Optional[str]:
    for key in ("deviceId", "device_id", "iotDeviceId"):
        value = payload.get(key)
        if value:
            return str(value)

    metadata = getattr(event, "metadata", None)
    if isinstance(metadata, dict):
        for key in (
            "iothub-connection-device-id",
            "iothub-connection-deviceid",
            "device-id",
            "deviceId",
        ):
            value = metadata.get(key)
            if value:
                return str(value)

    iothub_metadata = getattr(event, "iothub_metadata", None)
    if isinstance(iothub_metadata, dict):
        for key in (
            "connection-device-id",
            "iothub-connection-device-id",
            "device-id",
            "deviceId",
        ):
            value = iothub_metadata.get(key)
            if value:
                return str(value)

    return None


def _extract_number(payload: Dict[str, Any], key: str) -> Optional[float]:
    value = payload.get(key)
    if value is None:
        return None

    try:
        return float(value)
    except (TypeError, ValueError):
        logging.warning("Telemetry field '%s' is not numeric: %s", key, value)
        return None


@app.event_hub_message_trigger(
    arg_name="azeventhub",
    event_hub_name="%IotIngestEventHubName%",
    connection="IotIngest",
    consumer_group="%IotIngestConsumerGroup%",
)
def process_telemetry(azeventhub: func.EventHubEvent) -> None:
    try:
        payload = _decode_json_body(azeventhub)
    except Exception as exc:  # pragma: no cover - runtime payload errors
        logging.error("Invalid telemetry payload. Expected JSON. Error: %s", exc)
        return

    device_id = _extract_device_id(azeventhub, payload)
    if not device_id:
        logging.warning("Could not resolve device id from payload/metadata: %s", payload)
        return

    twin_id = DEVICE_TWIN_MAP.get(device_id, device_id)
    patch = []

    temperature = _extract_number(payload, "temperature")
    if temperature is not None:
        patch.append({"op": "add", "path": "/temperature", "value": temperature})

    humidity = _extract_number(payload, "humidity")
    if humidity is not None:
        patch.append({"op": "add", "path": "/humidity", "value": humidity})

    if not patch:
        logging.info(
            "No updatable fields found for device '%s'. "
            "Expected numeric 'temperature' or 'humidity'. Payload: %s",
            device_id,
            payload,
        )
        return

    try:
        dt_client = _get_dt_client()
        dt_client.update_digital_twin(twin_id, patch)
        logging.info(
            "Updated twin '%s' (device '%s') with patch: %s",
            twin_id,
            device_id,
            patch,
        )
    except Exception as exc:  # pragma: no cover - external service call
        logging.exception(
            "Failed to update ADT twin '%s' for device '%s'. Error: %s",
            twin_id,
            device_id,
            exc,
        )
