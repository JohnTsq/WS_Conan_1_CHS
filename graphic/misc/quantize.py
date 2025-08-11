from PIL import Image

def main():
    with Image.open(r"graphic\misc\pal0_73-9C-CE-42.png") as p:
        pal0 = p.convert("LA").getcolors()
        pal0 = tuple(
            e[1][0] for e in pal0 if e[1][1] == 255
        )
    
    print(pal0)
    with Image.open(r"graphic\misc\汉化index.png") as edited:
        edited = edited.convert("LA")
        colors = tuple(e[1] for e in edited.getcolors())
        print(colors)
        quantized = Image.new(edited.mode, (edited.width, edited.height))
        for y in range(edited.height):
            for x in range(edited.width):
                grey, alpha = edited.getpixel((x, y))
                grey = min(pal0, key=lambda c: abs(c-grey))
                if alpha != 255:
                    print(f"({x:02X}, {y:02X}): {grey=}, {alpha=}")
                elif grey in pal0:
                    quantized.putpixel((x, y), (grey, alpha))
                else:
                    print(f"({x:02X}, {y:02X}): {val}\t<- no idea what happened...")
        
        quantized.convert("RGBA").save(r"graphic\misc\index_chs.png")

if __name__ == "__main__":
    main()