from pathlib import Path
from typing import Final
from pprint import pp

OFFSET_DECOMPRESSED_SIZE: Final[int] = 4
OFFSET_PAYLOAD:           Final[int] = 0x10

TILEMAP_COLLUMN:          Final[int] = 28
TILEMAP_ROW:              Final[int] = 18
SIZE_PER_ENTRY:           Final[int] = 2
TILEMAP_LEN:              Final[int] = TILEMAP_COLLUMN * TILEMAP_ROW * SIZE_PER_ENTRY
TILEMAP_NUM:              Final[int] = 2


def get_gfx_data(rom_path: Path, script_address: int) -> tuple[bytes, int, int, int]:
    with open(rom_path, "rb") as f:
        f.seek(script_address)
        segment_base = f.read(1)[0] << 16
        offset_tileset_chunk = int.from_bytes(f.read(2), 'little')
        offset_tilemap = int.from_bytes(f.read(2), 'little')
        
        f.seek(0, 2)
        rom_size = f.tell()
        
        segment_base = rom_size - (0x0100_0000 - segment_base)
        f.seek(segment_base)
        segment_bytes = f.read(0x01_0000)
        
        return segment_bytes, segment_base, offset_tileset_chunk, offset_tilemap

def decompress_tileset(segment_bytes: bytes, offset_tileset_chunk: int) -> bytes:
    decompressed_size_total = segment_bytes[offset_tileset_chunk+OFFSET_DECOMPRESSED_SIZE:offset_tileset_chunk+OFFSET_DECOMPRESSED_SIZE+2]
    decompressed_size_total = int.from_bytes(decompressed_size_total, 'little')
    pp(f'{decompressed_size_total:04X}')
    current_index = offset_tileset_chunk + OFFSET_PAYLOAD
    decompressed_size_sofar = 0
    flag_mask = 0
    
    decompressed_data = bytearray()
    while decompressed_size_sofar < decompressed_size_total:
        if flag_mask == 0:
            flag_byte = segment_bytes[current_index]
            current_index += 1
            flag_mask = 0b1000_0000

        if flag_byte & flag_mask == 0:
            decompressed_data.append(segment_bytes[current_index])
            decompressed_size_sofar += 1
            current_index += 1
        else:
            entry = segment_bytes[current_index:current_index+2]
            current_index += 2
            entry = int.from_bytes(entry, 'little')
            
            lookback_index = ~(entry >> 4)
            entry_size = (entry & 0b1111) + 3
            if entry_size > decompressed_size_total - decompressed_size_sofar:
                entry_size = decompressed_size_total - decompressed_size_sofar
            decompressed_size_sofar += entry_size
            
            for _ in range(entry_size):
                try:
                    decompressed_data.append(decompressed_data[lookback_index])
                except IndexError:
                    pp(f'{decompressed_data = }')
                    pp(f'{lookback_index = }')
                    exit()
        
        flag_mask >>= 1
    
    tileset_path = Path(dir_path, f'{segment_base+offset_tileset_chunk+OFFSET_PAYLOAD:06X}-{segment_base+current_index:06X}.2bpp')
    if tileset_path.exists():
        with open(tileset_path, "rb") as f:
            tileset_bytes = f.read()
            if tileset_bytes == decompressed_data:
                pp(f'{tileset_path} already exists and is identical')
            else:
                pp(f'{tileset_path} already exists but is different')
    else:
        with open(tileset_path, "wb") as f:
            f.write(decompressed_data)
    
    return decompressed_data

if __name__ == "__main__":
    rom_path = Path("baserom.ws")
    addresses = (
        0x0A_E977, # 标题画面
        0x01_7D16, # 入门篇 柯南推理课堂
        0x0F_07E0, #00 女高中生连续绑架事件
        0x0F_287F, #04 悬疑电视剧杀人事件
        0x0F_4989, #09 开膛手杰克杀人事件
        0x0F_69C0, #0D 迷之预告函事件
        0x0F_8AD9, #12 世纪末的宝藏事件
    )
    graphic_scripts = (
        0x0B_FBB7, # 标题画面
        0x0B_FBC1, # 入门篇 柯南推理课堂
        0x05_CE24, #00 女高中生连续绑架事件
        0x05_F7AD, #04 悬疑电视剧杀人事件
        0x0B_E67C, #09 开膛手杰克杀人事件
        0x0C_BD7D, #0D 迷之预告函事件
        0x0C_DB48, #12 世纪末的宝藏事件
    )
    for addr in graphic_scripts:
        # prepare for extraction
        segment_bytes, segment_base, offset_tileset_chunk, offset_tilemap = get_gfx_data(rom_path, addr)
        print(f'gfx: {addr:06X} segment: {segment_base>>16:02X} tileset: {offset_tileset_chunk:04X} tilemap: {offset_tilemap:04X}')
        
        # check directory existence
        dir_path = Path('graphic', f'gfx_{addr:06X}')
        if not dir_path.exists():
            dir_path.mkdir(parents=True, exist_ok=True)
        
        # extract tilemap binary
        tilemap_path = Path(dir_path, f'{segment_base+offset_tilemap:06X}.tilemap')
        if tilemap_path.exists():
            with open(tilemap_path, "rb") as f:
                tilemap_bytes = f.read()
                if tilemap_bytes == segment_bytes[offset_tilemap:offset_tilemap+TILEMAP_LEN*TILEMAP_NUM]:
                    pp(f'{tilemap_path} already exists and is identical')
                else:
                    pp(f'{tilemap_path} already exists but is different')
        else:
            with open(tilemap_path, "wb") as f:
                f.write(segment_bytes[offset_tilemap:offset_tilemap+TILEMAP_LEN*TILEMAP_NUM])
            
        # decompress tileset
        decompress_tileset(segment_bytes, offset_tileset_chunk)
    
    dir_path = Path('graphic', 'rotating')
    segment_base = 0x10_0000 - (0x0100_0000 - (0xFA << 16))
    segment_bytes = None
    with open(rom_path, "rb") as f:
        f.seek(segment_base)
        segment_bytes = f.read(0x10000)
        
    offset_tileset_chunk = 0xA2E1
    decompress_tileset(segment_bytes, offset_tileset_chunk)
    
    offset_tileset_chunk = 0xA025
    decompress_tileset(segment_bytes, offset_tileset_chunk)
