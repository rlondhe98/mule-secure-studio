# ============================================================
# Build MuleSoft Secure Properties Tool as a self-contained EXE
# ============================================================
# Produces a single EXE that embeds the MuleSoft JAR as base64
# and extracts it to %LOCALAPPDATA% on first run.
#
# Code signing (recommended):
#   .\Build-MuleSoftSecurePropertiesExe.ps1 -CertThumbprint <thumbprint>
# ============================================================

param(
    [string]$CertThumbprint
)

$ErrorActionPreference = "Stop"

$BuildFolder  = $PSScriptRoot
$GuiScript    = Join-Path $BuildFolder "SecurePropertiesGUI.ps1"
$SourceJar    = Join-Path $BuildFolder "secure-properties-tool-j17.jar"
$IconFile     = Join-Path $BuildFolder "MuleSoftSecureProperties.ico"
$OutputFolder = Join-Path $BuildFolder "dist"
$OutputExe    = Join-Path $OutputFolder "MuleSecureStudio.exe"
$TempScript   = Join-Path $BuildFolder "_build_temp.ps1"

# ── Validate inputs ─────────────────────────────────────────
foreach ($req in @(
    @{ Path = $GuiScript; Label = "GUI script" },
    @{ Path = $SourceJar; Label = "MuleSoft JAR" }
)) {
    if (-not (Test-Path -LiteralPath $req.Path -PathType Leaf)) {
        throw "$($req.Label) not found: $($req.Path)"
    }
}

if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# ── Generate icon if missing ────────────────────────────────
if (-not (Test-Path -LiteralPath $IconFile -PathType Leaf)) {
    $iconScript = Join-Path $BuildFolder "Generate-Icon.ps1"
    if (Test-Path -LiteralPath $iconScript -PathType Leaf) {
        Write-Host "Generating application icon..." -ForegroundColor Cyan
        & $iconScript
    } else {
        Write-Warning "No icon file found. EXE will use default icon."
    }
}

# ── Install PS2EXE if missing ───────────────────────────────
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "Installing PS2EXE..." -ForegroundColor Cyan
    Install-Module -Name ps2exe -Scope CurrentUser -Repository PSGallery -Force
}
Import-Module ps2exe

# ── Embed JAR as base64 ─────────────────────────────────────
Write-Host "Embedding JAR as base64..." -ForegroundColor Cyan
$jarBytes  = [System.IO.File]::ReadAllBytes($SourceJar)
$jarBase64 = [System.Convert]::ToBase64String($jarBytes)
Write-Host "  JAR size: $([math]::Round($jarBytes.Length / 1MB, 2)) MB"

$sourceCode = Get-Content -LiteralPath $GuiScript -Raw

$extractBlock = @"

# ── Auto-extract embedded JAR on first run ──
`$EmbeddedJarPath = Join-Path `$env:LOCALAPPDATA "Takeda\MuleSoftSecureProperties\secure-properties-tool-j17.jar"
if (-not (Test-Path -LiteralPath `$EmbeddedJarPath -PathType Leaf)) {
    `$jarDir = Split-Path `$EmbeddedJarPath -Parent
    if (-not (Test-Path `$jarDir)) { New-Item -ItemType Directory -Path `$jarDir -Force | Out-Null }
    `$jarB64 = '$jarBase64'
    [System.IO.File]::WriteAllBytes(`$EmbeddedJarPath, [System.Convert]::FromBase64String(`$jarB64))
}
`$JarPath = `$EmbeddedJarPath

"@

# Replace the JAR-location section with self-extracting logic
$pattern = '(?s)# =+\r?\n# JAR LOCATION.*?exit 1\r?\n\}'
$sourceCode = [regex]::Replace($sourceCode, $pattern, $extractBlock)

Set-Content -LiteralPath $TempScript -Value $sourceCode -Encoding UTF8

# ── Build EXE ────────────────────────────────────────────────
Write-Host ""
Write-Host "Compiling EXE..." -ForegroundColor Cyan

$buildParams = @{
    InputFile   = $TempScript
    OutputFile  = $OutputExe
    x64         = $true
    STA         = $true
    noConsole   = $true
    DPIAware    = $true
    title       = "MuleSoft Secure Properties Tool"
    description = "Encrypt and decrypt MuleSoft secure property values and files."
    company     = "Takeda"
    product     = "MuleSoft Secure Properties Tool"
    copyright   = "Takeda $(Get-Date -Format yyyy)"
    version     = "1.0.0.0"
}

if (Test-Path -LiteralPath $IconFile -PathType Leaf) {
    $buildParams.iconFile = $IconFile
}

Invoke-ps2exe @buildParams

Remove-Item -LiteralPath $TempScript -Force -ErrorAction SilentlyContinue

# Copy icon alongside EXE for window icon at runtime
if (Test-Path -LiteralPath $IconFile -PathType Leaf) {
    Copy-Item -LiteralPath $IconFile -Destination $OutputFolder -Force
}

# ── Code signing ─────────────────────────────────────────────
if ($CertThumbprint) {
    Write-Host ""
    Write-Host "Signing EXE..." -ForegroundColor Cyan
    $cert = Get-ChildItem Cert:\CurrentUser\My\$CertThumbprint -ErrorAction SilentlyContinue
    if (-not $cert) {
        $cert = Get-ChildItem Cert:\LocalMachine\My\$CertThumbprint -ErrorAction SilentlyContinue
    }
    if ($cert) {
        Set-AuthenticodeSignature -FilePath $OutputExe -Certificate $cert `
            -TimestampServer "http://timestamp.digicert.com" -HashAlgorithm SHA256
        Write-Host "  Signed with: $($cert.Subject)" -ForegroundColor Green
    } else {
        Write-Warning "Certificate with thumbprint $CertThumbprint not found. EXE is unsigned."
    }
} else {
    Write-Host ""
    Write-Host "NOTICE: EXE is unsigned. Windows SmartScreen will warn users." -ForegroundColor Yellow
    Write-Host "  To sign: .\Build-MuleSoftSecurePropertiesExe.ps1 -CertThumbprint <thumbprint>" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Build completed." -ForegroundColor Green
Write-Host "  EXE: $OutputExe" -ForegroundColor Green
Write-Host "  Size: $([math]::Round((Get-Item $OutputExe).Length / 1MB, 2)) MB"
