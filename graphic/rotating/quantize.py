from PIL import Image

def quantize(input_path, palette, output_path) -> None:
    with Image.open(input_path) as edited:
        edited = edited.convert("LA")
        colors = tuple(e[1] for e in edited.getcolors())
        print(colors)
        
        transparent_grey = None
        for c in palette:
            if c[1] == 0:
                transparent_grey = c[0]
                break
        
        quantized = edited.copy()
        for y in range(edited.height):
            for x in range(edited.width):
                grey, alpha = edited.getpixel((x, y))
                if alpha == 0 and transparent_grey is not None:
                    quantized.putpixel((x, y), (transparent_grey, 0))
                    continue
                
                grey = min(palette, key=lambda x: abs(x[0] - grey))[0]
                if (grey, alpha) in palette:
                    quantized.putpixel((x, y), (grey, alpha))
                else:
                    print(f"({x:02X}, {y:02X}): {edited.getpixel((x, y))}")
                    print("↑ no idea what happened...")
                    exit()
        quantized.convert("RGBA").save(output_path)

def main():
    with Image.open(r"graphic\rotating\pal5_73-73-FF-00.png") as p:
        pal5 = p.convert("LA").getcolors()
        pal5 = tuple(e[1] for e in pal5)
    print(pal5)
    
    quantize(
        r"graphic\rotating\汉化0A9F45_chs.png",
        pal5,
        r"graphic\rotating\0A9F45_chs.png"
    )
    
    quantize(
        r"graphic\rotating\汉化0AA251_chs.png",
        pal5,
        r"graphic\rotating\0AA251_chs.png"
    )

if __name__ == "__main__":
    main()