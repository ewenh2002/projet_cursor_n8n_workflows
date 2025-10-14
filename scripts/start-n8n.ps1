# start-n8n.ps1
# Minimal launcher for n8n (native Windows, no Docker)
# - Reads/creates a local config at .\scripts\n8n.env.json
# - Sets environment variables, then starts n8n
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\start-n8n.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Ensure n8n is installed
if (-not (Get-Command n8n -ErrorAction SilentlyContinue)) {
  Write-Host "❌ n8n CLI not found. Install it first:" -ForegroundColor Red
  Write-Host "   npm install -g n8n" -ForegroundColor Yellow
  exit 1
}

$envFile = Join-Path $PSScriptRoot "n8n.env.json"

# Create default env if missing
if (-not (Test-Path $envFile)) {
  $rand = -join ((48..57 + 97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
  $envObj = @{
    N8N_ENCRYPTION_KEY     = $rand
    N8N_BASIC_AUTH_ACTIVE  = "true"
    N8N_BASIC_AUTH_USER    = "admin"
    N8N_BASIC_AUTH_PASSWORD= "devpass"
    GENERIC_TIMEZONE       = "Europe/Paris"
    N8N_PORT               = "5678"
  }
  $envObj | ConvertTo-Json | Out-File -Encoding UTF8 $envFile
  Write-Host "🆕 Created default config at scripts\n8n.env.json (edit passwords if needed)"
}

# Load env
$cfg = Get-Content $envFile | ConvertFrom-Json

$env:N8N_ENCRYPTION_KEY      = $cfg.N8N_ENCRYPTION_KEY
$env:N8N_BASIC_AUTH_ACTIVE   = $cfg.N8N_BASIC_AUTH_ACTIVE
$env:N8N_BASIC_AUTH_USER     = $cfg.N8N_BASIC_AUTH_USER
$env:N8N_BASIC_AUTH_PASSWORD = $cfg.N8N_BASIC_AUTH_PASSWORD
$env:GENERIC_TIMEZONE        = $cfg.GENERIC_TIMEZONE
$env:N8N_PORT                = $cfg.N8N_PORT

Write-Host "🔐 N8N_ENCRYPTION_KEY: $($env:N8N_ENCRYPTION_KEY.Substring(0,8))********"
Write-Host "👤 Basic Auth: $($env:N8N_BASIC_AUTH_USER) / $($env:N8N_BASIC_AUTH_PASSWORD)"
Write-Host "🌍 Timezone: $($env:GENERIC_TIMEZONE)"
Write-Host "🔌 Port: $($env:N8N_PORT) → http://localhost:$($env:N8N_PORT)"

# Start n8n (blocking)
n8n start
