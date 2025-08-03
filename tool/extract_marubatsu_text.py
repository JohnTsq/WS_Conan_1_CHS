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
            # if key == "0A":
            #     value = "ー"
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
                    if val == b'\xAF':
                        # line += "\n"
                        break
                    else:
                        line += marubatsu_tbl[val]
                g.write(f'  ; .marubatsu "{line}"\n')
                g.write(f'\t.marubatsu "{line}"\n')
            
            g.write(f".orga (0x{block_address + 0xB6:06X} + ROM_EXPANSION_OFFSET)\n")
            for entry in range(size):
                f.seek(block_address + 0xB6 + 13*entry)
                line = ""
                for _ in range(13):
                    val = f.read(1)
                    if val == b'\xAF':
                        # line += "\n"
                        break
                    else:
                        line += marubatsu_tbl[val]
                g.write(f'  ; .marubatsu "{line}"\n')
                g.write(f'\t.marubatsu "{line}"\n')
            g.write('\n')

if __name__ == "__main__":
    baserom_path = Path("baserom.ws")
    marubatsu_tbl_path = Path("marubatsu_jpn.tbl")
    main()