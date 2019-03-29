AS=asl
P2BIN=p2bin
SRC=patch.s
BSPLIT=bsplit
MAME=mame
ROMDIR=/home/moffitt/.mame/roms/espradej

ASFLAGS=-i . -n -U

.PHONY: espradej

all: prg.bin

prg.o: prg.orig
	$(AS) $(SRC) $(ASFLAGS) -o prg.o

prg.bin: prg.o
	$(P2BIN) $< $@ -r \$$-0x7FFFF
	$(BSPLIT) x prg.bin prg.u29
	rm prg.o
	rm prg.bin

test: prg.bin
	$(MAME) -debug donpachij

clean:
	@-rm prg.bin
	@-rm prg.o
	bsplit x prg.orig prg.u29
