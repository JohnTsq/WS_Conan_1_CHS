tool\PixelPet\PixelPet.exe ^
    Import-Bitmap "graphic\stats\pal0_73-9C-CE-42.png" Read-Palettes --palette-number 0 --palette-size 4 ^
    Import-Bitmap "graphic\stats\pal1_BD-73-FF-00.png" Read-Palettes --palette-number 1 --palette-size 4 --append^
    Import-Bytes "graphic\stats\04F1D0-04F5C7.2bpp" Deserialize-Tileset WS ^
    Import-Bytes "graphic\stats\04EDD0.tilemap" Deserialize-Tilemap WS ^
    Render-Tilemap 28 18 Export-Bitmap "graphic\stats\04EDD0.png" ^
    || exit /b 1
exit /b 0