import sys
from pprint import pp
from pathlib import Path
from typing import Final

ORIGINAL_ROM_SIZE: Final[int] = 0x10_0000

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

def get_chaptors_scripts(rom_path: Path, rom_size: int) -> list[tuple]:
    with open(rom_path, 'rb') as f:
        chaptors_scripts_pointers = []
        for chaptor_index in range(58):
            f.seek(rom_size - (ORIGINAL_ROM_SIZE - 0x00_04DF))
            chapter_size_in_bytes = int.from_bytes(f.read(2), 'little')
            f.seek(rom_size - (ORIGINAL_ROM_SIZE - 0x00_04E4))
            chapters_data_base = int.from_bytes(f.read(2), 'little')
            offset = chapter_size_in_bytes * chaptor_index + chapters_data_base
            # pp(f"{offset=:06X}")
            
            f.seek(rom_size - (ORIGINAL_ROM_SIZE - 0x00_04EB))
            segment = int.from_bytes(f.read(1), 'little') << 16
            chapter_address = segment + offset
            chapter_address = rom_size - (0x0100_0000 - chapter_address) % rom_size
            # pp(f"{chapter_address=:06X}")
            f.seek(rom_size - (ORIGINAL_ROM_SIZE - 0x00_04FF))
            chapter_script_ptr_offset = int.from_bytes(f.read(2), 'little')
            # pp(f"{chapter_script_ptr_offset=:04X}")
            f.seek(chapter_address + chapter_script_ptr_offset)
            # pp(f"{f.tell()=:06X}")
            chaptors_scripts_pointers.append((
                int.from_bytes(f.read(1), 'little'),
                int.from_bytes(f.read(2), 'little')
            ))
            # pp(f"{chaptors_scripts_pointers[-1][0]=:02X}")
            # pp(f"{chaptors_scripts_pointers[-1][1]=:04X}")
            # exit(1)
        # chaptors_scripts_pointers.append((0xFB, 0xFB54))
    return chaptors_scripts_pointers

def get_intro_script(rom_path: Path, rom_size: int) -> tuple:
    with open(rom_path, 'rb') as f:
        f.seek(rom_size - (ORIGINAL_ROM_SIZE - 0x00_00C0))
        segment = int.from_bytes(f.read(1), 'little')
        f.seek(rom_size - (ORIGINAL_ROM_SIZE - 0x00_00C2))
        offset = int.from_bytes(f.read(2), 'little')
    return (segment, offset)

def interpret_text(
    file, 
    address: int, 
    table_file: dict[bytes, str], 
    text_entry: dict
) -> list:
    file.seek(address)
    # print(f'{file.tell() = :06X}')
    dialogue = ''
    d_quotation_counter = 0
    while True:
        codepoint = file.read(2)
        # print(table_file[codepoint], end='')
        char = table_file[codepoint]
        if char == '"':
            dialogue += '“' if d_quotation_counter % 2 == 0 else '”'
            d_quotation_counter += 1
        else:
            dialogue += char
        if codepoint == b'\xFF\xFF':
            text_entry.update(text_end = file.tell())
            text_entry.update(text = dialogue)
            return text_entry

