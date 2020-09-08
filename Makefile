BEEBASM?=beebasm
PYTHON?=python

.PHONY:build

blit:
	echo _REMOVE_CHECKSUMS=TRUE > elite-header.h.asm
	echo _FIX_REAR_LASER=TRUE >> elite-header.h.asm
	echo BLITTER=TRUE >> elite-header.h.asm
	$(BEEBASM) -d -i elite-source.asm -v > compile.txt
	$(BEEBASM) -i elite-bcfs.asm -v >> compile.txt
	$(BEEBASM) -i elite-loader.asm -v >> compile.txt
	$(PYTHON) elite-checksum.py -u
	$(BEEBASM) -i elite-disc.asm -do elite.ssd -boot ELITE
	$(PYTHON) get-symbols.py compile.txt symbols_blitter.sym

build:
	echo _REMOVE_CHECKSUMS=TRUE > elite-header.h.asm
	echo _FIX_REAR_LASER=TRUE >> elite-header.h.asm
	echo BLITTER=FALSE >> elite-header.h.asm
	$(BEEBASM) -d -i elite-source.asm -v > compile.txt
	$(BEEBASM) -i elite-bcfs.asm -v >> compile.txt
	$(BEEBASM) -i elite-loader.asm -v >> compile.txt
	$(PYTHON) elite-checksum.py -u
	$(BEEBASM) -i elite-disc.asm -do elite.ssd -boot ELITE
	$(PYTHON) get-symbols.py compile.txt symbols_build.sym

.PHONY:encrypt
encrypt:
	echo _REMOVE_CHECKSUMS=FALSE > elite-header.h.asm
	echo _FIX_REAR_LASER=TRUE >> elite-header.h.asm
	echo BLITTER=FALSE >> elite-header.h.asm
	$(BEEBASM) -i elite-source.asm -v > compile.txt
	$(BEEBASM) -i elite-bcfs.asm -v >> compile.txt
	$(BEEBASM) -i elite-loader.asm -v >> compile.txt
	$(PYTHON) elite-checksum.py
	$(BEEBASM) -i elite-disc.asm -do elite.ssd -boot ELITE
	$(PYTHON) get-symbols.py compile.txt symbols_encrypt.sym

.PHONY:extract
extract:
	echo _REMOVE_CHECKSUMS=FALSE > elite-header.h.asm
	echo _FIX_REAR_LASER=FALSE >> elite-header.h.asm
	echo BLITTER=FALSE >> elite-header.h.asm
	$(BEEBASM) -i elite-source.asm -v > compile.txt
	$(BEEBASM) -i elite-bcfs.asm -v >> compile.txt
	$(BEEBASM) -i elite-loader.asm -v >> compile.txt
	$(PYTHON) elite-checksum.py
	$(BEEBASM) -i elite-disc.asm -do elite.ssd -boot ELITE
	$(PYTHON) get-symbols.py compile.txt symbols_extract.sym


.PHONY:verify
verify:
	@$(PYTHON) crc32.py extracted output
