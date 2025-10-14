# export.ps1
# Export all n8n workflows as separate JSON files into .\workflows
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\export.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command n8n -ErrorAction SilentlyContinue)) {
  Write-Host "❌ n8n CLI not found. Install it first: npm install -g n8n" -ForegroundColor Red
  exit 1
}

$wfDir = Join-Path (Split-Path $PSScriptRoot -Parent) "workflows"
New-Item -ItemType Directory -Force -Path $wfDir | Out-Null

n8n export:workflow --all --separate --output $wfDir
Write-Host "✅ Exported workflows to $wfDir"
