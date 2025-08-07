tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\gfx_0BFBB7\pal0_9C-42-73-00.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Import-Bitmap "graphic\gfx_0BFBB7\pal5_9C-DE-BD-FF.png" Read-Palettes --palette-number 5 --palette-size 4 --append^
    Import-Bytes "graphic\gfx_0BFBB7\0AE987-0AFCD4.2bpp" Deserialize-Tileset WS ^
    Import-Bytes "graphic\gfx_0BFBB7\0AE197.tilemap" Deserialize-Tilemap WS ^
    Render-Tilemap 28 36 Export-Bitmap "graphic\gfx_0BFBB7\0AE197.png" ^
    || exit /b 1
exit /b 0