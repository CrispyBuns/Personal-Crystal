#!/usr/bin/env bash
#
# fast-build-ryzen2700.sh - optimized wrapper around the project's
# Makefile, tuned specifically for the AMD Ryzen 7 2700 (Zen+, 8c/16t).
#
# What it does that plain `make` doesn't:
#   1. Runs the build with -j = number of hardware threads (16)
#   2. Uses ccache when available, so incremental/repeat builds skip
#      recompiling unchanged translation units
#   3. Overrides the Makefile's -march=native with explicit
#      -march=znver1 -mtune=znver1 tuning for this CPU
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
#   ./fast-build-ryzen2700.sh            # build (make all)
#   ./fast-build-ryzen2700.sh clean      # clean
#   ./fast-build-ryzen2700.sh -- <args>  # pass extra args straight to make

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
# 3. CPU tuning: AMD Ryzen 7 2700 (Zen+, 8c/16t)
# ---------------------------------------------------------------
CPU_MODEL=""
if [[ -r /proc/cpuinfo ]]; then
  CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')
elif command -v sysctl >/dev/null 2>&1; then
  CPU_MODEL=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "")
fi
echo "==> Detected CPU: ${CPU_MODEL:-unknown}"
if [[ -n "$CPU_MODEL" ]] && ! echo "$CPU_MODEL" | grep -qi "Ryzen 7 2700"; then
  echo "==> Warning: this script is tuned for a Ryzen 7 2700; building anyway with znver1 flags."
fi

# Helper: does the active compiler accept -march=<name>?
compiler_supports_march() {
  echo 'int main(void){return 0;}' | "$REAL_CC" -march="$1" -x c -c -o /dev/null - >/dev/null 2>&1
}

# Zen+ -> znver1 (gcc 8+/clang 6+); already AVX2-capable.
if compiler_supports_march znver1; then
  ARCH_FLAGS="-march=znver1 -mtune=znver1"
else
  echo "==> Compiler doesn't recognize -march=znver1, falling back to -march=native"
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
