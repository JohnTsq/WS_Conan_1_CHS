;                     --------sub start--------
; 2FFB0  81 FE 75 F6    CMP SI, $F675
; 2FFB4  75 2E          JNZ +$2E
; 2FFB6  81 FF 80 2A    CMP DI, $2A80
; 2FFBA  75 28          JNZ +$28
; 2FFBC  A0 F3 01       MOV AL, DS:[$01F3]
; 2FFBF  30 E4          XOR AH, AH
; 2FFC1  BA 00 10       MOV DX, $1000
; 2FFC4  F7 E2          MUL AX, DX
; 2FFC6  1E             PUSH DS
; 2FFC7  07             POP ES
; 2FFC8  89 C6          MOV SI, AX
; 2FFCA  C1 E2 0C       SHL DX, $0C
; 2FFCD  81 C2 00 40    ADD DX, $4000
; 2FFD1  8E DA          MOV DS, DX
; 2FFD3  E4 C0          IN AL, $C0
; 2FFD5  50             PUSH AX
; 2FFD6  B0 0E          MOV AL, $0E
; 2FFD8  E6 C0          OUT $C0, AL
; 2FFDA  B9 00 08       MOV CX, $0800
; 2FFDD  F3 A5          REPZ MOVSW
; 2FFDF  58             POP AX
; 2FFE0  E6 C0          OUT $C0, AL
; 2FFE2  06             PUSH ES
; 2FFE3  1F             POP DS
; 2FFE4  EB 03          JMP +$03
; 2FFE6               --------data--------
; 2FFE8               ----------------
; 2FFE9  C3             RET
;                     ----------------

.orga (0x65F7 + ROM_EXPANSION_OFFSET)
    .d8 0xE8, 0xB6, 0x99        ; call LoadMarubatsuFont

.orga (0xFFB0 + ROM_EXPANSION_OFFSET)
.function LoadMarubatsuFont
    .d8 0xE8, 0xD7, 0x80        ; call (0x808A + ROM_EXPANSION_OFFSET)

	.d8 0xA0, 0xF3, 0x01        ; mov al, ds:[0x01F3]
	.d8 0x30, 0xE4              ; xor ah, ah
	.d8 0xBA, 0x00, 0x08        ; mov dx, 0x0800
	.d8 0xF7, 0xE2              ; mul ax, dx
	.d8 0x1E                    ; push ds
	.d8 0x07                    ; pop es
	.d8 0xBF, 0x80, 0x2B        ; mov di, 0x2A80 + 0x10 * 0x10
	.d8 0x89, 0xC6              ; mov si, ax
	.d8 0xC1, 0xE2, 0x0C        ; shl dx, 4 + 8
	.d8 0x81, 0xC2, 0x00, 0x40  ; add dx, 0x4000
	.d8 0x8E, 0xDA              ; mov ds, dx
	.d8 0xE4, 0xC0              ; in al, 0xC0
	.d8 0x50                    ; push ax
	.d8 0xB0, 0xFE              ; mov al, 0xFE
	.d8 0xE6, 0xC0              ; out 0xC0, al
	.d8 0xB9, 0x00, 0x02        ; mov cx, 0x0200
	.d8 0xF3, 0xA5              ; repz movsw
	.d8 0xBF, 0x80, 0x30        ; mov di, 0x2A80 + 0x10 * 0x60
	.d8 0xB9, 0x00, 0x02        ; mov cx, 0x0200
	.d8 0xF3, 0xA5              ; repz movsw

	.d8 0x58                    ; pop ax
	.d8 0xE6, 0xC0              ; out 0xC0, al
	.d8 0x06                    ; push es
	.d8 0x1F                    ; pop ds
	.d8 0xC3                    ; ret
.endfunction