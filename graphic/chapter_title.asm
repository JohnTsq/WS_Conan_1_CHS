.macro .insertgfx,tilemap,tileset,payload,originalstart,originalend
    .if filesize(tilemap) != 28*18*2*2
        .error "Tilemap size mismatch: " + tohex(filesize(tilemap),4) + " !"
    .endif
    .if filesize(tileset) > 0x2000
        .error "Tileset oversize: " + tohex(filesize(tileset),4) + " !"
    .endif

    .notice tilemap + " [inserting...]"
    .orga (originalstart + ROM_EXPANSION_OFFSET)
    .incbin tilemap
    
    .notice payload + " [inserting...]"
    .skip 4
    .d16 filesize(tileset)
    .skip 10
    .incbin payload
    
    .if orga() > (originalend + ROM_EXPANSION_OFFSET)
        .error "Payload oversize: " + tohex(filesize(payload),4) + " !"
    .else
        .fill (originalend + ROM_EXPANSION_OFFSET)-orga(),0xFF
    .endif
.endmacro

.insertgfx \
    "graphic\gfx_05CE24\0F0000_chs.tilemap", \
    "graphic\gfx_05CE24\0F07F0-0F209F_chs.2bpp", \
    "graphic\gfx_05CE24\recompressed_0F07F0-0F209F_chs.bin", \
    0x0F0000,0x0F209F

.insertgfx \
    "graphic\gfx_05F7AD\0F209F_chs.tilemap", \
    "graphic\gfx_05F7AD\0F288F-0F41A9_chs.2bpp", \
    "graphic\gfx_05F7AD\recompressed_0F288F-0F41A9_chs.bin", \
    0x0F209F,0x0F41A9

.insertgfx \
    "graphic\gfx_0BE67C\0F41A9_chs.tilemap", \
    "graphic\gfx_0BE67C\0F4999-0F61E0_chs.2bpp", \
    "graphic\gfx_0BE67C\recompressed_0F4999-0F61E0_chs.bin", \
    0x0F41A9,0x0F61E0

.insertgfx \
    "graphic\gfx_0CBD7D\0F61E0_chs.tilemap", \
    "graphic\gfx_0CBD7D\0F69D0-0F82F9_chs.2bpp", \
    "graphic\gfx_0CBD7D\recompressed_0F69D0-0F82F9_chs.bin", \
    0x0F61E0,0x0F82F9