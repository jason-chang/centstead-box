#!/usr/bin/env bash

# 安装 PHP
yum install -y php php-devel php-fpm php-mysql php-pgsql php-imap php-ldap \
php-pear php-xml php-mbstring php-mcrypt php-bcmath \
php-mhash php-redis php-memcached php-xdebug php-curl \
php-imagick php-gd php-openssl php-readline  --enablerepo=remi-php70

# 建立 环境标识
touch /home/vagrant/.env/php70

systemctl enable php-fpm.service
systemctl start php-fpm.service

# 设置 php 配置
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php.ini
sed -i "s/;date.timezone.*/date.timezone = Asia\/Shanghai/" /etc/php.ini

# Xdebug设置
sed -i '$ixdebug.remote_enable = ON' /etc/php.d/15-xdebug.ini
sed -i '$ixdebug.remote_connect_back = ON' /etc/php.d/15-xdebug.ini
sed -i '$ixdebug.remote_port = 9000' /etc/php.d/15-xdebug.ini

# 设置 PHP-FPM 用户
sed -i "s/user = apache/user = vagrant/" /etc/php-fpm.d/www.conf
sed -i "s/group = apache/group = vagrant/" /etc/php-fpm.d/www.conf

sed -i "/^listen =/clisten = /dev/shm/php-cgi.sock" /etc/php-fpm.d/www.conf
sed -i "/;listen.acl_users =/clisten.acl_users = vagrant" /etc/php-fpm.d/www.conf
sed -i "/;listen.acl_groups =/clisten.acl_groups = vagrant" /etc/php-fpm.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php-fpm.d/www.conf

# 设置 目录权限
chown vagrant.vagrant /var/lib/php/session
chown vagrant.vagrant /var/lib/php/wsdlcache
mkdir -p /var/log/php
chown vagrant.vagrant -R /var/log/php/
chown vagrant.vagrant -R /var/log/php-fpm/

systemctl restart php-fpm.service

# 安装 Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer