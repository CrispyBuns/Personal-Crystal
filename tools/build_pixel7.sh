#!/bin/bash
set -euo pipefail

# Pixel 7 / Tensor G2 (2x Cortex-X1, 2x Cortex-A78, 4x Cortex-A55, Armv8.2-A)
ARCH_FLAGS="-march=armv8.2-a+dotprod+fp16 -mtune=cortex-a78 -moutline-atomics"

tools=(
	bankends
	bpp2png
	bspcomp
	gfx
	lzcomp
	make_patch
	png_dimensions
	pokemon_animation
	pokemon_animation_graphics
	scan_includes
	vwf
)

for tool in "${tools[@]}"; do
	if [[ -f "$tool" ]]; then
		echo "Existing build artifacts found — running make clean first."
		make clean
		break
	fi
done

make -j4 ARCH_FLAGS="$ARCH_FLAGS" "$@"
