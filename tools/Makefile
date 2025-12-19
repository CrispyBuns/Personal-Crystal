.PHONY: all clean

CC ?= cc

# Detect Clang (cc may be gcc or clang)
IS_CLANG := $(shell $(CC) --version 2>/dev/null | grep -qi clang && echo 1)

# Base flags
CFLAGS_BASE = -O2 -flto -std=c17 -Wall -Wextra -pedantic

# ======================
# GCC warning set (original)
# ======================
CFLAGS_GCC = $(CFLAGS_BASE) \
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
	-Wshift-overflow=2 \
	-Wstrict-overflow=2 \
	-Wstrict-prototypes \
	-Wstringop-overflow=4 \
	-Wundef \
	-Wuninitialized \
	-Wunused \
	-Wwrite-strings

# ======================
# Clang warning set (equivalent intent)
# ======================
CFLAGS_CLANG = $(CFLAGS_BASE) \
	-Wcast-align \
	-Wcast-qual \
	-Wfloat-equal \
	-Wformat=2 \
	-Winline \
	-Wshadow \
	-Wstrict-prototypes \
	-Wundef \
	-Wuninitialized \
	-Wunused \
	-Wwrite-strings \
	-Wcomma \
	-Wconditional-uninitialized \
	-Wextra-semi \
	-Wmissing-prototypes

# Select flags
ifeq ($(IS_CLANG),1)
  CFLAGS := $(CFLAGS_CLANG)
else
  CFLAGS := $(CFLAGS_GCC)
endif

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
