#!/usr/bin/env bash
#
# fast-build-i7-11th.sh - optimized wrapper around the project's
# Makefile, tuned specifically for Intel Core i7 11th Gen (8c/16t).
#
# Covers both desktop ("Rocket Lake", e.g. i7-11700/11900) and mobile
# ("Tiger Lake", e.g. i7-1165G7) variants; defaults to desktop tuning
# — set CPU_VARIANT=mobile to switch (see step 3 below).
#
# What it does that plain `make` doesn't:
#   1. Runs the build with -j = number of hardware threads (16)
#   2. Uses ccache when available, so incremental/repeat builds skip
#      recompiling unchanged translation units
#   3. Overrides the Makefile's -march=native with explicit tuning
#      (-march=rocketlake, or -march=tigerlake for CPU_VARIANT=mobile)
#   4. Parallelizes LTO itself (GCC: -flto=N partitions; Clang: ThinLTO),
#      instead of the LTO backend running single-threaded at link time
#   5. Uses lld as the linker if installed, since -flto + the default
#      bfd link is one of the slowest steps here (mold/gold are ELF-only
#      and can't be used for MinGW64's native PE/COFF .exe output)
#   6. Times the build so you can see the effect
#
# Target environment: MSYS2 "MinGW x64" shell (MSYSTEM=MINGW64), i.e.
# a native x86_64 Windows build, not the plain MSYS2 or MINGW32 shells.
#
# Usage:
#   ./fast-build-i7-11th.sh                        # build (make all), desktop tuning
#   CPU_VARIANT=mobile ./fast-build-i7-11th.sh      # mobile (Tiger Lake) tuning
#   ./fast-build-i7-11th.sh clean                   # clean
#   ./fast-build-i7-11th.sh -- <args>                # pass extra args straight to make

set -euo pipefail

# ---------------------------------------------------------------
# 0. Sanity check: this script targets MSYS2 MinGW64
# ---------------------------------------------------------------
if [[ "${MSYSTEM:-}" != "MINGW64" ]]; then
  echo "==> Warning: MSYSTEM=${MSYSTEM:-unset}, expected MINGW64."
  echo "    Launch the 'MSYS2 MinGW x64' shell (not plain MSYS2 or MINGW32),"
  echo "    otherwise the compiler will target Cygwin/32-bit instead of native x64."
fi

# ---------------------------------------------------------------
# 1. Job count: physical/logical threads available
# ---------------------------------------------------------------
if command -v nproc >/dev/null 2>&1; then
  JOBS=$(nproc)
elif [[ -n "${NUMBER_OF_PROCESSORS:-}" ]]; then
  # Windows always sets this env var; MSYS2 inherits it.
  JOBS="$NUMBER_OF_PROCESSORS"
else
  JOBS=4
fi
echo "==> Using -j${JOBS}"

# ---------------------------------------------------------------
# 2. Compiler + ccache
# ---------------------------------------------------------------
# MinGW64 ships gcc, not a "cc" symlink, so fall back to gcc.
if [[ -n "${CC:-}" ]]; then
  CC_BIN="$CC"
elif command -v cc >/dev/null 2>&1; then
  CC_BIN="cc"
else
  CC_BIN="gcc"
fi
if command -v ccache >/dev/null 2>&1; then
  if [[ "$CC_BIN" != ccache* ]]; then
    export CC="ccache ${CC_BIN}"
  fi
  export CCACHE_SLOPPINESS="pch_defines,time_macros"
  echo "==> ccache enabled ($(ccache --version | head -1))"
else
  export CC="$CC_BIN"
  echo "==> ccache not found (install it for much faster rebuilds: pacman -S mingw-w64-x86_64-ccache)"
fi

# Detect the *real* underlying compiler (strip ccache) to know if it's clang or gcc
REAL_CC="${CC##* }"
IS_CLANG=0
if "$REAL_CC" --version 2>/dev/null | grep -qi clang; then
  IS_CLANG=1
fi

# ---------------------------------------------------------------
# 3. CPU tuning: Intel Core i7 11th Gen (Rocket Lake / Tiger Lake)
# ---------------------------------------------------------------
CPU_MODEL=""
if [[ -r /proc/cpuinfo ]]; then
  CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')
