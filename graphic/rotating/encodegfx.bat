tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\rotating\pal5_73-73-FF-00.png" Read-Palettes --palette-number 5 --palette-size 4 ^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\rotating\0A9F45_chs.png" --format 32BPP ^
    Generate-Tilemap WS ^
    Serialize-Tileset Export-Bytes "graphic\rotating\0AA035-0AA251_chs.2bpp" ^
    Serialize-Tilemap Export-Bytes "graphic\rotating\0A9F45_chs.tilemap" ^
    Import-Bitmap "graphic\rotating\0AA251_chs.png" --format 32BPP ^
    Generate-Tilemap WS ^
    Serialize-Tileset Export-Bytes "graphic\rotating\0AA2F1-0AA4CE_chs.2bpp" ^
    Serialize-Tilemap Export-Bytes "graphic\rotating\0AA251_chs.tilemap" ^
    || exit /b 1
uv run "tool\recompress_tileset.py" || exit /b 2
exit /b 0