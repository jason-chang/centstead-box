#!/usr/bin/env bash

# 安装 MySQL
yum install -y mysql mysql-client mysql-server mysql-devel --enablerepo=mysql56-community

# 建立 环境标识
touch /home/vagrant/.env/mysql56

systemctl enable mysqld.service
systemctl start mysqld.service

# 配置 MySQL 字符集
sed -i '/\[mysqld\]/a character_set_server=utf8' /etc/my.cnf

# 设置 MySQL 远程认证
sed -i '/\[mysqld\]/a bind-address = 0.0.0.0' /etc/my.cnf

mysql --user="root" --connect-expired-password -e "SET PASSWORD = PASSWORD('vagrant');"
systemctl restart mysqld.service

mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"

mysql --user="root" --password="vagrant" -e "CREATE USER 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant';"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"

systemctl restart mysqld.service

# 添加 MySQL 时区支持
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user="root" --password="vagrant" mysql