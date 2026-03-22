#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)

#更改软件源
#sed -i 's|https://git.openwrt.org/feed/packages.git;openwrt-21.02|https://github.com/immortalwrt/packages.git;openwrt-21.02|' feeds.conf.default
#sed -i 's|https://git.openwrt.org/project/luci.git;openwrt-22.03|https://github.com/immortalwrt/luci.git;openwrt-23.05|' feeds.conf.default
sed -i 's|https://git.openwrt.org/feed/routing.git;openwrt-22.03|https://github.com/openwrt/routing.git;openwrt-22.03|' feeds.conf.default
sed -i 's|https://git.openwrt.org/feed/telephony.git;openwrt-22.03|https://github.com/openwrt/telephony.git;openwrt-22.03|' feeds.conf.default

# 增加软件包
#sed -i 's#github.com/immortalwrt/packages.git;openwrt-21.02#github.com/yuos-bit/other.git;immortalwrt-packages-21.02#' feeds.conf.default
#sed -i 's#github.com/immortalwrt/luci.git;openwrt-21.02#github.com/yuos-bit/other.git;immortalwrt-luci-21.02#' feeds.conf.default
sed -i '$a src-git helloworld https://github.com/fw876/helloworld.git;master' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/openwrt-packages.git;master' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/jell.git;main' feeds.conf.default

# 修改默认第一排插件
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk

# # 修改默认第二排插件
sed -i 's/firewall4/firewall block-mount coremark kmod-nf-nathelper kmod-nf-nathelper-extra kmod-ipt-raw kmod-tun/g' include/target.mk

# # 修改默认第三排插件
sed -i 's/nftables/nftables iptables-mod-tproxy/g' include/target.mk

# # 修改默认第四排插件
sed -i 's/kmod-nft-offload/kmod-nft-offload curl ca-certificates/g' include/target.mk

# # 修改默认第五排插件
sed -i 's/odhcp6c/odhcp6c iptables-mod-tproxy iptables-mod-extra/g' include/target.mk

# # 修改默认第六排插件
sed -i 's/odhcpd-ipv6only/odhcpd-ipv6only ipset ip-full default-settings luci/g' include/target.mk

# 修改默认红米AC2100 wifi驱动为闭源驱动
sed -i 's/kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware/kmod-mt7603e kmod-mt7615d luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 单独拉取 default-settings
git clone -b custom-made-21.02 https://github.com/yuos-bit/other package/default-settings

# 单独拉取 lean包到package 目录
git clone -b main https://github.com/yuos-bit/other package/lean

# 设置闭源驱动开机自启
sed -i '2a ifconfig rai0 up\nifconfig ra0 up\nbrctl addif br-lan rai0\nbrctl addif br-lan ra0' package/base-files/files/etc/rc.local

##补充包##
# 单独拉取软件包
git clone -b debug https://github.com/yuos-bit/luci-theme-edge2 package/luci-theme-edge2
git clone -b passwall https://github.com/yuos-bit/other package/passwall