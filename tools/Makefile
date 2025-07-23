.PHONY: all clean

CC := gcc
CFLAGS =  -O2  -march=native -flto -std=c17 -Wall -Wextra -pedantic \
         -Walloc-zero \
         -Wcast-align \
         -Wcast-qual \
         -Wduplicated-branches \
         -Wduplicated-cond \
         -Wfloat-equal \
         -Wformat=2 \
         -Wformat-overflow=2 \
         -Wformat-truncation=1 \
         -Winline \
         -Wlogical-op \
         -Wnested-externs \
         -Wno-sign-compare \
         -Wnull-dereference \
         -Wold-style-definition \
         -Wshadow \
         -Wshift-overflow \
         -Wstrict-overflow=2 \
         -Wstrict-prototypes \
         -Wshift-overflow \
         -Wundef \
         -Wuninitialized \
         -Wunused \
         -Wwrite-strings

tools := \
	bankends \
	bpp2png \
	bspcomp \
	gfx \
	lzcomp \
	make_patch \
	png_dimensions \
	pokemon_animation \
	pokemon_animation_graphics \
	scan_includes \
	vwf

all: $(tools)
	@:

clean:
	$(RM) $(tools) *.o *.h.gch *.pyc

gfx: common.h
png_dimensions: common.h
pokemon_animation: common.h
pokemon_animation_graphics: common.h
scan_includes: common.h
vwf: common.h

bpp2png: bpp2png.c lodepng/lodepng.c common.h lodepng/lodepng.h
	$(CC) $(CFLAGS) -o $@ bpp2png.c lodepng/lodepng.c

lzcomp: CFLAGS += -Wno-strict-overflow -Wno-sign-compare
lzcomp: $(wildcard lz/*.c) $(wildcard lz/*.h)
	$(CC) $(CFLAGS) -o $@ lz/*.c

bspcomp: bsp/bspcomp.c
	$(CC) $(CFLAGS) -o $@ $^

bankends: bankends.c parsemap.o
	$(CC) $(CFLAGS) -o $@ $^

parsemap.o: parsemap.c parsemap.h
	$(CC) $(CFLAGS) -c $^

%: %.c
	$(CC) $(CFLAGS) -o $@ $<
