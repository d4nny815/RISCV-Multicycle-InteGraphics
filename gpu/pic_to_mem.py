from PIL import Image
image = Image.open("./vga_driver.srcs/parrot_rgb.png")
indexed_image = image.convert("P", palette=Image.ADAPTIVE, colors=64)
pixels = indexed_image.load()


def rgb_to_6b(pixel: tuple) -> int:
    """Converts RGB tuple to 6 bit value"""
    r, g, b = pixel
    r = int(r / 255 * 4) # 2 bit
    g = int(g / 255 * 4) # 2 bit
    b = int(b / 255 * 4) # 2 bit
    return (r << 4) | (g << 2) | b

# pixel_0x0 = pixels[0, 0]
# pixel_0x0 = rgb_to_6b(pixel_0x0)
# pixel_0x0 = bin(pixel_0x0)[2:].zfill(8)
# pixel_0x0 = pixel_0x0[0:2] + '_' + pixel_0x0[2:4] + '_' + pixel_0x0[4:6] + '_' + pixel_0x0[6:8]
# print(pixel_0x0)



# ROM will be 2^16 x 2^6 bits    
pixel_arr = [0 for _ in range((255 << 8 | 255)+1)]  
for y in range(150):  # height of displayable area
    for x in range(200):  # width of displayable area 
        try:
            addr = y << 8 | x  # gets 16 bit address
            # pixel = rgb_to_6b(pixels[x, y])
            pixel = pixels[x, y] # toggle bits 5:0
            pixel = hex(pixel)[2:].zfill(2)
            pixel_arr[addr] = pixel
            # my_str = f"{(y, x)} has addr: {bin(addr)[2:].zfill(16)} with data: {bin(pixels[x, y])}"  # for testing
            # pixel_arr[addr] = my_str  # for testing
        except IndexError:
            raise IndexError(f"IndexError: {(y, x)}")


with open("./vga_driver.srcs/gpu_rom2.mem", "w") as f:
# with open("testing.mem", "w") as f:
    for pixel in pixel_arr:
        try:
            f.write(str(pixel)+"\n")
        except:
            f.write(f"0\n")