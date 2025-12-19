.PHONY: all clean

# -------------------------------------------------
# Compiler
# -------------------------------------------------
CC ?= cc

# -------------------------------------------------
# Detect compiler
# -------------------------------------------------
CC_VERSION := $(shell $(CC) --version 2>/dev/null | head -n 1)
IS_CLANG := $(findstring clang,$(CC_VERSION))

# -------------------------------------------------
# Base flags (always safe)
# -------------------------------------------------
BASE_CFLAGS := -O2 -std=c17 -Wall -Wextra -pedantic

# -------------------------------------------------
# GCC-only warnings
# -------------------------------------------------
GCC_WARNINGS := \
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
	-Wnull-dereference \
	-Wold-style-definition \
	-Wshift-overflow=2 \
	-Wstrict-overflow=2 \
	-Wstringop-overflow=4 \
	-Wundef \
	-Wuninitialized \
	-Wwrite-strings

# -------------------------------------------------
# Clang warnings
# -------------------------------------------------
CLANG_WARNINGS := \
	-Wcast-align \
	-Wcast-qual \
	-Wfloat-equal \
	-Wformat=2 \
	-Wshadow \
	-Wstrict-prototypes \
	-Wundef \
	-Wwrite-strings \
	-Wnewline-eof

COMMON_NOWARN := -Wno-sign-compare

# -------------------------------------------------
# CPU feature detection
# -------------------------------------------------
ARCH := $(shell uname -m)

SSE2_SUPPORTED := $(shell echo 'int main(void){return 0;}' | \
	$(CC) -msse2 -x c - -o /dev/null >/dev/null 2>&1 && echo yes)

SSE42_SUPPORTED := $(shell echo 'int main(void){return 0;}' | \
	$(CC) -msse4.2 -x c - -o /dev/null >/dev/null 2>&1 && echo yes)

AVX2_SUPPORTED := $(shell echo 'int main(void){return 0;}' | \
	$(CC) -mavx2 -x c - -o /dev/null >/dev/null 2>&1 && echo yes)

NEON_SUPPORTED := $(shell echo 'int main(void){return 0;}' | \
	$(CC) -mfpu=neon -x c - -o /dev/null >/dev/null 2>&1 && echo yes)

# -------------------------------------------------
# Feature tests (LTO + linker)
# -------------------------------------------------
LTO_SUPPORTED := $(shell echo 'int main(void){return 0;}' | \
	$(CC) -flto -x c - -o /dev/null >/dev/null 2>&1 && echo yes)

LLD_SUPPORTED := $(shell echo 'int main(void){return 0;}' | \
	$(CC) -fuse-ld=lld -x c - -o /dev/null >/dev/null 2>&1 && echo yes)

GOLD_SUPPORTED := $(shell echo 'int main(void){return 0;}' | \
	$(CC) -fuse-ld=gold -x c - -o /dev/null >/dev/null 2>&1 && echo yes)

# -------------------------------------------------
# Select warnings
# -------------------------------------------------
ifeq ($(IS_CLANG),clang)
CWARNINGS := $(CLANG_WARNINGS)
$(info using Clang)
else
CWARNINGS := $(GCC_WARNINGS)
$(info using GCC)
endif

# -------------------------------------------------
# CPU flags
# -------------------------------------------------
CPU_CFLAGS :=

ifneq (,$(findstring x86,$(ARCH)))
ifeq ($(AVX2_SUPPORTED),yes)
CPU_CFLAGS += -mavx2
$(info using AVX2)
else ifeq ($(SSE42_SUPPORTED),yes)
CPU_CFLAGS += -msse4.2
$(info using SSE4.2)
else ifeq ($(SSE2_SUPPORTED),yes)
CPU_CFLAGS += -msse2
$(info using SSE2)
endif
endif

ifneq (,$(findstring arm,$(ARCH)))
ifeq ($(NEON_SUPPORTED),yes)
CPU_CFLAGS += -mfpu=neon
$(info using NEON)
endif
endif

# -------------------------------------------------
# Linker selection
# -------------------------------------------------
LDFLAGS :=

ifeq ($(LLD_SUPPORTED),yes)
LDFLAGS += -fuse-ld=lld
$(info using lld)
else ifeq ($(GOLD_SUPPORTED),yes)
LDFLAGS += -fuse-ld=gold
$(info using gold)
else
$(info using default linker)
endif

# -------------------------------------------------
# Final CFLAGS
# -------------------------------------------------
ifeq ($(LTO_SUPPORTED),yes)
CFLAGS := $(BASE_CFLAGS) $(CWARNINGS) $(COMMON_NOWARN) $(CPU_CFLAGS) -flto
$(info LTO enabled)
else
CFLAGS := $(BASE_CFLAGS) $(CWARNINGS) $(COMMON_NOWARN) $(CPU_CFLAGS)
$(info LTO disabled)
endif

# -------------------------------------------------
# Tools (original)
# -------------------------------------------------
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

# -------------------------------------------------
# Header deps
# -------------------------------------------------
gfx: common.h
png_dimensions: common.h
pokemon_animation: common.h
pokemon_animation_graphics: common.h
scan_includes: common.h
vwf: common.h

# -------------------------------------------------
# Build rules
# -------------------------------------------------
bpp2png: bpp2png.c lodepng/lodepng.c common.h lodepng/lodepng.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ bpp2png.c lodepng/lodepng.c

lzcomp: CFLAGS += -Wno-strict-overflow -Wno-sign-compare
lzcomp: $(wildcard lz/*.c) $(wildcard lz/*.h)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ lz/*.c

bspcomp: bsp/bspcomp.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

bankends: bankends.c parsemap.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

parsemap.o: parsemap.c parsemap.h
	$(CC) $(CFLAGS) -c $^

%: %.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
