#!/usr/bin/env bash

# install required vagrant plugin to handle reloads during provisioning
vagrant plugin install vagrant-reload

rm -rf ./box/virtualbox_*.box

# 普通版
vagrant destroy -f
rm -rf .vagrant

time vagrant up --provider virtualbox 2>&1 | tee ./logs/virtualbox-usual.log
vagrant halt
vagrant package --output ./boxs/virtualbox_usual.box

ls -lh ./boxs/virtualbox_usual.box

# 先锋版
vagrant destroy -f
rm -rf .vagrant
touch avant

time vagrant up --provider virtualbox 2>&1 | tee ./logs/virtualbox-avant.log
vagrant halt
vagrant package --output ./boxs/virtualbox_avant.box

ls -lh ./boxs/virtualbox_avant.box

# 清理
vagrant destroy -f
rm -rf .vagrant
rm -rf avant