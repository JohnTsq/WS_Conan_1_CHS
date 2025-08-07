tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\gfx_0BE67C\pal0_00-73-42-DE.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Import-Bitmap "graphic\gfx_0BE67C\pal1_00-9C-BD-FF.png" Read-Palettes --palette-number 1 --palette-size 4 --append^
    Import-Bitmap "graphic\gfx_0BE67C\pal5_00-9C-BD-FF.png" Read-Palettes --palette-number 5 --palette-size 4 --append^
    Import-Bytes "graphic\gfx_0BE67C\0F4999-0F61E0.2bpp" Deserialize-Tileset WS ^
    Import-Bytes "graphic\gfx_0BE67C\0F41A9.tilemap" Deserialize-Tilemap WS ^
    Render-Tilemap 28 36 Export-Bitmap "graphic\gfx_0BE67C\0F41A9.png" ^
    || exit /b 1
exit /b 0