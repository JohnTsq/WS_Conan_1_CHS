.orga (0x04EDD0 + ROM_EXPANSION_OFFSET)
    .incbin "graphic\stats\04EDD0_chs.tilemap"

.orga (0x04F1D0 - 0x10 + ROM_EXPANSION_OFFSET)
    .ascii "LZS2"
    .d32 filesize("graphic\stats\04F1D0-04F5C7_chs.2bpp")
    .d32 filesize("graphic\stats\recompressed_04F1D0-04F5C7_chs.bin")
    .d32 0
.area (0x04F5C7 - 0x04F1D0),0xFF
    .incbin "graphic\stats\recompressed_04F1D0-04F5C7_chs.bin"
.endarea