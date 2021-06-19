#
# Just a quick and dirty script to extract 256 codepoints from a BDF file
# (8x16 fonts only) and generate an hex file to use as a font rom
#
# It reads from stdin and writes to stdout
#
# The included font can be generated with:
#
# python extract_font.py < terminus_816_latin1.bdf > terminus_816_latin1.hex
#
# using the codepoints dict included in this script
#
# For custom fonts and/or different mappings, provide another bdf and/or change
# codepoints_map accordingly
#

import sys, re

# mapping from byte values (0x00-0xff) to unicode codepoints
# start from an empty dict
codepoints_map = {}

#
# Lower 128 chars
#

# 0-31 & 127 (del) are control chars
# We use codepoint 0 for all control characters (I think in the current
# font there's a small symbol there, but could be replaced by an empty
# glyph, like space)
codepoints_map.update({v: 0 for v in range(0x20)})
codepoints_map[0x7f] = 0
# add printable ASCII at their logical positions (unicode and ASCII codepoints
# are the same in this range)
codepoints_map.update({v: v for v in range(0x20, 0x7f)})

#
# Upper 128 values, in this case latin-1 supplement
#
# First 32 are C1 Controls
codepoints_map.update({v: 0 for v in range(0x80, 0xa0)})
# and the next 96 are printable latin 1 characters (unicode and ASCII codepoints
# are the same in this range)
codepoints_map.update({v: v for v in range(0xa0, 0x100)})

# Example alternative: some box drawing chars from codepage 437, NOT TESTED
# (info taken from https://en.wikipedia.org/wiki/Code_page_437)

# 0xB3
codepoints_map[179] = 0x2502
codepoints_map[180] = 0x2524
codepoints_map[181] = 0x2561
codepoints_map[182] = 0x2562
codepoints_map[183] = 0x2556
codepoints_map[184] = 0x2555
codepoints_map[185] = 0x2563
codepoints_map[186] = 0x2551
codepoints_map[187] = 0x2557
codepoints_map[188] = 0x255d
codepoints_map[189] = 0x255c
codepoints_map[190] = 0x255b
codepoints_map[191] = 0x2510
#0xC0
codepoints_map[192] = 0x2514
codepoints_map[193] = 0x2534
codepoints_map[194] = 0x252c
codepoints_map[195] = 0x251c
codepoints_map[196] = 0x2500
codepoints_map[197] = 0x253c
codepoints_map[198] = 0x255e
codepoints_map[199] = 0x255f
codepoints_map[200] = 0x255a
codepoints_map[201] = 0x2554
codepoints_map[202] = 0x2569
codepoints_map[203] = 0x2566
codepoints_map[204] = 0x2560
codepoints_map[205] = 0x2550
codepoints_map[206] = 0x256c
codepoints_map[207] = 0x2567
#0xD0
codepoints_map[208] = 0x2568
codepoints_map[209] = 0x2564
codepoints_map[210] = 0x2565
codepoints_map[211] = 0x2559
codepoints_map[212] = 0x2558
codepoints_map[213] = 0x2552
codepoints_map[214] = 0x2553
codepoints_map[215] = 0x256b
codepoints_map[216] = 0x256a
codepoints_map[217] = 0x2518
codepoints_map[218] = 0x250c
#0xE0
codepoints_map[224] = 0x25c6
codepoints_map[225] = 0x2592
codepoints_map[226] = 0x2409
codepoints_map[227] = 0x240c
codepoints_map[228] = 0x240d
codepoints_map[229] = 0x240a
codepoints_map[230] = 0x30a
codepoints_map[231] = 0xb1
codepoints_map[232] = 0x2424
codepoints_map[233] = 0x240b
codepoints_map[234] = 0x251b
codepoints_map[235] = 0x2513
codepoints_map[236] = 0x250f
codepoints_map[237] = 0x2517
codepoints_map[238] = 0x254b
codepoints_map[239] = 0x23ba

#0xF0
codepoints_map[240] = 0x23bb
codepoints_map[241] = 0x23af
codepoints_map[242] = 0x23bc
codepoints_map[243] = 0x23bd
codepoints_map[244] = 0x2523
codepoints_map[245] = 0x252b
codepoints_map[246] = 0x253b
codepoints_map[247] = 0x2533
codepoints_map[248] = 0x2503
codepoints_map[249] = 0x2264
codepoints_map[250] = 0x2265
codepoints_map[251] = 0x3a0
codepoints_map[252] = 0x2260
codepoints_map[253] = 0xa3
codepoints_map[254] = 0x25cf
codepoints_map[255] = 0

# set of all assigned codepoints, constructed programatically codepoints_map
codepoints = set(codepoints_map.values())

# Dictionary with the glyphs for all assigned codepoints
# Initialize all glyphs to an empty square (no pixels on),
# just in case there's a missing glyph in the font
# We could also put a special icon here like a question mark
empty_glyph = [0x00 for i in range(16)]
glyphs = { cp: empty_glyph for cp in codepoints}

# Now "parse" the bdf file, really we are only looking at a couple of
# lines and ignoring the rest... No error checking whatsoever...

# regular expressions to detect lines of interest
encoding_re = re.compile("^ENCODING\s+(\d+)$")
bitmap_re = re.compile("^BITMAP$")

char = None
line = sys.stdin.readline()
while line:
    menc = encoding_re.match(line)
    if menc:
        # new char found, save the codepoint
        char = int(menc.group(1))
    elif bitmap_re.match(line):
        # bitmap start, read the following 16 lines to get the glyph
        glyph = []
        for _ in range(16):
            line = sys.stdin.readline()
            byte = int(line, 16)
            glyph.append(byte)
        # only save the full glyph in the dict if this is one of our codepoints
        if char in codepoints:
            glyphs[char] = glyph
    line = sys.stdin.readline()

# Once we read the full bdf file, we can emit the glyphs for the 256 chars
for char in range(256):
    cp = codepoints_map[char]
    glyph = glyphs[cp]
    for byte in glyph:
        print(f'{byte:02X}')
