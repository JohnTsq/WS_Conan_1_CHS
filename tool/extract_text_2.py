import sys
from pathlib import Path
from pprint import pp

def string_address_generator(
    rom_path: Path,
    strings_block_start: int,
    strings_block_end: int
):
    with open(rom_path, 'rb') as f:
        f.seek(strings_block_start)
        yield f.tell()
        while f.tell() < (strings_block_end - 2):
            if f.read(2) == b'\xFF\xFF':
                # print(f'NEW STRING: {f.tell():06X}')
                yield f.tell()

def script_data16_generator(
    rom_path: Path,
    scripts_block_start: int,
    scripts_block_end: int
):
    with open(rom_path, 'rb') as f:
        f.seek(scripts_block_start)
        script_data = f.read(scripts_block_end - scripts_block_start)
    
    for address, (lo8, hi8) in enumerate(
        zip(script_data[:-1], script_data[1:]), 
        start = scripts_block_start
    ):
        # print(f'{address:06X}: {data16[1]:02X}{data16[0]:02X}', end=' | ')
        yield address, (hi8 << 8) + lo8

def hex_format(item):
    if isinstance(item, tuple):
        return tuple(hex_format(x) for x in item)
    elif isinstance(item, list):
        return [hex_format(x) for x in item]
    elif isinstance(item, int):
        return f"0x{item:06X}" if item is not None else None
    return item

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

def interpret_string(rom_path: Path, string_address: int, table: dict[bytes, str]) -> str:
    with open(rom_path, 'rb') as f:
        f.seek(string_address)
        string = ''
        d_quotation_counter = 0
        while (codepoint := f.read(2)) != b'\xFF\xFF':
            char = table[codepoint]
            if char == '"':
                string += '“' if d_quotation_counter % 2 == 0 else '”'
                d_quotation_counter += 1
            else:
                string += char
        return string + table[b'\xFF\xFF']
    

def main():
    bank0B_strings_address = string_address_generator(
        baserom_path, 
        strings_block_start, 
        strings_block_end
    )
    bank0B_scripts_data16 = None if (scripts_block_start is None or scripts_block_end is None) else \
    script_data16_generator(
        baserom_path,
        scripts_block_start,
        scripts_block_end
    )
    
    string_to_pointer_map = []
    for string_address in bank0B_strings_address:
        if bank0B_scripts_data16 is None:
            string_to_pointer_map.append((string_address, None))
            continue
        while True:
            try:
                script_data16_address, script_data16 = next(bank0B_scripts_data16)
            except StopIteration:
                bank0B_scripts_data16 = script_data16_generator(
                    baserom_path,
                    scripts_block_start,
                    scripts_block_end
                )
                possible_pointer_num = sum(
                    1 if (string_address & 0xFFFF) == ptr else 0 
                    for addr, ptr in bank0B_scripts_data16
                )
                if possible_pointer_num == 1:
                    bank0B_scripts_data16 = script_data16_generator(
                        baserom_path,
                        scripts_block_start,
                        scripts_block_end
                    )
                    continue
                print("No more script data16")
                print(f'{string_address=:06X}')
                string_to_pointer_map.append((string_address, None))
                break
            if (string_address & 0xFFFF) == script_data16:
                next(bank0B_scripts_data16)
                string_to_pointer_map.append((string_address, script_data16_address))
                break
    
    pp(hex_format(string_to_pointer_map))
    
    baserom_tbl: dict[bytes, str] = tbl_to_dict(baserom_tbl_path)
    translated_tbl: dict[bytes, str] = tbl_to_dict(translated_tbl_path)
    split_addresses: tuple = (
        strings_block_start, 
        *(string_addr for string_addr, ptr_addr in string_to_pointer_map[1:-1] if ptr_addr is None), 
        strings_block_end
    )
    with open(Path('strings', f'strings_{strings_block_start:06X}-{strings_block_end:06X}.asm'), 'w', encoding='utf-8') as f:
        # f.write(f'.orga (0x{strings_block_start:06X} + ROM_EXPANSION_OFFSET)\n')
        # f.write(f'.area (0x{strings_block_end:06X} + ROM_EXPANSION_OFFSET)-.,0xFF\n')
        for string_addr, ptr_addr in string_to_pointer_map:
            # print(f'{string_addr=:06X}|{ptr_addr=:06X}')
            # f.write(f'.align 2,0xFF :: String0x{string_addr:06X}:\n')
            if string_addr in split_addresses:
                if split_addresses.index(string_addr) != 0 :
                    f.write('\n.endarea\n\n\n')
                next_split_addr: int = split_addresses[split_addresses.index(string_addr) + 1]
                f.write(f'.orga (0x{string_addr:06X} + ROM_EXPANSION_OFFSET)\n')
                f.write(f'.area (0x{next_split_addr:06X} + ROM_EXPANSION_OFFSET)-.,0xFF\n')
            # if ptr_addr is None:
            #     f.write('.endarea\n\n.orga (0x{string_addr:06X} + ROM_EXPANSION_OFFSET)')
            f.write(f'\nString0x{string_addr:06X}:\n')
            f.write(f'; .strn "{interpret_string(baserom_path, string_addr, baserom_tbl)}"\n')
            f.write(f'  .strn "{interpret_string(translated_path, 0x10_0000+string_addr, translated_tbl)}"\n')
        f.write('\n.endarea\n\n')
        for string_addr, ptr_addr in string_to_pointer_map:
            if ptr_addr is not None:
                f.write(f'.orga (0x{ptr_addr:06X} + ROM_EXPANSION_OFFSET) :: .d16 (String0x{string_addr:06X} & 0xFFFF)\n')

if __name__ == "__main__":
    baserom_path: Path = Path("baserom.ws")
    translated_path: Path = Path("translated.ws")
    baserom_tbl_path: Path = Path("main_jpn.tbl")
    translated_tbl_path: Path = Path("main_chs_old.tbl")

    strings_of_bank: tuple = (
        ((0x00_5183, 0x00_566F), (0x00_0000, 0x01_0000)),
        ((0x05_0000, 0x05_B9C0), (0x05_B9C0, 0x05_FA70)),
        ((0x07_F5F0, 0x07_FC82), (0x07_FC82, 0x07_FE70)),
        ((0x0B_2D20, 0x0B_C986), (0x0B_C986, 0x0B_FBE0)),
        ((0x0C_0000, 0x0C_B6E2), (0x0C_B6E2, 0x0C_FD80)),
        ((0x0D_0000, 0x0D_019A), (     None,      None)),
        ((0x0D_621E, 0x0D_FD8A), (0x0D_019A, 0x0D_61F4))
    )

    for ((strings_block_start, strings_block_end), (scripts_block_start, scripts_block_end)) in strings_of_bank:
        main()