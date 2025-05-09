#!/bin/bash
set -e
set -x

export ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu-
make distclean
git checkout .
./tools/testing/kunit/kunit.py run --arch=riscv
