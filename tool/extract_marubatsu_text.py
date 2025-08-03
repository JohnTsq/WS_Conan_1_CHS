"""
                    --------sub start--------
2668E  8A 0E 00 02    MOV CL, DS:[$0200]
26692  B5 00          MOV CH, $00
26694  33 C0          XOR AX, AX
26696  8E C0          MOV ES, AX
26698  B0 FD          MOV AL, $FD
2669A  E6 C3          OUT $C3, AL
2669C  1E             PUSH DS
2669D  B8 00 30       MOV AX, $3000
266A0  8E D8          MOV DS, AX
266A2  BF 6C 10       MOV DI, $106C
266A5  51             PUSH CX
266A6  B9 04 00       MOV CX, $0004
266A9  AC             LODSB
266AA  3C 0A          CMP AL, $0A   <<< $0A will be replaced
266AC  75 02          JNZ +$02      <<< with $0B when
266AE  FE C0          INC AL        <<< appears in row text.
266B0  B4 00          MOV AH, $00
266B2  05 A8 0A       ADD AX, $0AA8
266B5  AB             STOSW
266B6  83 C7 3E       ADD DI, $003E
266B9  E2 EE          LOOP -$12
266BB  83 C6 09       ADD SI, $0009
266BE  81 EF 02 01    SUB DI, $0102
266C2  59             POP CX
266C3  E2 E0          LOOP -$20
266C5  1F             POP DS
266C6  C3             RET
                    ----------------
                    --------sub start--------
266C7  8A 0E 00 02    MOV CL, DS:[$0200]
266CB  B5 00          MOV CH, $00
266CD  33 C0          XOR AX, AX
266CF  8E C0          MOV ES, AX
266D1  B0 FD          MOV AL, $FD
266D3  E6 C3          OUT $C3, AL
266D5  1E             PUSH DS
266D6  B8 00 30       MOV AX, $3000
266D9  8E D8          MOV DS, AX
266DB  BF 74 11       MOV DI, $1174
266DE  51             PUSH CX
266DF  B9 04 00       MOV CX, $0004
266E2  AC             LODSB
266E3  B4 00          MOV AH, $00
266E5  05 A8 0A       ADD AX, $0AA8
266E8  AB             STOSW
266E9  83 EF 04       SUB DI, $0004
266EC  E2 F4          LOOP -$0C
266EE  83 C6 09       ADD SI, $0009
266F1  83 C7 48       ADD DI, $0048
266F4  59             POP CX
266F5  E2 E7          LOOP -$19
266F7  1F             POP DS
266F8  C3             RET
                    ----------------
"""

from pprint import pp
from pathlib import Path
from typing import Final

BLOCKS_BASE: Final[int] = 0x0D_019A
BLOCK_SIZE: Final[int] = 0x01AA

def tbl_to_dict(filepath: Path) -> dict[bytes, str]:
    result_dict = {}
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            key, value = line.strip("\n").split('=', maxsplit=1)
            try:
                # print(f"{key=}")
                # print(f"{value=}")
                result_dict[bytes.fromhex(key)] = value
            except ValueError:
                print(f'Invalid codepoint: {key}')
                print(f'and value: {value}')
                sys.exit(1)
    return result_dict

def main():
    marubatsu_tbl: dict = tbl_to_dict(marubatsu_tbl_path)
    # pp(marubatsu_tbl)
    
    with open(baserom_path, "rb") as f, open(r"strings\string_marubatsu.asm", "w", encoding="utf-8") as g:
        g.write("""
.macro .marubatsu,str
    .area 13,0xAF
        .strn str
    .endarea
.endmacro

/* 每条文本须遵守以下规则：
   1.必须以全角空格，即“　”结尾。
   2.文本长度不超过13（含“　”）。
   3.文本长度至少为4（含“　”），否则用“　”填充。
*/

""".lstrip())
        
        for block_idx in range(0x3A):
            g.write(f'.loadtable "marubatsu_tbl\marubatsu_chs_{block_idx:02X}.tbl"\n')
            block_address = BLOCKS_BASE + BLOCK_SIZE * block_idx
            
            # 0x6311
            size = 8
            f.seek(block_address + 0x82)
            if f.read(1) != b'\x00':
                size = 12
            
            g.write(f".orga (0x{block_address + 0x1A:06X} + ROM_EXPANSION_OFFSET)\n")
            for entry in range(size):
                f.seek(block_address + 0x1A + 13*entry)
                line = ""
                for _ in range(13):
                    val = f.read(1)
                    if val == b'\x0A':
                        val = b'\x0B'
                    if val == b'\xAF':
                        break
                    else:
                        line += marubatsu_tbl[val]
                g.write(f'  ; .marubatsu "{line}"\n')
                g.write(f'    .marubatsu "{line}"\n')
            
            g.write(f".orga (0x{block_address + 0xB6:06X} + ROM_EXPANSION_OFFSET)\n")
            for entry in range(size):
                f.seek(block_address + 0xB6 + 13*entry)
                line = ""
                for _ in range(13):
                    val = f.read(1)
                    if val == b'\x0A':
                        val = b'\x0B'
                    if val == b'\xAF':
                        break
                    else:
                        line += marubatsu_tbl[val]
                g.write(f'  ; .marubatsu "{line}"\n')
                g.write(f'    .marubatsu "{line}"\n')
            g.write('\n')

if __name__ == "__main__":
    baserom_path = Path("baserom.ws")
    marubatsu_tbl_path = Path("marubatsu_jpn.tbl")
    main()