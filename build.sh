#!/usr/bin/env bash

# VMware Workstation 安装目录
VMwarePath="C:\Program Files (x86)\VMware\VMware Workstation"

# VMware Workstation 虚拟机目录
VMwareVirtual="D:\Virtual"

export VMwarePath
export VMwareVirtual

# 没钱买 Vmware provider 的许可证
#./builds/vmware.sh
./builds/virtualbox.sh $1