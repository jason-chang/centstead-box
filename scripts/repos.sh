#!/usr/bin/env bash

# 安装 epel repo
yum install -y epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

# Remi repo
rpm -i http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
sed -i '/enabled=1/cenabled=0' /etc/yum.repos.d/remi.repo

# Mysql repo
rpm -i http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
sed -i '/enabled=1/cenabled=0' /etc/yum.repos.d/mysql-community.repo

# MariaDB repo /etc/yum.repos.d/
cat > /etc/yum.repos.d/mariadb.repo << EOF
[mariadb-55]
name = MariaDB
baseurl = http://mirrors.aliyun.com/mariadb/yum/5.5/centos7-amd64
gpgkey=http://yum.mariadb.org/RPM-GPG-KEY-MariaDB
enabled=0
gpgcheck=1

[mariadb-10]
name = MariaDB
baseurl = http://mirrors.aliyun.com/mariadb/yum/10.0/centos7-amd64
gpgkey=http://yum.mariadb.org/RPM-GPG-KEY-MariaDB
enabled=0
gpgcheck=1

[mariadb-101]
name = MariaDB
baseurl = http://mirrors.aliyun.com/mariadb/yum/10.1/centos7-amd64
gpgkey=http://yum.mariadb.org/RPM-GPG-KEY-MariaDB
enabled=0
gpgcheck=1
EOF
rpm --import http://yum.mariadb.org/RPM-GPG-KEY-MariaDB

# PostgreSQL 9.5 repo
rpm -i http://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
sed -i '/enabled=1/cenabled=0' /etc/yum.repos.d/pgdg-95-centos.repo
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-95

# PostgreSQL 9.4 repo
rpm -i http://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-2.noarch.rpm
sed -i '/enabled=1/cenabled=0' /etc/yum.repos.d/pgdg-94-centos.repo
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-94

# PostgreSQL 9.3 repo
rpm -i http://download.postgresql.org/pub/repos/yum/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-2.noarch.rpm
sed -i '/enabled=1/cenabled=0' /etc/yum.repos.d/pgdg-93-centos.repo
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93

# PostgreSQL 9.2 repo
rpm -i http://download.postgresql.org/pub/repos/yum/9.2/redhat/rhel-7-x86_64/pgdg-centos92-9.2-2.noarch.rpm
sed -i '/enabled=1/cenabled=0' /etc/yum.repos.d/pgdg-92-centos.repo
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-92

# Nodejs 6 repo
curl --silent --location http://rpm.nodesource.com/setup_6.x | bash -
sed -i '/enabled=1/cenabled=0' /etc/yum.repos.d/nodesource-el.repo
rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL