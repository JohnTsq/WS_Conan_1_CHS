tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\gfx_0BFBB7\pal0_9C-42-73-00.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\gfx_0BFBB7\0AE197_chs.png" --format 32BPP ^
    Generate-Tilemap WS --height 144^
    Import-Bitmap "graphic\gfx_0BFBB7\pal5_9C-DE-BD-FF.png" Read-Palettes --palette-number 5 --palette-size 4 ^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\gfx_0BFBB7\0AE197_chs.png" --format 32BPP ^
    Generate-Tilemap WS --append --y 144^
    Serialize-Tileset Export-Bytes "graphic\gfx_0BFBB7\0AE987-0AFCD4_chs.2bpp" ^
    Serialize-Tilemap Export-Bytes "graphic\gfx_0BFBB7\0AE197_chs.tilemap" ^
    || exit /b 1
uv run "tool\recompress_tileset.py" || exit /b 2
exit /b 0