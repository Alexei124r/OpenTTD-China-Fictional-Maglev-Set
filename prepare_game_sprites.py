"""Downscale GoRender 4x sheets to the 1000x160 layout used by the NML template."""
from __future__ import annotations

import os
from PIL import Image

ROOT = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(ROOT, "gfx", "vehicles_4x")
DST = os.path.join(ROOT, "gfx", "game_4x")


def main():
    os.makedirs(DST, exist_ok=True)
    bases = sorted(
        name[:-len("_32bpp.png")]
        for name in os.listdir(SRC)
        if name.endswith("_32bpp.png")
    )
    count = 0
    for base in bases:
        for suffix, resample in (
            ("_32bpp.png", Image.Resampling.LANCZOS),
            ("_8bpp.png", Image.Resampling.NEAREST),
            ("_mask.png", Image.Resampling.NEAREST),
        ):
            src = os.path.join(SRC, base + suffix)
            dst = os.path.join(DST, base + suffix)
            if not os.path.exists(src):
                raise FileNotFoundError(src)
            with Image.open(src) as im:
                out = im.resize((1000, 160), resample)
                out.save(dst)
            count += 1
    print(f"wrote {count} files to {DST}")


if __name__ == "__main__":
    main()
