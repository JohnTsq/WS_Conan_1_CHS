tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\gfx_05CE24\pal0_00-73-42-DE.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\gfx_05CE24\0F0000_chs.png" --format 32BPP ^
    Generate-Tilemap WS --height 144^
    Import-Bitmap "graphic\gfx_05CE24\pal5_00-9C-BD-FF.png" Read-Palettes --palette-number 5 --palette-size 4 ^
    Import-Bitmap "graphic\gfx_05CE24\pal1_00-9C-BD-FF.png" Read-Palettes --palette-number 1 --palette-size 4 --append ^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\gfx_05CE24\0F0000_chs.png" --format 32BPP ^
    Generate-Tilemap WS --append --y 144^
    Serialize-Tileset Export-Bytes "graphic\gfx_05CE24\0F07F0-0F209F_chs.2bpp" ^
    Serialize-Tilemap Export-Bytes "graphic\gfx_05CE24\0F0000_chs.tilemap" ^
    || exit /b 1
uv run "tool\recompress_tileset.py" || exit /b 2
exit /b 0