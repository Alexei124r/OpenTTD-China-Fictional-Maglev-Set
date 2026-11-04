param(
    [string]$Version = "0.1.2-alpha",
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
Set-Location $PSScriptRoot

if (-not $SkipBuild) {
    & "$PSScriptRoot\build.ps1" -SkipSprites
    if ($LASTEXITCODE -ne 0) {
        throw "build.ps1 failed with exit code $LASTEXITCODE"
    }
}

$requiredFiles = @(
    "china_fictional_maglev.grf",
    "BANANAS_README.md",
    "LICENSE",
    "CHANGELOG.md"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        throw "Required package source is missing: $file"
    }
}

$tarCommand = Get-Command tar -ErrorAction SilentlyContinue
if (-not $tarCommand) {
    throw "tar is required but was not found in PATH"
}

$distRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "dist"))
$stagePath = [System.IO.Path]::GetFullPath(
    (Join-Path $distRoot "bananas_$Version")
)
$archivePath = [System.IO.Path]::GetFullPath(
    (Join-Path $distRoot "china_fictional_maglev_$Version.tar")
)
$distPrefix = $distRoot.TrimEnd('\', '/') +
    [System.IO.Path]::DirectorySeparatorChar

if (-not $stagePath.StartsWith(
        $distPrefix,
        [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to clean a staging path outside dist: $stagePath"
}
if (-not $archivePath.StartsWith(
        $distPrefix,
        [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to replace an archive path outside dist: $archivePath"
}

New-Item -ItemType Directory -Path $distRoot -Force | Out-Null
if (Test-Path -LiteralPath $stagePath) {
    Remove-Item -LiteralPath $stagePath -Recurse -Force
}
New-Item -ItemType Directory -Path $stagePath -Force | Out-Null

Copy-Item -LiteralPath "china_fictional_maglev.grf" `
    -Destination (Join-Path $stagePath "china_fictional_maglev.grf")
Copy-Item -LiteralPath "BANANAS_README.md" `
    -Destination (Join-Path $stagePath "readme.txt")
Copy-Item -LiteralPath "LICENSE" `
    -Destination (Join-Path $stagePath "license.txt")
Copy-Item -LiteralPath "CHANGELOG.md" `
    -Destination (Join-Path $stagePath "changelog.txt")

if (Test-Path -LiteralPath $archivePath) {
    Remove-Item -LiteralPath $archivePath -Force
}

Push-Location $stagePath
try {
    & $tarCommand.Source -cf $archivePath `
        "china_fictional_maglev.grf" `
        "readme.txt" `
        "license.txt" `
        "changelog.txt"
    if ($LASTEXITCODE -ne 0) {
        throw "tar failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

$expectedEntries = @(
    "china_fictional_maglev.grf",
    "readme.txt",
    "license.txt",
    "changelog.txt"
) | Sort-Object
$actualEntries = @(& $tarCommand.Source -tf $archivePath) | Sort-Object
$entryDiff = Compare-Object -ReferenceObject $expectedEntries `
    -DifferenceObject $actualEntries
if ($entryDiff) {
    throw "BaNaNaS archive contains unexpected entries: $($entryDiff | Out-String)"
}

$hash = Get-FileHash -Algorithm SHA256 -LiteralPath $archivePath
Write-Host "Created: $archivePath"
Write-Host "SHA-256: $($hash.Hash)"
