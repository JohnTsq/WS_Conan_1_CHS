; .insertgfx \
;     "graphic\rotating\0A9F45_chs.tilemap", \
;     "graphic\rotating\0AA035-0AA251_chs.2bpp", \
;     "graphic\rotating\recompressed_0AA035-0AA251_chs.bin", \
;     0xA9F45,0xAA251

; .insertgfx \
;     "graphic\rotating\0AA251_chs.tilemap", \
;     "graphic\rotating\0AA2F1-0AA4CE_chs.2bpp", \
;     "graphic\rotating\recompressed_0AA2F1-0AA4CE_chs.bin", \
;     0xAA251,0xAA4CE

.orga (0x0A9F45 + ROM_EXPANSION_OFFSET)
    .incbin "graphic\rotating\0A9F45_chs.tilemap"

.orga (0x0AA251 + ROM_EXPANSION_OFFSET)
    .incbin "graphic\rotating\0AA251_chs.tilemap"

.autoregion
@TilesetLogoH:
    .ascii "LZS2"
    .d32 filesize("graphic\rotating\0AA035-0AA251_chs.2bpp")
    .d32 filesize("graphic\rotating\recompressed_0AA035-0AA251_chs.bin")
    .d32 0
    .incbin "graphic\rotating\recompressed_0AA035-0AA251_chs.bin"
.endautoregion

.autoregion
@TilesetLogoV:
    .ascii "LZS2"
    .d32 filesize("graphic\rotating\0AA2F1-0AA4CE_chs.2bpp")
    .d32 filesize("graphic\rotating\recompressed_0AA2F1-0AA4CE_chs.bin")
    .d32 0
    .incbin "graphic\rotating\recompressed_0AA2F1-0AA4CE_chs.bin"
.endautoregion

.orga (0x7FD2 + ROM_EXPANSION_OFFSET)
    .d8 0xFB
.orga (0x7FD6 + ROM_EXPANSION_OFFSET)
    .d16 (@TilesetLogoV & 0xFFFF)
.orga (0x7FE8 + ROM_EXPANSION_OFFSET)
    .d16 (@TilesetLogoH & 0xFFFF)