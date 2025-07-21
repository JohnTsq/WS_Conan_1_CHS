.definelabel ROM_EXPANSION_OFFSET,0x100000

.arm.little
.createfile ".\patched.ws",0
.fill ROM_EXPANSION_OFFSET,0xFF
.incbin ".\baserom.ws"

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

; 图像
.include "graphic\font.asm"
.include "graphic\chapter_title.asm"

.closefile

