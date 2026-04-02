# Dotfiles Installer for Windows
# Usage (PowerShell):
#   iex (iwr https://raw.githubusercontent.com/<user>/dotfiles/main/install.ps1).Content
# Or locally:
#   .\install.ps1

$ErrorActionPreference = "Stop"

function Write-Blue($msg)   { Write-Host $msg -ForegroundColor Cyan }
function Write-Green($msg)  { Write-Host $msg -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host $msg -ForegroundColor Yellow }
function Write-Red($msg)    { Write-Host $msg -ForegroundColor Red }

function Ask($prompt) {
    $answer = Read-Host "$prompt [y/N]"
    return $answer -match '^[Yy]$'
}

function Install-WithWinget($id, $name) {
    Write-Yellow "Installing $name..."
    winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Green "Installed $name"
    } else {
        Write-Red "Failed to install $name (exit code $LASTEXITCODE)"
    }
}

Write-Blue "====================================================="
Write-Blue " Dotfiles Installer (Windows)"
Write-Blue "====================================================="

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Red "winget not found. Please install 'App Installer' from the Microsoft Store."
    exit 1
}

if (Ask "Install Rust?")   { Install-WithWinget "Rustlang.Rustup" "Rust (rustup)" }
if (Ask "Install Neovim?") { Install-WithWinget "Neovim.Neovim"   "Neovim" }

Write-Green "====================================================="
Write-Green " Done!"
Write-Green "====================================================="
