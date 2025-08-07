tool\PixelPet\PixelPet.exe ^
    Import-Bytes "baserom.ws" ^
    Deserialize-Tileset WS --offset 0x0A7DA8 --tile-count 30 ^
    Deserialize-Tilemap WS --offset 0x0057B2 --tile-count 60 ^
    Render-Tilemap 10 6 ^
    Export-Bitmap "graphic\misc\menu.png" ^
    Import-Bitmap "graphic\misc\pal0_73-9C-CE-42.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Deserialize-Tileset WS --offset 0x097728 --tile-count 0xA1 ^
    Deserialize-Tilemap WS --offset 0x097338 --tile-count 504 ^
    Render-Tilemap 28 18 ^
    Export-Bitmap "graphic\misc\index.png" ^
    || exit /b 1
exit /b 0