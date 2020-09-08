#!/usr/bin/env python
#
# ******************************************************************************
#
# ELITE CHECKSUM SCRIPT
#
# Written by Kieran Connell
#
# This script applies encryption, checksums and obfuscation to the compiled
# binaries for the main game and the loader. The script has two parts:
#
#   * The first part generates an encrypted version of the main game's "ELTcode"
#     binary, based on the code in the original "S.BCFS" BASIC source program
#
#   * The second part generates an encrypted version of the main game's "ELITE"
#     binary, based on the code in the original "ELITES" BASIC source program
#
# ******************************************************************************

from __future__ import print_function
import sys
import re
from os.path import basename


def cmpaddr(x):
    return x[1]

if (sys.version_info > (3, 0)):
    from io import BytesIO as ByteBuffer
else:
    from StringIO import StringIO as ByteBuffer

argv = sys.argv
argc = len(argv)

print("%s" % argc)

if argc != 3:
    raise Exception("Arguments")

syms = []

with open(argv[1], "r") as in_f:
    for l in in_f:
        m = re.match(r'^\[{(.*)?}\]', l)
        if m != None:
            for s in re.split(r',', m.group(1)):
                m2 = re.match(r"^'([^']+)':([0-9]+)L$", s)
                if m2 == None:
                    raise Exception("Bad symbol entry " + s)
                else:
                    syms.append((m2.group(1).replace("%","_"), int(m2.group(2))))
                

syms.sort(key=cmpaddr)

with open(argv[2], "w") as out_f:
    for s in syms:
        out_f.write("DEF %s %04X\n" % s)

