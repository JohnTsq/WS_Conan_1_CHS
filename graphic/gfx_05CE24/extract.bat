tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\gfx_05CE24\pal0_00-73-42-DE.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Import-Bitmap "graphic\gfx_05CE24\pal1_00-9C-BD-FF.png" Read-Palettes --palette-number 1 --palette-size 4 --append^
    Import-Bitmap "graphic\gfx_05CE24\pal5_00-9C-BD-FF.png" Read-Palettes --palette-number 5 --palette-size 4 --append^
    Import-Bytes "graphic\gfx_05CE24\0F07F0-0F209F.2bpp" Deserialize-Tileset WS ^
    Import-Bytes "graphic\gfx_05CE24\0F0000.tilemap" Deserialize-Tilemap WS ^
    Render-Tilemap 28 36 Export-Bitmap "graphic\gfx_05CE24\0F0000.png" ^
    || exit /b 1
exit /b 0