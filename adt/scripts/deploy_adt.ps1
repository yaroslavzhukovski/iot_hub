param(
  [Parameter(Mandatory = $true)]
  [string]$AdtInstanceName
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$root = Split-Path -Parent $PSScriptRoot
$modelsDir = Join-Path $root "models"
$twinsFile = Join-Path $root "seed/twins.json"
$relsFile = Join-Path $root "seed/relationships.json"

function Invoke-AzCli {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Args
  )

  & az @Args
  if ($LASTEXITCODE -ne 0) {
    throw "Azure CLI command failed: az $($Args -join ' ')"
  }
}

function Test-AzCliSuccess {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Args
  )

  & az @Args 1>$null 2>$null
  return ($LASTEXITCODE -eq 0)
}

Write-Host "Deploying ADT models to $AdtInstanceName ..."
$modelFiles = Get-ChildItem -Path $modelsDir -Filter *.json | Sort-Object Name
foreach ($modelFile in $modelFiles) {
  $modelDoc = Get-Content $modelFile.FullName -Raw | ConvertFrom-Json
  $modelId = $modelDoc.'@id'
  if (-not $modelId) {
    throw "Model file $($modelFile.FullName) does not contain '@id'."
  }

  if (Test-AzCliSuccess -Args @("dt", "model", "show", "--dt-name", $AdtInstanceName, "--dtmi", $modelId, "--only-show-errors")) {
    Write-Host "  model exists, skip: $modelId"
    continue
  }

  Write-Host "  model create: $modelId"
  Invoke-AzCli -Args @(
    "dt", "model", "create",
    "--dt-name", $AdtInstanceName,
    "--models", $modelFile.FullName,
    "--only-show-errors"
  )
}

Write-Host "Upserting twins ..."
$twins = Get-Content $twinsFile -Raw | ConvertFrom-Json
foreach ($t in $twins) {
  $id = $t.'$dtId'
  $modelId = $t.'$metadata'.'$model'
  $props = @{}
  $t.PSObject.Properties | ForEach-Object {
    if ($_.Name -ne '$dtId' -and $_.Name -ne '$metadata') {
      $props[$_.Name] = $_.Value
    }
  }
  if (Test-AzCliSuccess -Args @("dt", "twin", "show", "--dt-name", $AdtInstanceName, "--twin-id", $id, "--only-show-errors")) {
    Write-Host "  twin exists, skip: $id"
    continue
  }

  if ($props.Count -gt 0) {
    $propsFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $propsFile -Value ($props | ConvertTo-Json -Depth 20) -Encoding utf8
    try {
      Invoke-AzCli -Args @(
        "dt", "twin", "create",
        "--dt-name", $AdtInstanceName,
        "--dtmi", $modelId,
        "--twin-id", $id,
        "--properties", $propsFile,
        "--only-show-errors"
      )
    }
    finally {
      Remove-Item -Path $propsFile -Force -ErrorAction SilentlyContinue
    }
  }
  else {
    Invoke-AzCli -Args @(
      "dt", "twin", "create",
      "--dt-name", $AdtInstanceName,
      "--dtmi", $modelId,
      "--twin-id", $id,
      "--only-show-errors"
    )
  }
  Write-Host "  twin: $id"
}

Write-Host "Upserting relationships ..."
$rels = Get-Content $relsFile -Raw | ConvertFrom-Json
foreach ($r in $rels) {
  if (Test-AzCliSuccess -Args @("dt", "twin", "relationship", "show", "--dt-name", $AdtInstanceName, "--twin-id", $r.sourceId, "--relationship-id", $r.relationshipId, "--only-show-errors")) {
    Write-Host "  relationship exists, skip: $($r.relationshipId)"
    continue
  }

  Invoke-AzCli -Args @(
    "dt", "twin", "relationship", "create",
    "--dt-name", $AdtInstanceName,
    "--relationship-id", $r.relationshipId,
    "--relationship", $r.relationshipName,
    "--twin-id", $r.sourceId,
    "--target", $r.targetId,
    "--only-show-errors"
  )

  Write-Host "  relationship: $($r.relationshipId)"
}

Write-Host "Done."
