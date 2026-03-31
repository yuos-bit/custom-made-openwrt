#!/bin/bash
#=================================================
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#=================================================
# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="MOLUN"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"MOLUN"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config

# 修改 edge 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
#sed -i 's/luci-theme-bootstrap/luci-theme-edge/g' openwrt/feeds/luci/collections/luci/Makefile

#Enable 802.11k/v/r
#sed -i 's/RRMEnable=0/RRMEnable=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.2G.dat
#sed -i 's/RRMEnable=0/RRMEnable=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.5G.dat
#sed -i 's/FtSupport=0/FtSupport=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.2G.dat
#sed -i 's/FtSupport=0/FtSupport=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.5G.dat
#echo 'WNMEnable=1' >> package/kernel/mt-drivers/mt_wifi/files/mt7615.1.2G.dat
#echo 'WNMEnable=1' >> package/kernel/mt-drivers/mt_wifi/files/mt7615.1.5G.dat

# 测试编译时间
YUOS_DATE="$(date +%Y.%m.%d)(openwrt-23.05开发版)"
BUILD_STRING=${BUILD_STRING:-$YUOS_DATE}
echo "Write build date in openwrt : $BUILD_DATE"
echo -e '\n 小渔学长 Build @ '${BUILD_STRING}'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION=''" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='小渔学长 Build @ ${BUILD_STRING}'" >> package/base-files/files/etc/openwrt_release

# 修改 luci version.lua
sed -i '/luciversion/d' feeds/luci/modules/luci-base/luasrc/version.lua
echo "luciversion = '${BUILD_STRING}'" >> feeds/luci/modules/luci-base/luasrc/version.lua

# 修补防火墙NAT补丁
#cp -rf $GITHUB_WORKSPACE/patchs/5.10/zones.js $GITHUB_WORKSPACE/openwrt/feeds/luci/applications/luci-app-firewall/htdocs/luci-static/resources/view/firewall/zones.js

#升级golang
rm -rf feeds/packages/lang/golang
find . -type d -name "golang" -prune -exec rm -rf {} \;
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

#删除电台配置插件
./scripts/feeds uninstall {mmdvm,mmdvm-host,p25-clients,ysf-clients,nxdn-clients,mmdvm-luci,dapnet-gateway,ircddb-gateway,libmmdvm,libwxwidgets,mmdvm-cal}
