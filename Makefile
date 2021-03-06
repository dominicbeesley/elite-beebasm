BEEBASM?=beebasm
PYTHON?=python

.PHONY:build
build:
	echo _REMOVE_CHECKSUMS=TRUE > elite-header.h.asm
	echo _FIX_REAR_LASER=TRUE >> elite-header.h.asm
	$(BEEBASM) -i elite-source.asm -v > compile.txt
	$(BEEBASM) -i elite-bcfs.asm -v >> compile.txt
	$(BEEBASM) -i elite-loader.asm -v >> compile.txt
	$(PYTHON) elite-checksum.py -u
	$(BEEBASM) -i elite-disc.asm -do elite.ssd -boot ELITE

.PHONY:encrypt
encrypt:
	echo _REMOVE_CHECKSUMS=FALSE > elite-header.h.asm
	echo _FIX_REAR_LASER=TRUE >> elite-header.h.asm
	$(BEEBASM) -i elite-source.asm -v > compile.txt
	$(BEEBASM) -i elite-bcfs.asm -v >> compile.txt
	$(BEEBASM) -i elite-loader.asm -v >> compile.txt
	$(PYTHON) elite-checksum.py
	$(BEEBASM) -i elite-disc.asm -do elite.ssd -boot ELITE

.PHONY:extract
extract:
	echo _REMOVE_CHECKSUMS=FALSE > elite-header.h.asm
	echo _FIX_REAR_LASER=FALSE >> elite-header.h.asm
	$(BEEBASM) -i elite-source.asm -v > compile.txt
	$(BEEBASM) -i elite-bcfs.asm -v >> compile.txt
	$(BEEBASM) -i elite-loader.asm -v >> compile.txt
	$(PYTHON) elite-checksum.py
	$(BEEBASM) -i elite-disc.asm -do elite.ssd -boot ELITE

.PHONY:verify
verify:
	@$(PYTHON) crc32.py extracted output
