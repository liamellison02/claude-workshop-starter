# claude workshop setup, windows (powershell)
# run in an elevated powershell: right-click -> Run as Administrator
# if you hit an execution policy error, first run:
#   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

$ErrorActionPreference = "Stop"

function Log($msg)  { Write-Host "==> $msg" -ForegroundColor Blue }
function Ok($msg)   { Write-Host "[OK] $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "[!]  $msg" -ForegroundColor Yellow }

Log "Claude Workshop setup, Windows"

# check for winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Warn "winget not found. Install 'App Installer' from the Microsoft Store, then re-run this script."
    exit 1
}
Ok "winget available"

# git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Log "Installing Git..."
    winget install --id Git.Git -e --silent --accept-source-agreements --accept-package-agreements
}
Ok "Git ready"

# node.js 20 (LTS)
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Log "Installing Node.js 20 LTS..."
    winget install --id OpenJS.NodeJS.LTS -e --silent --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
Ok "Node $(node -v)"

# pnpm
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Log "Installing pnpm..."
    npm install -g pnpm
}
Ok "pnpm $(pnpm -v)"

# python 3.12
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Log "Installing Python 3.12..."
    winget install --id Python.Python.3.12 -e --silent --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
Ok "Python $(python --version)"

# uv
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Log "Installing uv..."
    powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
    $env:Path = "$env:USERPROFILE\.local\bin;" + $env:Path
}
Ok "uv installed"

# claude code
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Log "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
}
Ok "Claude Code installed"

# github CLI
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Log "Installing GitHub CLI..."
    winget install --id GitHub.cli -e --silent --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
Ok "GitHub CLI installed"

# playwright
Log "Pre-installing Playwright Chromium..."
try { npx -y playwright install chromium | Out-Null; Ok "Playwright Chromium installed" }
catch { Warn "Playwright install deferred, run later if you pick Project B" }

# .env
if (-not (Test-Path .env)) {
    Copy-Item .env.example .env
    Ok "Created .env from .env.example"
}

Write-Host ""
Ok "Setup complete!"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Close and reopen PowerShell (to refresh PATH)"
Write-Host "  2. gh auth login"
Write-Host "  3. claude login"
Write-Host "  4. claude  (then /mcp to verify all 5 servers)"
Write-Host "  5. Follow GUIDE.md"
