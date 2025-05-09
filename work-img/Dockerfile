FROM debian:latest


RUN (type -p wget >/dev/null || (apt update &&apt-get install wget -y)) \
	&& mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
	
	RUN apt update && apt install gh -y

	RUN apt install gcc-riscv64-linux-gnu gcc-riscv64-unknown-elf \
	make gcc g++ flex device-tree-compiler pahole dwarves libfuse-dev kmod  bzip2 xz-utils curl cpio bc libssl-dev libncurses-dev bison flex libelf-dev \
	yq git vim bash-completion tmux \
	-y