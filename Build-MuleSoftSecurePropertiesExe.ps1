# ============================================================
# Build MuleSoft Secure Properties Tool as an EXE
# ============================================================

$ErrorActionPreference = "Stop"

# Folder containing this build script.
$BuildFolder = $PSScriptRoot

# Input PowerShell GUI file.
$GuiScript = Join-Path $BuildFolder "SecurePropertiesGUI.ps1"

# Original MuleSoft JAR to embed.
$SourceJar = "C:\Users\qlg9915\OneDrive - Takeda\Documents\Takeda documents\MuleSoft\Secure properties jar\secure-properties-tool-j17.jar"

# Build output folder.
$OutputFolder = Join-Path $BuildFolder "dist"

# Generated EXE location.
$OutputExe = Join-Path $OutputFolder "MuleSoftSecureProperties.exe"

# JAR extraction location when EXE runs.
$EmbeddedJarTarget = "%LOCALAPPDATA%\Takeda\MuleSoftSecureProperties\secure-properties-tool-j17.jar"

# Optional application icon.
# Leave this empty if you do not have an .ico file.
$IconFile = Join-Path $BuildFolder "MuleSoftSecureProperties.ico"

# ============================================================
# Validate build inputs.
# ============================================================
if (-not (Test-Path -LiteralPath $GuiScript -PathType Leaf)) {
    throw "GUI script not found: $GuiScript"
}

if (-not (Test-Path -LiteralPath $SourceJar -PathType Leaf)) {
    throw "MuleSoft JAR not found: $SourceJar"
}

if (-not (Test-Path -LiteralPath $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# ============================================================
# Install PS2EXE if it is missing.
# ============================================================
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "Installing PS2EXE..." -ForegroundColor Cyan

    Install-Module `
        -Name ps2exe `
        -Scope CurrentUser `
        -Repository PSGallery `
        -Force
}

Import-Module ps2exe

# ============================================================
# Build the EXE.
# ============================================================
$CommonParameters = @{
    InputFile = $GuiScript
    OutputFile = $OutputExe
    x64 = $true
    STA = $true
    noConsole = $true
    DPIAware = $true
    title = "MuleSoft Secure Properties Tool"
    description = "Encrypt and decrypt MuleSoft secure properties."
    company = "Takeda"
    product = "MuleSoft Secure Properties Tool"
    version = "1.0.0"
    embedFiles = @{
        $EmbeddedJarTarget = $SourceJar
    }
}

# Add an icon only if you created/provided one.
if (Test-Path -LiteralPath $IconFile -PathType Leaf) {
    $CommonParameters.iconFile = $IconFile
}

Write-Host ""
Write-Host "Building EXE..." -ForegroundColor Cyan

Invoke-ps2exe @CommonParameters

Write-Host ""
Write-Host "Build completed successfully." -ForegroundColor Green
Write-Host "EXE location: $OutputExe" -ForegroundColor Green
Write-Host ""
Write-Host "Test the EXE before sharing it." -ForegroundColor Yellow
