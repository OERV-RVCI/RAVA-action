#!/bin/bash
set -e
set -x


cd kernel-src
kernel_result_dir=../kernel_result_dir
rootfs_download_url='https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/RVCK/openEuler24.03-LTS-SP1/openeuler-rootfs.img'

## build kernel
export ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu-

make distclean
make openeuler_defconfig
make Image -j"$(nproc)"
make modules -j"$(nproc)"
make dtbs -j"$(nproc)"

make INSTALL_MOD_PATH="$kernel_result_dir" modules_install -j"$(nproc)"
mkdir -p "$kernel_result_dir/dtb/thead"
cp vmlinux "$kernel_result_dir"
cp arch/riscv/boot/Image "$kernel_result_dir"
find arch/riscv/boot/dts/ -name "*.dtb" -exec install -m 644 {} "$kernel_result_dir"/dtb/{} \;
find arch/riscv/boot/dts/ -name "th1520*.dtb" -exec mv {} "$kernel_result_dir"/dtb/thead/ \;



if [ ! -f "${kernel_result_dir}/Image" ]; then
	echo "Kernel not found!"
	exit 1
fi
