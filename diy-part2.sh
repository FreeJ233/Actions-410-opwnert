#!/bin/bash
# DIY脚本
# https://github.com/P3TERX/Actions-OpenWrt
# 文件名: diy-part2.sh
# 功能说明: OpenWrt DIY脚本第2部分（更新feeds之后）
# 版权: (c) 2019-2024 P3TERX <https://p3terx.com>
# 基于 MIT 开源协议，详见 /LICENSE

# 修改默认IP地址
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# 修改默认主题为 argon（路径不存在时跳过，不中断编译）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile 2>/dev/null || true

# 启用 IPv4 策略路由（直接写入内核 platform config，绕过 make defconfig 的依赖检查）
for cfg in target/linux/msm89xx/config-*; do
  grep -q 'CONFIG_IP_ADVANCED_ROUTER' "$cfg" || echo 'CONFIG_IP_ADVANCED_ROUTER=y' >> "$cfg"
  grep -q 'CONFIG_IP_MULTIPLE_TABLES' "$cfg" || echo 'CONFIG_IP_MULTIPLE_TABLES=y' >> "$cfg"
done

# ----- 添加用户指定的内核选项（写入内核配置文件） -----
# 注意：以下 CONFIG_KERNEL_* 选项会转换为内核 CONFIG_* 写入 target/linux/msm89xx/config-*
for cfg in target/linux/msm89xx/config-*; do
  # CONFIG_DEBUG_INFO=y
  grep -q 'CONFIG_DEBUG_INFO=y' "$cfg" || echo 'CONFIG_DEBUG_INFO=y' >> "$cfg"
  # CONFIG_DEBUG_INFO_REDUCED=n  -> 禁用，写入 # CONFIG_DEBUG_INFO_REDUCED is not set
  grep -q 'CONFIG_DEBUG_INFO_REDUCED' "$cfg" || echo '# CONFIG_DEBUG_INFO_REDUCED is not set' >> "$cfg"
  # CONFIG_DEBUG_INFO_BTF=y
  grep -q 'CONFIG_DEBUG_INFO_BTF=y' "$cfg" || echo 'CONFIG_DEBUG_INFO_BTF=y' >> "$cfg"
  # CONFIG_CGROUPS=y
  grep -q 'CONFIG_CGROUPS=y' "$cfg" || echo 'CONFIG_CGROUPS=y' >> "$cfg"
  # CONFIG_CGROUP_BPF=y
  grep -q 'CONFIG_CGROUP_BPF=y' "$cfg" || echo 'CONFIG_CGROUP_BPF=y' >> "$cfg"
  # CONFIG_BPF_EVENTS=y
  grep -q 'CONFIG_BPF_EVENTS=y' "$cfg" || echo 'CONFIG_BPF_EVENTS=y' >> "$cfg"
  # CONFIG_XDP_SOCKETS=y
  grep -q 'CONFIG_XDP_SOCKETS=y' "$cfg" || echo 'CONFIG_XDP_SOCKETS=y' >> "$cfg"
done

# ----- 添加 OpenWrt 编译配置选项（写入 .config） -----
# 这些选项不属于内核配置，需修改 OpenWrt 根目录下的 .config 文件
CONFIG_FILE=".config"
if [ -f "$CONFIG_FILE" ]; then
  # CONFIG_DEVEL=y
  grep -q 'CONFIG_DEVEL=y' "$CONFIG_FILE" || echo 'CONFIG_DEVEL=y' >> "$CONFIG_FILE"
  # CONFIG_BPF_TOOLCHAIN_HOST=y
  grep -q 'CONFIG_BPF_TOOLCHAIN_HOST=y' "$CONFIG_FILE" || echo 'CONFIG_BPF_TOOLCHAIN_HOST=y' >> "$CONFIG_FILE"
  # CONFIG_PACKAGE_kmod-xdp-sockets-diag=y
  grep -q 'CONFIG_PACKAGE_kmod-xdp-sockets-diag=y' "$CONFIG_FILE" || echo 'CONFIG_PACKAGE_kmod-xdp-sockets-diag=y' >> "$CONFIG_FILE"
else
  echo "警告：未找到 .config 文件，跳过 OpenWrt 选项设置。"
fi

# 临时添加的插件（以下保持注释，需要时自行取消）
# git clone https://github.com/lkiuyu/luci-app-cpu-perf package/luci-app-cpu-perf
# git clone https://github.com/lkiuyu/luci-app-cpu-status package/luci-app-cpu-status
# git clone https://github.com/gSpotx2f/luci-app-cpu-status-mini package/luci-app-cpu-status-mini
# git clone https://github.com/lkiuyu/luci-app-temp-status package/luci-app-temp-status
# git clone https://github.com/lkiuyu/DbusSmsForwardCPlus package/DbusSmsForwardCPlus
