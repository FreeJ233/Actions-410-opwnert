#!/bin/bash
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-material/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# temp
git clone https://github.com/xuxin1955/luci-app-cpu-perf package/luci-app-cpu-perf
git clone https://github.com/xuxin1955/luci-app-temp-status package/luci-app-temp-status

# DbusSmsForwardCPlus
git clone https://github.com/lkiuyu/DbusSmsForwardCPlus package/DbusSmsForwardCPlus


