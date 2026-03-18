# install_traecli.ps1 - Install TRAE CLI on Windows

Write-Host "🚀 Installing TRAE CLI..." -ForegroundColor Green

# Download and run official installer
Write-Host "⬇️  Downloading TRAE CLI for Windows..." -ForegroundColor Cyan
try {
    Invoke-Expression "& { $(irm https://trae.cn/trae-cli/install.ps1) }"
} catch {
    Write-Host "❌ Installation failed: $_" -ForegroundColor Red
    exit 1
}

# Verify installation
Write-Host ""
Write-Host "🔍 Verifying installation..." -ForegroundColor Cyan
try {
    $version = traecli --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ TRAE CLI installed successfully!" -ForegroundColor Green
        Write-Host "📌 Version: $version" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "🎉 Installation complete!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Run: traecli" -ForegroundColor White
        Write-Host "2. Follow the prompts to authenticate with your enterprise account" -ForegroundColor White
        Write-Host "3. Start using TRAE CLI!" -ForegroundColor White
    } else {
        Write-Host "❌ Installation verification failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ TRAE CLI not found in PATH" -ForegroundColor Red
    Write-Host "Please restart your terminal or add TRAE CLI to your PATH manually" -ForegroundColor Yellow
    exit 1
}