def read_script(
    script_start: int, 
    table_file: dict[bytes, str], 
    # text_entries: list
) -> list:
    with open(rom_path, 'rb') as f:
        f.seek(script_start)
        text_entries = []
        while True:
            subroutine = f.read(1)
            # print(f'{subroutine.hex() = }')
            if subroutine == b'\x01':
                text_entry = dict()
                text_entry.update(ptr_addr = f.tell())
                offset = int.from_bytes(f.read(2), 'little')
                # print(f'{address = :06X}\n{offset = :04X}')
                current = f.tell()
                text_start = (script_start & 0xFF_0000) + offset
                text_entry.update(text_start = text_start)
                # print(f'{address = :06X}')
                text_entry = interpret_text(f, text_start, table_file, text_entry)
                text_entries.append(text_entry)
                f.seek(current)
            elif subroutine in (
                b'\x02', b'\x06', b'\x07', b'\x08', 
                b'\x09', b'\x0A', b'\x4D',
            ):
                countdown = int.from_bytes(f.read(2), 'little')
                # print("Wait for", countdown, "loops...")
            elif subroutine in (
                b'\x30', b'\x2E', b'\x31', b'\x03', b'\x00', b'\x04',
                b'\x1F', b'\x2B', b'\x04', b'\x05', b'\x11', b'\x20',
                b'\x2d', b'\x21', b'\x3B', b'\x47', b'\x4E', b'\x46',
                b'\x49', b'\x45', b'\x4F', b'\x2F', b'\x32', b'\x3F',
                b'\x35', b'\x40', b'\x34', b'\x41', b'\x4A'
            ):
                f.read({
                    b'\x30': 2, b'\x2E': 6, b'\x31': 6, b'\x03': 1,
                    b'\x00': 6, b'\x04': 6, b'\x1F': 1, b'\x2B': 2,
                    b'\x04': 6, b'\x05': 7, b'\x11': 1, b'\x20': 6,
                    b'\x2d': 1, b'\x21': 2, b'\x3B': 5, b'\x47': 1,
                    b'\x4E': 3, b'\x46': 2, b'\x49': 1, b'\x45': 1,
                    b'\x4F': 2, b'\x2F': 1, b'\x32': 4, b'\x3F': 4,
                    b'\x35': 3, b'\x40': 1, b'\x34': 2, b'\x41': 2,
                    b'\x4A': 1,
                }[subroutine] - 1)
                if subroutine == b'\x03':
                    return text_entries
            else:
                print(f'{f.tell()-1:06X}: Unknown subroutine {subroutine.hex()}')
                exit(1)

def extract_with(
    scripts_pointers: list[tuple], 
    tbl_dict: dict[bytes, str], 
    rom_size: int, 
    strings_folder: Path
) -> None:
    for tup in scripts_pointers:
        print(f'{tup[0]:02X}:{tup[1]:04X}')
        address = (tup[0] << 16) + tup[1]
        if address == 0xFF_FFFF:
            continue
        address = rom_size - (0x0100_0000 - address) % rom_size
        text_entries = read_script(address, tbl_dict)
        # pprint.pprint(text_entries)
        
        with open(strings_folder / f'script_0x{address:06X}.asm', 
                  'w', encoding='utf-8') as f:
            text_area_start = min(dic['text_start'] for dic in text_entries)
            text_area_end = max(dic['text_end'] for dic in text_entries)
            f.write(f'.orga (0x{text_area_start:06X} + ROM_EXPANSION_OFFSET)\n')
            f.write(f'.area (0x{text_area_end:06X} + ROM_EXPANSION_OFFSET)-.,0xFF\n\n')
            for dic in text_entries:
                f.write(f'.align 2,0xFF :: String0x{dic["text_start"]:06X}:\n')
                f.write(f'; .strn "{dic["text"]}"\n')
                f.write(f'  .strn "{dic["text"]}"\n\n')
            f.write('.endarea\n\n')
            for dic in text_entries:
                f.write(f'.orga (0x{dic["ptr_addr"]:06X} + ROM_EXPANSION_OFFSET) :: .d16 (String0x{dic["text_start"]:06X} & 0xFFFF)\n')

def main(rom_path: str, tbl_path: str):
    tbl_dict = tbl_to_dict(tbl_path)
    # for k,v in tbl_dict.items():
    #     print(f'{k}={v}<--')

    rom_size = rom_path.stat().st_size
    scripts_pointers = []
    scripts_pointers.extend(get_chaptors_scripts(rom_path, rom_size))
    scripts_pointers.append(get_intro_script(rom_path, rom_size))
    # pp(scripts_pointers[0x19])
    
    strings_folder = Path("strings") / rom_path.stem
    try:
        strings_folder.mkdir(parents=True, exist_ok=True)
        # relative_path = strings_folder.relative_to(Path.cwd())
        print(f'{"已创建" if not strings_folder.exists() else "已存在"} {strings_folder} 文件夹')
    except Exception as e:
        print(f'创建文件夹时发生错误：{e}')
        sys.exit(1)
    
    extract_with(scripts_pointers[0x19:0x19+1:], tbl_dict, rom_size, strings_folder)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("用法: python extract_text.py <rom_path> <tbl_path>")
        sys.exit(1)
    
    rom_path = Path(sys.argv[1])
    tbl_path = Path(sys.argv[2])
    main(rom_path, tbl_path)
