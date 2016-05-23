#!/usr/bin/env bash
#配置ssh
sed -i '/UseDNS/cUseDNS no' /etc/ssh/sshd_config

# 修改本地位置
echo "LC_ALL=zh_CN.UTF-8" > /etc/locale.conf
echo "LANG=zh_CN.UTF-8" >> /etc/locale.conf
localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 设置 时区
ln -sf /usr/share/zoneinfo/Hongkong /etc/localtime

# 安装部分基础库
yum groupinstall -y "Development Tools"
yum install -y gcc gcc-c++
yum install -y wget curl vim net-tools bash-completion whois
yum install -y python python-devel python-pip supervisor

# 建立环境记录
mkdir -p /home/vagrant/.env