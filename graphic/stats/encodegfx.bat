tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\stats\pal0_73-9C-CE-42.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Import-Bitmap "graphic\stats\pal1_BD-73-FF-00.png" Read-Palettes --palette-number 1 --palette-size 4 --append^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\stats\04EDD0_chs.png" --format 32BPP ^
    Generate-Tilemap WS --height 144^
    Serialize-Tileset Export-Bytes "graphic\stats\04F1D0-04F5C7_chs.2bpp" ^
    Serialize-Tilemap Export-Bytes "graphic\stats\04EDD0_chs.tilemap" ^
    || exit /b 1
uv run "tool\recompress_tileset.py" || exit /b 2
exit /b 0