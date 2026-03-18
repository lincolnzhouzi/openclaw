# diagnose.ps1 - Diagnose TRAE CLI installation and configuration on Windows

Write-Host "🔍 TRAE CLI Diagnostic Tool" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

# Track issues
$issues = 0

# Function to print check result
function Print-Check {
    param(
        [string]$Status,
        [string]$Message
    )
    
    switch ($Status) {
        "✓" { Write-Host "✓ $Message" -ForegroundColor Green }
        "✗" { 
            Write-Host "✗ $Message" -ForegroundColor Red
            $script:issues++
        }
        "⚠" { Write-Host "⚠ $Message" -ForegroundColor Yellow }
    }
}

# 1. Check if TRAE CLI is installed
Write-Host "1. Installation Check" -ForegroundColor Cyan
Write-Host "--------------------" -ForegroundColor Cyan

$traecliPath = Get-Command traecli -ErrorAction SilentlyContinue
if ($traecliPath) {
    Print-Check "✓" "TRAE CLI is installed"
    
    # Get version
    $version = & traecli --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Print-Check "✓" "Version: $version"
    } else {
        Print-Check "⚠" "Could not determine version"
    }
} else {
    Print-Check "✗" "TRAE CLI is not installed"
    Write-Host "   Install it with: irm https://trae.cn/trae-cli/install.ps1 | iex" -ForegroundColor Yellow
}
Write-Host ""

# 2. Check PATH
Write-Host "2. PATH Configuration" -ForegroundColor Cyan
Write-Host "--------------------" -ForegroundColor Cyan

if ($traecliPath) {
    Print-Check "✓" "TRAE CLI found in PATH: $($traecliPath.Source)"
} else {
    Print-Check "✗" "TRAE CLI not in PATH"
    
    # Check common locations
    $localAppData = $env:LOCALAPPDATA
    $possiblePaths = @(
        "$localAppData\traecli\traecli.exe",
        "$env:USERPROFILE\.local\bin\traecli.exe"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            Print-Check "⚠" "Found at $path but not in PATH"
            Write-Host "   Add to PATH manually" -ForegroundColor Yellow
            break
        }
    }
}
Write-Host ""

# 3. Check authentication
Write-Host "3. Authentication Status" -ForegroundColor Cyan
Write-Host "----------------------" -ForegroundColor Cyan

$sessionDir = Join-Path $env:USERPROFILE ".openclaw\trae-cli"
$sessionFile = Join-Path $sessionDir "session.json"

if (Test-Path $sessionFile) {
    try {
        $session = Get-Content $sessionFile -Raw | ConvertFrom-Json
        $currentTime = [int][double]::Parse((Get-Date -UFormat %s))
        $expiresAt = $session.expires_at
        
        if ($session.authenticated -and $expiresAt -gt $currentTime) {
            Print-Check "✓" "Authenticated and session is valid"
        } else {
            Print-Check "✗" "Session exists but is expired or invalid"
            Write-Host "   Run: traecli to re-authenticate" -ForegroundColor Yellow
        }
    } catch {
        Print-Check "✗" "Session file is corrupted"
        Write-Host "   Delete: $sessionFile and re-authenticate" -ForegroundColor Yellow
    }
} else {
    Print-Check "✗" "No session found"
    Write-Host "   Run: traecli to authenticate" -ForegroundColor Yellow
}
Write-Host ""

# 4. Check network connectivity
Write-Host "4. Network Connectivity" -ForegroundColor Cyan
Write-Host "---------------------" -ForegroundColor Cyan

try {
    $response = Invoke-WebRequest -Uri "https://trae.cn" -Method Head -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Print-Check "✓" "Can reach TRAE services"
} catch {
    Print-Check "✗" "Cannot reach TRAE services"
    Write-Host "   Check your internet connection" -ForegroundColor Yellow
}
Write-Host ""

# 5. Check configuration
Write-Host "5. Configuration" -ForegroundColor Cyan
Write-Host "---------------" -ForegroundColor Cyan

$configFile = Join-Path $sessionDir "config.json"

if (Test-Path $configFile) {
    Print-Check "✓" "Configuration file exists"
    
    try {
        $config = Get-Content $configFile -Raw | ConvertFrom-Json
        Print-Check "✓" "Configuration is valid JSON"
    } catch {
        Print-Check "✗" "Configuration is invalid JSON"
    }
} else {
    Print-Check "⚠" "No configuration file (will use defaults)"
}
Write-Host ""

# 6. Check system compatibility
Write-Host "6. System Compatibility" -ForegroundColor Cyan
Write-Host "----------------------" -ForegroundColor Cyan

Print-Check "✓" "Platform: Windows (supported)"

# Check Python version
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    $pythonVersion = & python --version 2>&1
    Print-Check "✓" "Python: $pythonVersion"
} else {
    Print-Check "⚠" "Python not found (required for some features)"
}
Write-Host ""

# 7. Summary
Write-Host "==========================" -ForegroundColor Cyan
Write-Host "Diagnostic Summary" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan

if ($issues -eq 0) {
    Write-Host "✓ All checks passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "TRAE CLI is ready to use."
    exit 0
} else {
    Write-Host "✗ Found $issues issue(s)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please address the issues above before using TRAE CLI."
    exit 1
}
