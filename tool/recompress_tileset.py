from pathlib import Path

def try_compress_at(index: int, decompressed_data: bytearray) -> dict | None:
    entry = None
    entry_len = 3
    lookback_index = max(-index, -0x1000)
    while lookback_index < 0 and entry_len - 3 < 0x10:
        if decompressed_data[index:index+entry_len] == decompressed_data[index+lookback_index:index+entry_len+lookback_index]:
            entry = {'lookback_index': lookback_index, 'entry_len': entry_len}
            entry_len += 1
        else:
            lookback_index += 1
    return entry

def recompress_tileset(tileset_path: Path) -> bytearray:
    with open(tileset_path, "rb") as f:
        decompressed_data = f.read()
    
    recompressed_data = bytearray()
    current_index = 1
    flag_mask = 0b0100_0000
    flag_byte = 0
    current_flag_byte_chunk = bytearray(decompressed_data[0:1])
    while current_index < len(decompressed_data):
        compression_entry = try_compress_at(current_index, decompressed_data)
        if compression_entry:
            entry = (~compression_entry['lookback_index'] << 4) | (compression_entry['entry_len'] - 3)
            assert entry >> 16 == 0
            entry = entry.to_bytes(2, 'little')
            flag_byte |= flag_mask
            current_index += compression_entry['entry_len']
        else:
            entry = decompressed_data[current_index:current_index+1]
            current_index += 1
        
        current_flag_byte_chunk.extend(entry)
        flag_mask >>= 1
        if flag_mask == 0:
            recompressed_data.extend(flag_byte.to_bytes(1, 'little'))
            recompressed_data.extend(current_flag_byte_chunk)
            flag_mask = 0b1000_0000
            flag_byte = 0
            current_flag_byte_chunk.clear()
    if flag_mask != 0b1000_0000:
        recompressed_data.extend(flag_byte.to_bytes(1, 'little'))
        recompressed_data.extend(current_flag_byte_chunk)
    
    return recompressed_data


def main():
    for tileset_path in graphic_path.rglob("*_chs.2bpp"):
        original_payload_range = tileset_path.stem.replace("_chs", "").split('-')
        if len(original_payload_range) != 2:
            print(f"Skipping {tileset_path} because it doesn't have a valid payload range")
            continue
        original_payload_length = int(original_payload_range[1], 16) - int(original_payload_range[0], 16)
        # print(f"{original_payload_length = :06X}")
        
        tileset_payload = recompress_tileset(tileset_path)
        # print(f"{len(tileset_payload) = :06X}")
        if not len(tileset_payload) <= original_payload_length:
            print(f"check {tileset_path} because it's too long")
        
        recompressed_path = Path(tileset_path.parent, f"recompressed_{tileset_path.stem}.bin")
        with open(recompressed_path, "wb") as f:
            f.write(tileset_payload)

if __name__ == "__main__":
    graphic_path = Path("graphic")
    main()