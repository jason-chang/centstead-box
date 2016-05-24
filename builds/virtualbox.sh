#!/usr/bin/env bash

# install required vagrant plugin to handle reloads during provisioning
# vagrant plugin install vagrant-reload

vagrant halt
vagrant destroy -f
rm -rf .vagrant

if [ $1 == "usual" ]
then
    # 普通版
    rm -rf ./logs/virtualbox_usual.log
    rm -rf ./boxs/virtualbox_usual.box

    time vagrant up --provider virtualbox 2>&1 | tee ./logs/virtualbox_usual.log
    vagrant halt
    vagrant package --output ./boxs/virtualbox_usual.box

    ls -lh ./boxs/virtualbox_usual.box

fi

if [ $1 == "avant" ]
then
    # 先锋版
    rm -rf ./logs/virtualbox_avant.log
    rm -rf ./boxs/virtualbox_avant.box

    touch avant
    time vagrant up --provider virtualbox 2>&1 | tee ./logs/virtualbox_avant.log
    rm -rf avant
    vagrant halt
    vagrant package --output ./boxs/virtualbox_avant.box

    ls -lh ./boxs/virtualbox_avant.box
fi

# 清理
vagrant destroy -f
rm -rf .vagrant