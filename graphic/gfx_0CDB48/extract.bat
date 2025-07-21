D:\Users\John\Documents\GitHub\PixelPet\PixelPet\bin\Release\net7.0\PixelPet.exe ^
    Import-Bitmap "graphic\gfx_0CDB48\pal0_00-73-42-DE.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Import-Bitmap "graphic\gfx_0CDB48\pal1_00-9C-BD-FF.png" Read-Palettes --palette-number 1 --palette-size 4 --append^
    Import-Bitmap "graphic\gfx_0CDB48\pal5_00-9C-BD-FF.png" Read-Palettes --palette-number 5 --palette-size 4 --append^
    Import-Bytes "graphic\gfx_0CDB48\0F8AE9-0FA5CB.2bpp" Deserialize-Tileset WS ^
    Import-Bytes "graphic\gfx_0CDB48\0F82F9.tilemap" Deserialize-Tilemap WS ^
    Render-Tilemap 28 36 Export-Bitmap "graphic\gfx_0CDB48\0F82F9.png" ^
    || exit /b 1
exit /b 0