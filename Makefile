AS=asl
P2BIN=p2bin
SRC=patch.s
BSPLIT=bsplit
MAME=mame

ASFLAGS=-i . -n -U

.PHONY: prg.u29

all: prg.u29

prg.o: prg.orig
	$(AS) $(SRC) $(ASFLAGS) -o prg.o

prg.u29: prg.o
	$(P2BIN) $< prg.bin -r \$$-0x7FFFF
	$(BSPLIT) x prg.bin $@
	rm prg.o
	rm prg.bin

test: prg.u29
	$(MAME) -debug donpachij

clean:
	@-rm -f prg.bin
	@-rm -f prg.o
	bsplit x prg.orig prg.u29
