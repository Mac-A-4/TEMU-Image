from sys import argv
from PIL import Image
from math import sqrt, inf
if len(argv) < 3:
	exit(-1)
source = argv[1]
result = argv[2]
sourceImage = Image.open(source)
sourceWidth, sourceHeight = sourceImage.size
sourceInput = sourceImage.load()
MAX_WIDTH = 40
MAX_HEIGHT = 25
width = sourceWidth if sourceWidth < MAX_WIDTH else MAX_WIDTH
height = sourceHeight if sourceHeight < MAX_HEIGHT else MAX_HEIGHT
COLOR_TABLE = {
	0x00: (0, 0, 0),
	0x01: (0, 0, 168),
	0x02: (0, 168, 0),
	0x03: (0, 168, 168),
	0x04: (168, 0, 0),
	0x05: (168, 0, 168),
	0x06: (168, 87, 0),
	0x07: (168, 168, 168),
	0x08: (87, 87, 87),
	0x09: (87, 87, 255),
	0x0A: (87, 255, 87),
	0x0B: (87, 255, 255),
	0x0C: (255, 87, 87),
	0x0D: (255, 87, 255),
	0x0E: (255, 255, 87),
	0x0F: (255, 255, 255)
}
def toColor(c):
	def distance(c1, c2):
		dx = c1[0] - c2[0]
		dy = c1[1] - c2[1]
		dz = c1[2] - c2[2]
		return sqrt(dx*dx+dy*dy+dz*dz)
	bestDistance = inf
	bestKey = None
	for k in COLOR_TABLE:
		delta = distance(c, COLOR_TABLE[k])
		if (not bestKey) or (delta < bestDistance):
			bestDistance = delta
			bestKey = k
	return bestKey
colors = []
for y in range(height):
	for x in range(width):
		colors.append(toColor(sourceInput[x, y]))
output = "\""
for i in range(len(colors)):
	if i % 2 == 0:
		output += "\\x"
	output += format(colors[i], "x")
output += "\""
TAG_WIDTH = "width"
TAG_SIZE = "size"
TAG_IMAGE = "image"
with open(result, "w+") as f:
	f.write("{}:\n".format(TAG_WIDTH))
	f.write(".word {}\n".format(width))
	f.write("{}:\n".format(TAG_SIZE))
	f.write(".word {}\n".format(width*height))
	f.write("{}:\n".format(TAG_IMAGE))
	f.write(".ascii {}\n".format(output))
print("Converted.")
