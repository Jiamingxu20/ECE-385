from PIL import Image
from collections import Counter
from scipy.spatial import KDTree
import numpy as np
def hex_to_rgb(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
def rgb_to_hex(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
filename = input("What's the image name? ")
new_w, new_h = map(int, input("What's the new height x width? Like 28 28. ").split(' '))
# palette_hex = ['0x000000', '0xFFA044', '0xAF7F03', '0xAC7C00', '0xF8D878',
#                 '0xacfaf6', '0x018528', '0x0a560e', '0x75d7ad',
#                 '0xbc7200', '0x748481', '0xa43101', '0xa43102',
#                 '0xF7F7F7', '0x6D6D6D', '0x898989', '0xADADAD',
#                 '0x272727', '0x767676', '0xBE3236', '0xFFFFFF',
#                 '0x3640ff', '0xbdfef3', '0xcecfd1', '0x736ad9',
#                 '0x9cea00', '0x346c12', '0x29584a', '0x9dde3d']


palette_hex = ['0x000000', '0xFFFFFF']




palette_rgb = [hex_to_rgb(color) for color in palette_hex]

pixel_tree = KDTree(palette_rgb)
im = Image.open("./sprite_originals/" + filename+ ".png") #Can be many different formats.
im = im.convert("RGBA")
im = im.resize((new_w, new_h),Image.ANTIALIAS) # regular resize
pix = im.load()
pix_freqs = Counter([pix[x, y] for x in range(im.size[0]) for y in range(im.size[1])])
pix_freqs_sorted = sorted(pix_freqs.items(), key=lambda x: x[1])
pix_freqs_sorted.reverse()
print(pix)
outImg = Image.new('RGB', im.size, color='white')
outFile = open("./sprite_bytes/" + filename + '.txt', 'w')
i = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        pixel = im.getpixel((x,y))
        print(pixel)
        if(pixel[3] < 200):
            outImg.putpixel((x,y), palette_rgb[0])
            outFile.write("%x\n" % (0))
            print(i)
        else:
            index = pixel_tree.query(pixel[:3])[1]
            outImg.putpixel((x,y), palette_rgb[index])
            outFile.write("%x\n" % (index))
        i += 1
outFile.close()
outImg.save("./sprite_converted/" + filename + ".png")
