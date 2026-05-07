#!/bin/bash

# packages
# sed -i 's|src-git packages https://github.com/[^/]*/packages|src-git packages https://github.com/xuxin1955/packages|' feeds.conf.default

# password
# sed -i '/sed -i .*root::0:0:.*$1\$V4UetPzk\$CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings
# sed -i '/sed -i .*root:::0:.*$1\$V4UetPzk\$CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings


# 调试
echo 'src-git-full openstick https://github.com/xuxin1955/openstick-feeds.git' >> feeds.conf.default

