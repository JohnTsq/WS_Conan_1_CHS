.definelabel ROM_EXPANSION_OFFSET,0x100000

.arm.little
.createfile ".\patched.ws",0
.fill ROM_EXPANSION_OFFSET,0xFF
.incbin ".\baserom.ws"

; 定义 region
.defineregion (0x0AFCE0+ROM_EXPANSION_OFFSET),0x0B0000-0x0AFCE0,0xFF
.defineregion (0x0BFBE0+ROM_EXPANSION_OFFSET),0x0C0000-0x0BFBE0,0xFF

; 为字库分配新的空间
.orga 0
    .incbin ".\baserom.ws", 0x090000, 0x7338
.orga 0x1019DF
    .byte 0xB0,0xE0     ; MOV AL, 0xE0

; 文本
.loadtable "main_chs.tbl"
.include "strings\strings_005183-00566F.asm"
.include "strings\strings_050000-05B9C0.asm"
.include "strings\strings_07F5F0-07FC82.asm"
.include "strings\strings_0B2D20-0BC986.asm"
.include "strings\strings_0C0000-0CB6E2.asm"
.include "strings\strings_0D0000-0D019A.asm"
.include "strings\strings_0D621E-0DFD8A.asm"
.loadtable "marubatsu_jpn.tbl"
.include "strings\string_marubatsu.asm"

; macro for inserting gfx
.macro .insertgfx,tilemap,tileset,payload,originalstart,originalend
    ; .if filesize(tilemap) != 28*18*2*2
    ;     .error "Tilemap size mismatch: " + tohex(filesize(tilemap),4) + " !"
    ; .endif
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


; 图像
.include "graphic\font.asm"
.include "graphic\marubatsu_font.asm"
.include "graphic\titles.asm"
.include "graphic\misc.asm"
.include "graphic\rotating.asm"
.include "graphic\stats.asm"
.orga (0x08FD3D + ROM_EXPANSION_OFFSET)
    .d16 0x0000, 0x3F3F, 0x1F1F, 0x7070, 0x6F6F, 0x7F7F, 0x6060, 0x7F7F
    .d16 0x3030, 0xF6F6, 0xF6F6, 0x0000, 0xE6E6, 0xE6E6, 0x0606, 0xFEFE
    .d16 0x1010, 0x0F0F, 0x0F0F, 0x0C0C, 0x2F2F, 0x6060, 0x7F7F, 0x3F3F
    .d16 0x0000, 0xD6D6, 0xD6D6, 0xD6D6, 0xD6D6, 0x0606, 0xFEFE, 0xFEFE
.orga (0x08FE3D + ROM_EXPANSION_OFFSET)
    .d16 0x7F7F, 0x6060, 0x6060, 0x6060, 0x0000, 0x0000, 0x3F3F, 0x1F1F
    .d16 0xFEFE, 0xC6C6, 0xC6C6, 0xC6C6, 0x0000, 0x3030, 0xF6F6, 0xF6F6

; marubatsu tileset hack
.include "src\marubatsuFont.asm"

; 片头
.include "src\splash.s"

.orga (0x0FFFB0 + ROM_EXPANSION_OFFSET)
    .ascii "armips version: ", tostring(version())
    .notice "armips version: " + tostring(version())

.closefile

