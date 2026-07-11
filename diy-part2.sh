#!/bin/bash
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-material/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# DbusSmsForwardCPlus
git clone https://github.com/lkiuyu/DbusSmsForwardCPlus package/DbusSmsForwardCPlus

# 北大源
cp -r "$GITHUB_WORKSPACE/scripts/files-8916" "$GITHUB_WORKSPACE/openwrt/files"
ls -R "$GITHUB_WORKSPACE/openwrt/files"

# 防重复追加函数
add_config() {
    grep -qxF "$1" .config || echo "$1" >> .config
}

# 原有 daed 相关配置
add_config "CONFIG_KERNEL_DEBUG_INFO=y"
add_config "CONFIG_KERNEL_DEBUG_INFO_BTF=y"
add_config "CONFIG_KERNEL_CGROUPS=y"
add_config "CONFIG_KERNEL_CGROUP_BPF=y"
add_config "CONFIG_PACKAGE_luci-app-daed=y"
add_config "CONFIG_PACKAGE_daed=y"
add_config "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y"

# 新增的内核配置（转换后）
add_config "CONFIG_KERNEL_BPF=y"
add_config "CONFIG_KERNEL_BPF_SYSCALL=y"
add_config "CONFIG_KERNEL_BPF_JIT=y"
# CONFIG_KERNEL_CGROUPS=y 已存在，无需重复
add_config "CONFIG_KERNEL_KPROBES=y"
add_config "CONFIG_KERNEL_NET_INGRESS=y"
add_config "CONFIG_KERNEL_NET_EGRESS=y"
add_config "CONFIG_KERNEL_NET_SCH_INGRESS=m"
add_config "CONFIG_KERNEL_NET_CLS_BPF=m"
add_config "CONFIG_KERNEL_NET_CLS_ACT=y"
add_config "CONFIG_KERNEL_BPF_STREAM_PARSER=y"
# 取消 DEBUG_INFO_REDUCED（确保完整调试信息）
grep -q "CONFIG_KERNEL_DEBUG_INFO_REDUCED=y" .config && sed -i 's/CONFIG_KERNEL_DEBUG_INFO_REDUCED=y/# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set/' .config
add_config "# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set"
add_config "CONFIG_KERNEL_KPROBE_EVENTS=y"
add_config "CONFIG_KERNEL_BPF_EVENTS=y"

# 修复依赖问题（强制让编译系统检查依赖）
make defconfig

./scripts/feeds update -a
./scripts/feeds install -a
