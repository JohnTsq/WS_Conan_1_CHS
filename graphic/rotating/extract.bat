tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\rotating\pal5_73-73-FF-00.png" Read-Palettes --palette-number 5 --palette-size 4 ^
    Import-Bytes "graphic\rotating\0AA035-0AA251.2bpp" Deserialize-Tileset WS ^
    Import-Bytes "baserom.ws" Deserialize-Tilemap WS --offset 0x0A9F45 --tile-count 112 ^
    Render-Tilemap 28 4 Export-Bitmap "graphic\rotating\0A9F45.png" ^
    Import-Bytes "graphic\rotating\0AA2F1-0AA4CE.2bpp" Deserialize-Tileset WS ^
    Import-Bytes "baserom.ws" Deserialize-Tilemap WS --offset 0x0AA251 --tile-count 72 ^
    Render-Tilemap 4 18 Export-Bitmap "graphic\rotating\0AA251.png" ^
    || exit /b 1
exit /b 0