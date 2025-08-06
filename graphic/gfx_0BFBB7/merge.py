from PIL import Image

def main():
    with Image.open(r"graphic\gfx_0BFBB7\0AE197.png") as im:
        print(im.mode)
        
        merged = im.crop((0, 0, im.width, im.height // 2))
        
        for y in range(merged.height):
            for x in range(merged.width):
                r, g, b, a = im.getpixel((x, merged.height + y))
                if a > 0:
                    merged.putpixel((x, y), (r, g, b, a))
        
        merged.save(r"graphic\gfx_0BFBB7\0AE197_merged.png")

if __name__ == "__main__":
    main()