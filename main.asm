.definelabel ROM_EXPANSION_OFFSET,0x100000

.arm.little
.createfile ".\build.ws",0
.fill ROM_EXPANSION_OFFSET,0xFF
.incbin ".\baserom.ws"

; 为字库分配新的空间
.orga 0
    .incbin ".\baserom.ws", 0x090000, 0x7338
.orga 0x1019DF
    .byte 0xB0,0xE0     ; MOV AL, 0xE0

; 文本
.loadtable "main_chs.tbl"
.include "strings\script_0x0BFB54.asm"
.include "strings\script_0x0CF5B1.asm"

; 图像
.include "graphic\font.asm"

.closefile

