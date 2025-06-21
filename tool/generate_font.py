import re
import freetype
from pathlib import Path
from pprint import pp
# from PIL import Image, ImageDraw, ImageFont

def tbl_to_dict(filepath: Path) -> tuple:
    tbl = []
    with open(filepath, 'r', encoding='utf-8') as file:
        for line in file:
            key, value = line.strip("\n").split('=', maxsplit=1)
            if value.startswith('{') and value.endswith('}'):
                ...
            else:
                tbl.append(value)
    return tuple(tbl)

def get_unique_charset(text_path: Path) -> str:
    # 打开指定路径的文本文件，以只读模式读取，编码格式为utf-8
    with open(text_path, 'r', encoding='utf-8') as f:
        match_pattern = re.compile(r'[^;]*?.strn "(.*?)"')
        sub_pattern = re.compile(r'\{.*?\}')
        
        matches = ''
        for lineno, line in enumerate(f, start=1):
            match = match_pattern.match(line)
            if match:
                matches += sub_pattern.sub('', match[1]).replace(r'\"', '"')
                # print(f"line{lineno: 3d}: {matches[-1]}")
        
        return ''.join(set(matches))

def glyph_bytes(font_file: str, font_size: int, char: str) -> tuple:
    face = freetype.Face(font_file)
    face.set_pixel_sizes(0, font_size)  # 设置像素尺寸
    face.load_char(char)
    bitmap = face.glyph.bitmap
    
    if bitmap.pitch == 2:
        return b'\x00\x00' + bytes(bitmap.buffer[:-2])
    elif bitmap.pitch == 1:
        return b'\x00\x00' + bytes(byte for row in bitmap.buffer[:-1] for byte in (row, 0))
    else:
        raise ValueError(f'{char = }\n{bitmap.pitch = }\n{bitmap.width = }\n{bitmap.rows = }')

def main():
    jpn_tbl: tuple = tbl_to_dict("main_jpn.tbl")
    charset: str = ''
    for file in strings_folder.glob('*.asm'):
        charset += get_unique_charset(file)
    # charset = get_unique_charset(r"strings\script_0x0BFB54.asm")
    charset: str = ''.join(sorted(set(charset)))
    print(charset)
    
    chs_tbl = list(jpn_tbl)
    with open(r'graphic\font.asm', 'w', encoding='utf-8') as f:
        ...
    if font_bin_folder.exists():
        for file in font_bin_folder.glob('*.bin'):
            file.unlink(missing_ok=True)
    else:
        font_bin_folder.mkdir(parents=True, exist_ok=True)
    
    for char in charset:
        if char not in chs_tbl:
            # codepoint = len(jpn_tbl)
            chs_tbl.append(char)
        elif ord(char) in range(0x4E00, 0xA000):
            codepoint: int = chs_tbl.index(char)
            with open(rf'graphic\font.asm', 'a', encoding='utf-8') as f:
                f.write(f'.orga 0x{24*codepoint:06X}\n\t')
                codepoint: str = codepoint.to_bytes(2, 'little').hex()
                f.write(rf'.incbin "graphic\font\{codepoint}.bin"')
                f.write('\n\n')
            with open(rf'graphic\font\{codepoint}.bin', 'wb') as f:
                f.write(glyph_bytes(font_file, font_size, char))
    
    append_start: int = len(jpn_tbl)
    with open(rf'graphic\font.asm', 'a', encoding='utf-8') as f:
        f.write(f'.orga 0x{24*append_start:06X}\n\t')
        append_start: str = append_start.to_bytes(2, 'little').hex()
        append_end: str = (len(chs_tbl)-1).to_bytes(2, 'little').hex()
        f.write(rf'.incbin "graphic\font\{append_start}-{append_end}.bin"')
        f.write('\n\n')
    with open(rf'graphic\font\{append_start}-{append_end}.bin', 'wb') as f:
        for char in chs_tbl[len(jpn_tbl):]:
            f.write(glyph_bytes(font_file, font_size, char))
    with open('main_chs.tbl', 'w', encoding='utf-8') as f:
        for i, char in enumerate(chs_tbl):
            f.write(f'{i.to_bytes(2, "little").hex()}={char}\n')
        f.write('FEFF={line}\nFFFF={page}\n')
    
if __name__ == "__main__":
    font_file = r"C:\Users\John\Documents\Fonts\Small SimSun.ttf"
    font_size: int = 12
    strings_folder: Path = Path('strings')
    font_bin_folder: Path = Path('graphic', 'font')
    main()