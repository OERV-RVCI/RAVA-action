#!/bin/bash
set -e
set -x


repo_name="$(echo "${REPO%.git}" | awk -F'/' '{print $(NF-1)"_"$NF}')"
kernel_result_dir="${repo_name}_pr_${ISSUE_ID}"
download_server=10.213.6.54
download_server_dir='/usr/share/nginx/html/download/kernel-build-results'
kernel_download_url="http://${download_server}/kernel-build-results/${kernel_result_dir}/Image"


## build kernel
export ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu-

make distclean
make openeuler_defconfig
make Image -j$(nproc)
make modules -j$(nproc)
make dtbs -j$(nproc)

make INSTALL_MOD_PATH="$kernel_result_dir" modules_install -j$(nproc)
mkdir -p "$kernel_result_dir/dtb/thead"
cp vmlinux "$kernel_result_dir"
cp arch/riscv/boot/Image "$kernel_result_dir"
install -m 644 $(find arch/riscv/boot/dts/ -name "*.dtb") "$kernel_result_dir"/dtb
mv $(find arch/riscv/boot/dts/ -name "th1520*.dtb") "$kernel_result_dir"/dtb/thead


## publish kernel
if [ -f "${kernel_result_dir}/Image" ]; then
	for((i=0; i<10; i++)); do
		if rsync -avz --delete -e 'ssh -i sshkey -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes' "${kernel_result_dir}" root@${download_server}:"${download_server_dir}"; then
			break
		fi
	done
else
	echo "Kernel not found!"
	exit 1
fi

# pass download url
echo "${kernel_download_url}" > kernel_download_url
