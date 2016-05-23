#!/usr/bin/env bash

# install required vagrant plugin to handle reloads during provisioning
vagrant plugin install vagrant-reload

# start with no machines
vagrant destroy -f
rm -rf .vagrant

time vagrant up --provider vmware_fusion 2>&1 | tee vmware-build-output.log
vagrant halt
# defrag disk (assumes running on osx)
"$VMwarePath"/vmware-vdiskmanager -d .vagrant/machines/default/vmware_fusion/*-*-*-*-*/disk.vmdk
# shrink disk (assumes running on osx)
"$VMwarePath"/vmware-vdiskmanager -k .vagrant/machines/default/vmware_fusion/*-*-*-*-*/disk.vmdk
# 'vagrant package' does not work with vmware boxes (http://docs.vagrantup.com/v2/vmware/boxes.html)
cd .vagrant/machines/default/vmware_desktop/*-*-*-*-*/
rm -f vmware*.log
tar cvzf ../../../../../vmware.box *
cd ../../../../../

ls -lh vmware.box
vagrant destroy -f
rm -rf .vagrant