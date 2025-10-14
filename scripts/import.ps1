# import.ps1
# Import workflows from .\workflows into your local n8n
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\import.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command n8n -ErrorAction SilentlyContinue)) {
  Write-Host "❌ n8n CLI not found. Install it first: npm install -g n8n" -ForegroundColor Red
  exit 1
}

$wfDir = Join-Path (Split-Path $PSScriptRoot -Parent) "workflows"

if (-not (Test-Path $wfDir)) {
  Write-Host "❌ workflows directory not found at $wfDir" -ForegroundColor Red
  exit 1
}

n8n import:workflow --input $wfDir
Write-Host "✅ Imported workflows from $wfDir"
