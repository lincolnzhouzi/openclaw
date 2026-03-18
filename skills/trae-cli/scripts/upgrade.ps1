# upgrade.ps1 - Upgrade TRAE CLI on Windows

Write-Host "🔄 TRAE CLI Upgrade Tool" -ForegroundColor Cyan
Write-Host "=======================" -ForegroundColor Cyan
Write-Host ""

# Check if TRAE CLI is installed
$traecliPath = Get-Command traecli -ErrorAction SilentlyContinue
if (-not $traecliPath) {
    Write-Host "✗ TRAE CLI is not installed" -ForegroundColor Red
    Write-Host "Please install it first with: irm https://trae.cn/trae-cli/install.ps1 | iex" -ForegroundColor Yellow
    exit 1
}

# Get current version
Write-Host "📌 Current version:" -ForegroundColor Cyan
$currentVersion = & traecli --version 2>&1
Write-Host $currentVersion
Write-Host ""

# Check for updates
Write-Host "🔍 Checking for updates..." -ForegroundColor Cyan
Write-Host "This may take a moment..." -ForegroundColor Yellow
Write-Host ""

# Run TRAE CLI update command
$updateResult = & traecli update 2>&1
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "✓ Upgrade successful!" -ForegroundColor Green
    
    # Get new version
    $newVersion = & traecli --version 2>&1
    Write-Host ""
    Write-Host "📌 New version: $newVersion" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🎉 TRAE CLI has been upgraded to the latest version!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "✗ Upgrade failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible reasons:" -ForegroundColor Yellow
    Write-Host "1. Network connection issues"
    Write-Host "2. TRAE CLI update service is temporarily unavailable"
    Write-Host "3. You already have the latest version"
    Write-Host ""
    Write-Host "Please try again later or check the TRAE CLI documentation."
    exit 1
}