elif command -v sysctl >/dev/null 2>&1; then
  CPU_MODEL=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "")
fi
echo "==> Detected CPU: ${CPU_MODEL:-unknown}"
if [[ -n "$CPU_MODEL" ]] && ! echo "$CPU_MODEL" | grep -qiE "i7-11[0-9]{2,3}|i7-11th|11th Gen.*i7"; then
  echo "==> Warning: this script is tuned for an Intel i7 11th Gen; building anyway."
fi

# Helper: does the active compiler accept -march=<name>?
compiler_supports_march() {
  echo 'int main(void){return 0;}' | "$REAL_CC" -march="$1" -x c -c -o /dev/null - >/dev/null 2>&1
}

# Desktop 11th gen (i7-11700/11900, "Rocket Lake") vs mobile 11th gen
# (i7-1165G7-style, "Tiger Lake") use different -march names. Default
# to the desktop target since that's the common case with a MinGW64
# toolchain build; override by setting CPU_VARIANT=mobile if needed.
CPU_VARIANT="${CPU_VARIANT:-desktop}"
if [[ "$CPU_VARIANT" == "mobile" ]]; then
  MARCH_CANDIDATES=(tigerlake icelake-client skylake-avx512)
else
  MARCH_CANDIDATES=(rocketlake icelake-client skylake-avx512)
fi

DETECTED_MARCH=""
for m in "${MARCH_CANDIDATES[@]}"; do
  if compiler_supports_march "$m"; then DETECTED_MARCH="$m"; break; fi
done

if [[ -n "$DETECTED_MARCH" ]]; then
  ARCH_FLAGS="-march=${DETECTED_MARCH} -mtune=${DETECTED_MARCH}"
else
  echo "==> Compiler doesn't recognize any 11th-gen march name, falling back to -march=native"
  ARCH_FLAGS="-march=native -mtune=native -mfpmath=sse -msse4.2 -mavx2"
fi
echo "==> Using ARCH_FLAGS: ${ARCH_FLAGS}"

# ---------------------------------------------------------------
# 4. Parallel LTO
# ---------------------------------------------------------------
EXTRA_CFLAGS=""
if [[ "$IS_CLANG" -eq 1 ]]; then
  # Clang defaults to ThinLTO with -flto=thin, which is already
  # parallel; just make sure we use the thin variant explicitly.
  EXTRA_CFLAGS="-flto=thin"
else
  # GCC: partition LTO work across $JOBS link-time worker processes.
  EXTRA_CFLAGS="-flto=${JOBS}"
fi

# ---------------------------------------------------------------
# 5. Fast linker, if available
# ---------------------------------------------------------------
# mold and gold only produce ELF, so they're not usable here since
# MinGW64 links native PE/COFF .exe files. lld does support PE/COFF
# and is the only faster-linker option on this target.
EXTRA_LDFLAGS=""
if command -v ld.lld >/dev/null 2>&1 || command -v lld >/dev/null 2>&1; then
  if "$REAL_CC" -fuse-ld=lld -Wl,--version >/dev/null 2>&1; then
    EXTRA_LDFLAGS="-fuse-ld=lld"
    echo "==> Using lld linker"
  fi
fi
[[ -z "$EXTRA_LDFLAGS" ]] && echo "==> lld not found, using default linker (install with: pacman -S mingw-w64-x86_64-lld)"

# ---------------------------------------------------------------
# 6. Run make
# ---------------------------------------------------------------
TARGET="${1:-all}"
if [[ "$TARGET" == "--" ]]; then
  shift
fi

echo "==> Building target '${TARGET}' with CC=${CC}"
time make -j"${JOBS}" \
  CC="${CC}" \
  ARCH_FLAGS="${ARCH_FLAGS}" \
  CFLAGS_BASE="-O2 -flto -std=c17 -pedantic ${ARCH_FLAGS} ${EXTRA_CFLAGS}" \
  LDFLAGS="-flto -s ${EXTRA_LDFLAGS}" \
  "${TARGET}" "$@"

echo "==> Done."
