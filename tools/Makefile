.PHONY: all clean

CC ?= cc

# ==============================================================
# Compiler Detection
# ==============================================================
IS_CLANG := $(shell $(CC) --version 2>/dev/null | grep -qi clang && echo 1)

# ==============================================================
# Architecture Optimization
# Cross-compile: set ARCH_FLAGS manually, e.g.:
#   make ARCH_FLAGS="-march=armv8-a -mtune=cortex-a72"
# Native (default): auto-detected below
# ==============================================================
ifndef ARCH_FLAGS
  UNAME_M := $(shell uname -m)

  ifeq ($(UNAME_M),x86_64)
    ARCH_FLAGS := -march=native -mtune=native -mfpmath=sse -msse4.2
  else ifeq ($(UNAME_M),aarch64)
    ARCH_FLAGS := -march=native -mtune=native
  else ifeq ($(UNAME_M),arm)
    ARCH_FLAGS := -march=native -mtune=native -mfpu=neon
  else
    # Safe fallback for unknown arch
    ARCH_FLAGS := -mtune=generic
  endif
endif

# ==============================================================
# Base Flags
# ==============================================================
CFLAGS_BASE = -O2 -flto -std=c17 -pedantic $(ARCH_FLAGS)

# ==============================================================
# GCC Warning Set
# ==============================================================
CFLAGS_GCC = $(CFLAGS_BASE) \
	-Walloc-zero           \
	-Wcast-align           \
	-Wcast-qual            \
	-Wduplicated-branches  \
	-Wduplicated-cond      \
	-Wfloat-equal          \
	-Wformat=2             \
	-Wformat-overflow=2    \
	-Wformat-truncation=1  \
	-Winline               \
	-Wlogical-op           \
	-Wnested-externs       \
	-Wno-sign-compare      \
	-Wnull-dereference     \
	-Wold-style-definition \
	-Wshadow               \
	-Wshift-overflow=2     \
	-Wstrict-overflow=2    \
	-Wstrict-prototypes    \
	-Wstringop-overflow=4  \
	-Wundef                \
	-Wuninitialized        \
	-Wunused               \
	-Wwrite-strings

# ==============================================================
# Clang Warning Set
# ==============================================================
CFLAGS_CLANG = $(CFLAGS_BASE)      \
	-Wcast-align                    \
	-Wcast-qual                     \
	-Wfloat-equal                   \
	-Wformat=2                      \
	-Winline                        \
	-Wshadow                        \
	-Wstrict-prototypes             \
	-Wundef                         \
	-Wuninitialized                 \
	-Wunused                        \
	-Wwrite-strings                 \
	-Wcomma                         \
	-Wconditional-uninitialized     \
	-Wextra-semi                    \
	-Wmissing-prototypes

ifeq ($(IS_CLANG),1)
  CFLAGS := $(CFLAGS_CLANG)
else
  CFLAGS := $(CFLAGS_GCC)
endif

# ==============================================================
# Linker Flags
# -flto is already in CFLAGS; pass it here too so the linker
# can drive LTO. Add -s to strip debug symbols in release.
# ==============================================================
LDFLAGS := -flto

# ==============================================================
# Tools
# ==============================================================
tools := \
	bankends              \
	bpp2png               \
	bspcomp               \
	gfx                   \
	lzcomp                \
	make_patch            \
	png_dimensions        \
	pokemon_animation     \
	pokemon_animation_graphics \
	scan_includes         \
	vwf

all: $(tools)
	@:

clean:
	$(RM) $(tools) *.o *.h.gch *.pyc

# ==============================================================
# Header dependencies (common.h)
# ==============================================================
gfx pokemon_animation pokemon_animation_graphics \
png_dimensions scan_includes vwf: common.h

# ==============================================================
# Per-target rules
# ==============================================================
bpp2png: bpp2png.c lodepng/lodepng.c common.h lodepng/lodepng.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ bpp2png.c lodepng/lodepng.c

# lzcomp: relax two warnings that fire legitimately in this unit
lzcomp: CFLAGS += -Wno-strict-overflow -Wno-sign-compare
lzcomp: $(wildcard lz/*.c) $(wildcard lz/*.h)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ lz/*.c

bspcomp: bsp/bspcomp.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

parsemap.o: parsemap.c parsemap.h
	$(CC) $(CFLAGS) -c parsemap.c -o $@

bankends: bankends.c parsemap.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# Generic rule for single-source tools
%: %.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
