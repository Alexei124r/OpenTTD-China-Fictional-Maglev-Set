param(
    [switch]$SkipSprites
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not $SkipSprites) {
    $python = (Get-Command python -ErrorAction Stop).Source
    & $python '.\prepare_game_sprites.py'
    if ($LASTEXITCODE -ne 0) {
        throw "prepare_game_sprites.py failed with exit code $LASTEXITCODE"
    }
}

$nmlc = (Get-Command nmlc -ErrorAction SilentlyContinue).Source
if (-not $nmlc) {
    throw 'nmlc not found in PATH'
}

& $nmlc `
    -c `
    -l lang `
    --default-lang=english.lng `
    -o 'china_fictional_maglev.grf' `
    'china_fictional_maglev.nml'

if ($LASTEXITCODE -ne 0) {
    throw "nmlc failed with exit code $LASTEXITCODE"
}

Write-Host "Built $PSScriptRoot\china_fictional_maglev.grf"
