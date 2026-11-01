# Building China Fictional Maglev Set

## Requirements

The release GRF was tested with:

- Python 3.12
- NML / `nmlc` 0.8.1
- Pillow 12.1.1
- GoRender `renderobject`

`nmlc` and Pillow are available through Python packaging. GoRender must be
obtained separately from the upstream GoRender project and placed on `PATH`,
or invoked using its full path.

The currently tested GoRender command is:

```powershell
renderobject.exe -m <manifest.json> -palette <ttd_palette.json> -s 4 -overwrite -o <output-base> <input.vox>
```

The exact manifest and palette files used to generate this set are stored in
`tools/gorender/`. They are generic GoRender rendering configuration files,
not NewGRF code. China Set uses different per-model manifests in some
directories, so its manifest should not be substituted without checking the
output dimensions.

For the current sprite layout:

- GoRender 4x output is 4000x640.
- NML game artwork is 1000x160.
- `prepare_game_sprites.py` must find one `_32bpp.png`, one `_8bpp.png`, and
  one `_mask.png` for every source base name.

## Install build tools

Windows PowerShell:

```powershell
python -m pip install --user --upgrade nml Pillow
nmlc --version
python -c "from PIL import Image; print(Image.__version__)"
```

Linux/macOS:

```bash
python3 -m pip install --user --upgrade nml Pillow
nmlc --version
python3 -c "from PIL import Image; print(Image.__version__)"
```

GoRender is not installed with pip. Download it from its upstream project and
make `renderobject` or `renderobject.exe` available.

## Rebuild the GRF from checked-in sprites

This is the normal build path when `gfx/game_4x/` is already present.

Windows PowerShell, from the repository root:

```powershell
nmlc -c `
  -l lang `
  --default-lang=english.lng `
  -o china_fictional_maglev.grf `
  china_fictional_maglev.nml

if ($LASTEXITCODE -ne 0) {
    throw "nmlc failed with exit code $LASTEXITCODE"
}
```

Linux/macOS:

```bash
nmlc -c \
  -l lang \
  --default-lang=english.lng \
  -o china_fictional_maglev.grf \
  china_fictional_maglev.nml
```

The language directory and image paths are relative to
`china_fictional_maglev.nml`, so run the command from the repository root.

## Re-render one VOX model

Example: regenerate the ordinary Shanghai Metro intermediate car.

```powershell
$RenderObject = "renderobject.exe"
$Manifest = "tools/gorender/manifest.json"
$Palette = "tools/gorender/ttd_palette.json"

& $RenderObject `
  -m $Manifest `
  -palette $Palette `
  -s 4 `
  -overwrite `
  -o "gfx/vehicles_4x/TR2015_mid_shanghai_metro" `
  "voxel/TR2015V1.6_mid_上海地铁联动.vox"

if ($LASTEXITCODE -ne 0) {
    throw "GoRender failed with exit code $LASTEXITCODE"
}
```

This must create:

```text
gfx/vehicles_4x/TR2015_mid_shanghai_metro_32bpp.png
gfx/vehicles_4x/TR2015_mid_shanghai_metro_8bpp.png
gfx/vehicles_4x/TR2015_mid_shanghai_metro_mask.png
```

Use the same command for every VOX file, replacing the output base name with
the sprite base name referenced by the NML.

## Downscale all rendered sheets

After all VOX files have been rendered:

```powershell
python prepare_game_sprites.py
if ($LASTEXITCODE -ne 0) {
    throw "Sprite downscaling failed"
}
```

The script reads all `_32bpp.png` files in `gfx/vehicles_4x/` and writes
corresponding 1000x160 files to `gfx/game_4x/`, using Lanczos for 32bpp and
nearest-neighbour scaling for 8bpp and mask images.

## Full source build

```powershell
python prepare_game_sprites.py
nmlc -c -l lang --default-lang=english.lng -o china_fictional_maglev.grf china_fictional_maglev.nml
```

## Verify the result

```powershell
Get-Item .\china_fictional_maglev.grf
Get-FileHash -Algorithm MD5 .\china_fictional_maglev.grf
```

Load the GRF in OpenTTD and test:

1. All purchase-menu entries and refits.
2. All TR2015 passenger liveries, including the baggage/second-class composite.
3. Dual-head orientation.
4. MR2015 power isolation and speed limits.
5. Save/load compatibility.

## License

This project is licensed under GNU GPL version 2 only. See `LICENSE`.
