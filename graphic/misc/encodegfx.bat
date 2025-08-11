tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\misc\pal1_BD-73-FF-00.png" Read-Palettes --palette-number 1 --palette-size 4 ^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\misc\menu_chs.png" --format 32BPP ^
    Generate-Tilemap WS ^
    Serialize-Tileset Export-Bytes "graphic\misc\menu_chs.2bpp" ^
    Serialize-Tilemap Export-Bytes "graphic\misc\menu_chs.tilemap" ^
    Import-Bitmap "graphic\misc\pal0_73-9C-CE-42.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Convert-Palettes 32BPP ^
    Import-Bitmap "graphic\misc\index_chs.png" --format 32BPP ^
    Generate-Tilemap WS ^
    Serialize-Tileset Export-Bytes "graphic\misc\index_chs.2bpp" ^
    Serialize-Tilemap Export-Bytes "graphic\misc\index_chs.tilemap" ^
    || exit /b 1
exit /b 0