import freetype
from pprint import pp
from collections import Counter

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

if __name__ == "__main__":
    # 替换为你的字体文件路径
    font_file = r"C:\Users\John\Documents\Fonts\Small SimSun.ttf"
    font_size = 12
    
    with open("font.bin", "wb") as f:
        for code in range(0x20, 0x80):
            char = chr(code)
            f.write(glyph_bytes(font_file, font_size, char))