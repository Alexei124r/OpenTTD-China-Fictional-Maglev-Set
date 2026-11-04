# GitHub and BaNaNaS publishing

This document describes what belongs in the GitHub repository and what belongs
in the BaNaNaS upload. The GitHub repository stores the complete source and
asset set; the BaNaNaS package stores only the compiled GRF and its release
metadata.

## GitHub repository contents

Commit the following groups:

| Group | Files/directories | Purpose |
|---|---|---|
| Build | `china_fictional_maglev.nml`, `build.ps1`, `prepare_game_sprites.py` | GRF source and build automation |
| Runtime sprites | `gfx/game_4x/`, `gfx/empty.png` | Images referenced directly by NML |
| Render masters | `gfx/vehicles_4x/` | GoRender 4x source sheets used for downscaling |
| Voxel sources | `voxel/` | Editable vehicle models |
| Render configuration | `tools/gorender/` | Manifest and TTD palette |
| Localisation | `lang/` | English and Simplified Chinese strings |
| Documentation | `README.md`, `README_zh.md`, `BUILDING.md`, `PUBLISHING.md`, `CHANGELOG.md`, `NML版本修改记录.txt`, `LICENSE` | User, build, release and licence information |
| Preview | `preview/` | Repository and release screenshots |
| Release binary | `china_fictional_maglev.grf` | Convenient direct download and source-to-binary comparison |

`gfx/vehicles_1x/` is currently retained as an archived intermediate render.
It is not required to build the GRF or to upload to BaNaNaS.

The following local/generated content must not be committed:

- `.nmlcache/`
- `backup_*/`
- `dist/`
- Root-level duplicate `manifest.json` and `ttd_palette.json`
- ZIP, TAR, 7z and RAR archives
- Editor and operating-system files

These exclusions are enforced by `.gitignore`.

## BaNaNaS package contents

Upload a single `.tar` archive. It must contain exactly:

| File in archive | Source |
|---|---|
| `china_fictional_maglev.grf` | Compiled GRF |
| `readme.txt` | `BANANAS_README.md` |
| `license.txt` | `LICENSE` |
| `changelog.txt` | `CHANGELOG.md` |

Generate the archive with:

```powershell
.\package_bananas.ps1 -Version "0.1.2-alpha"
```

The output is:

```text
dist/china_fictional_maglev_0.1.2-alpha.tar
```

Do not upload the full ZIP file or the GitHub source tree to BaNaNaS.

Suggested English package description, below the 511-character limit:

```text
An unofficial fictional Chinese maglev vehicle set for OpenTTD. Includes TR08, TR2012, TR2015 and TR2015F passenger/freight stock, MR2015 engineering and towing vehicles, dining cars, multiple refittable liveries, and configurable capacity, loading, comfort and freshness settings.
```

## GitHub upload

The helper builds the GRF, stages all tracked-source changes allowed by
`.gitignore`, commits them and retries `git push` until it succeeds:

```powershell
.\push_retry.bat "Release 0.1.2-alpha"
```

For a release tag after the commit has reached GitHub:

```powershell
git tag -a v0.1.2-alpha -m "China Fictional Maglev Set 0.1.2-alpha"
git push origin v0.1.2-alpha
```

Because GitHub CLI (`gh`) is not required, create the GitHub Release on the
website. Select tag `v0.1.2-alpha` and attach:

- `dist/china_fictional_maglev_0.1.2-alpha.tar`
- `china_fictional_maglev.grf` optionally, as a direct-download asset

## BaNaNaS upload

1. Run `package_bananas.ps1`.
2. Open the existing **China Fictional Maglev Set** package management page.
3. Upload `dist/china_fictional_maglev_0.1.2-alpha.tar`.
4. Set version `0.1.2-alpha`, licence GPL v2 only, and use the description
   above.
5. Check the detected GRF ID is `4F3F0100`, then publish.
