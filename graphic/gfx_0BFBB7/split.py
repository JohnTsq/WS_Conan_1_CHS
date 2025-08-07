from PIL import Image

def main():
    # pal0, pal5 = None, None
    with Image.open(r"graphic\gfx_0BFBB7\pal0_9C-42-73-00.png") as p:
        pal0 = p.convert("LA").getcolors()
        pal0 = tuple(
            e[1][0] for e in pal0 if e[1][1] == 255
        )
    
    with Image.open(r"graphic\gfx_0BFBB7\pal5_9C-DE-BD-FF.png") as p:
        pal5 = p.convert("LA").getcolors()
        pal5 = tuple(
            e[1][0] for e in pal5 if e[1][1] == 255
        )
        
    print(pal0)
    print(pal5)
    with Image.open(r"graphic\gfx_0BFBB7\0AE197_merged_chs.png") as merged:
        merged = merged.convert("LA")
        colors = tuple(e[1] for e in merged.getcolors())
        print(colors)
        split = Image.new(merged.mode, (merged.width, merged.height * 2))
        for y in range(merged.height):
            for x in range(merged.width):
                grey, alpha = merged.getpixel((x, y))
                grey = min(pal0+pal5, key=lambda c: abs(c-grey))
                if alpha != 255:
                    print(f"({x:02X}, {y:02X}): {grey=}, {alpha=}")
                elif grey in pal5:
                    split.putpixel((x, y+merged.height), (grey, alpha))
                    split.putpixel((x, y), (156 if y<120 else 0,255))
                elif grey in pal0:
                    split.putpixel((x, y+merged.height), (0,0))
                    split.putpixel((x, y), (grey, alpha))
                else:
                    print(f"({x:02X}, {y:02X}): {val}\t<- no idea what happened...")
        
        split.convert("RGBA").save(r"graphic\gfx_0BFBB7\0AE197_chs.png")

if __name__ == "__main__":
    main()