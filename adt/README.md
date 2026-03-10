# ADT Models And Seed Data

This folder keeps Azure Digital Twins models and sample graph seed data in source control.

## Structure

- `models/` DTDL models
- `seed/twins.json` initial twins
- `seed/relationships.json` initial relationships
- `scripts/deploy_adt.ps1` helper script to upsert models/twins/relationships

## Why keep this in git

- reproducible environments
- visible change history for model evolution
- consistent deployment in dev/stage/prod

## Deploy

```powershell
./adt/scripts/deploy_adt.ps1 -AdtInstanceName "<adt-instance-name>"
```

Requirements:

- Azure CLI installed and logged in
- Azure Digital Twins extension: `az extension add --name azure-iot`
- permissions to manage models/twins in the ADT instance
