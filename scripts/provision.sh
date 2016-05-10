#!/usr/bin/env bash
#配置ssh
sed -i '/UseDNS/cUseDNS no' /etc/ssh/sshd_config

# 修改本地位置
echo "LC_ALL=zh_CN.UTF-8" > /etc/locale.conf
echo "LANG=zh_CN.UTF-8" >> /etc/locale.conf
localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 安装部分基础库
yum groupinstall -y "Development Tools"
yum install -y gcc gcc-c++
yum install -y wget curl vim net-tools bash-completion whois
yum install -y python python-devel python-pip supervisor

# 安装 epel repo
yum install -y epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

# Remi repo
rpm -i http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
sed -i ':ena;s/enabled=1/enabled=0/;tena' /etc/yum.repos.d/remi.repo
sed -i '/\[remi\-php56\]/,/\[/s/enabled=0/enabled=1/' /etc/yum.repos.d/remi.repo

# Mysql repo
rpm -i http://repo.mysql.com//mysql57-community-release-el7-8.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
sed -i ':ena;/\[mysql5.*\-community\]/,/\[/s/enabled=1/enabled=0/;tena' /etc/yum.repos.d/mysql-community.repo
sed -i '/\[mysql57\-community\]/,/\[/s/enabled=0/enabled=1/' /etc/yum.repos.d/mysql-community.repo

# MariaDB repo /etc/yum.repos.d/
cat > /etc/yum.repos.d/mariadb.repo << EOF
[mariadb-55]
name = MariaDB
baseurl = http://yum.mariadb.org/5.5/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
enabled=0
gpgcheck=1

[mariadb-10]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
enabled=0
gpgcheck=1

[mariadb-101]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
enabled=0
gpgcheck=1
EOF
rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
sed -i ':ena;s/enabled=1/enabled=0/;tena' /etc/yum.repos.d/mariadb.repo
#sed -i '/\[mariadb\-101\]/,/\[/s/enabled=0/enabled=1/' /etc/yum.repos.d/mariadb.repo

# PostgreSQL 9.5 repo
rpm -i https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-95

# Nodejs 6 repo
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL

# 设置 时区
ln -sf /usr/share/zoneinfo/Hongkong /etc/localtime

# 安装 Nginx
yum install -y nginx

# 设置 Nginx
cat > /etc/nginx/fastcgi_params << EOF
fastcgi_param	QUERY_STRING		\$query_string;
fastcgi_param	REQUEST_METHOD		\$request_method;
fastcgi_param	CONTENT_TYPE		\$content_type;
fastcgi_param	CONTENT_LENGTH		\$content_length;
fastcgi_param	SCRIPT_FILENAME		\$request_filename;
fastcgi_param	SCRIPT_NAME		\$fastcgi_script_name;
fastcgi_param	REQUEST_URI		\$request_uri;
fastcgi_param	DOCUMENT_URI		\$document_uri;
fastcgi_param	DOCUMENT_ROOT		\$document_root;
fastcgi_param	SERVER_PROTOCOL		\$server_protocol;
fastcgi_param	GATEWAY_INTERFACE	CGI/1.1;
fastcgi_param	SERVER_SOFTWARE		nginx/\$nginx_version;
fastcgi_param	REMOTE_ADDR		\$remote_addr;
fastcgi_param	REMOTE_PORT		\$remote_port;
fastcgi_param	SERVER_ADDR		\$server_addr;
fastcgi_param	SERVER_PORT		\$server_port;
fastcgi_param	SERVER_NAME		\$server_name;
fastcgi_param	HTTPS			\$https if_not_empty;
fastcgi_param	REDIRECT_STATUS		200;
EOF

sed -i "s/user nginx;/user vagrant;/" /etc/nginx/nginx.conf
sed -i "/types_hash_max_size/a \    server_names_hash_bucket_size 64\;" /etc/nginx/nginx.conf
sed -i ':begin;/server/,${$! {N; bbegin}};s/server {.*50x\.html {\s*}\s*}//' /etc/nginx/nginx.conf
sed -i '/^http/,${/^}/s/}/    include \/etc\/nginx\/sites\/\*;\n}/}' /etc/nginx/nginx.conf
chown vagrant.vagrant /var/log/nginx/
mkdir /etc/nginx/sites

systemctl enable nginx.service
systemctl start nginx.service

# 安装 PHP
yum install -y php php-devel php-fpm php-mysql php-pgsql php-imap php-ldap \
php-pear php-xml php-mbstring php-mcrypt php-bcmath \
php-mhash php-redis php-memcached php-xdebug php-curl \
php-imagick php-gd php-openssl php-readline
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

sed -i "/^listen.*=/clisten = /dev/shm/php-cgi.sock" /etc/php-fpm.d/www.conf
sed -i "s/;listen\.owner.*/listen.owner = nginx/" /etc/php-fpm.d/www.conf
sed -i "s/;listen\.group.*/listen.group = nginx/" /etc/php-fpm.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php-fpm.d/www.conf

mkdir -p /var/log/php
chown vagrant.vagrant -R /var/log/php/
chown vagrant.vagrant -R /var/log/php-fpm/

systemctl restart nginx.service
systemctl restart php-fpm.service

# 安装 Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# 添加 Composer 程序目录到全局变量
printf "\nPATH=\"/home/vagrant/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile

# 安装 Laravel Envoy & Installer
sudo su vagrant <<'EOF'
/usr/local/bin/composer global require "laravel/envoy=~1.0"
/usr/local/bin/composer global require "laravel/installer=~1.1"
EOF

# 设置 目录权限
chown vagrant.vagrant /var/lib/php/session
chown vagrant.vagrant /var/lib/php/wsdlcache

# 安装 Node
yum install -y nodejs
/usr/bin/npm install -g gulp
/usr/bin/npm install -g bower
/usr/bin/npm install -g webpack

# 安装 SQLite
yum install -y sqlite sqlite-devel

# 安装 MySQL
yum install -y mysql mysql-client mysql-server mysql-devel
systemctl enable mysqld.service
systemctl start mysqld.service

# 配置 MySQL 密码生存时间
sed -i '$a default_password_lifetime=0' /etc/my.cnf


# 配置 MySQL 字符集
sed -i '$a character_set_server=utf8' /etc/my.cnf


# 设置 MySQL 远程认证
sed -i '$a bind-address = 0.0.0.0' /etc/my.cnf

systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
systemctl restart mysqld.service

mysql --user="root" -e "UNINSTALL PLUGIN validate_password;"
mysql --user="root" -e "UPDATE mysql.user SET authentication_string = PASSWORD('vagrant') WHERE User = 'root' AND Host = 'localhost';"
mysql --user="root" -e "FLUSH PRIVILEGES;"

systemctl set-environment MYSQLD_OPTS="--validate-password=OFF"
systemctl restart mysqld.service

mysql --user="root" --password="vagrant" --connect-expired-password -e "SET PASSWORD = PASSWORD('vagrant');"

systemctl set-environment MYSQLD_OPTS=""
systemctl restart mysqld.service

mysql --user="root" --password="vagrant" -e "UNINSTALL PLUGIN validate_password;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"

mysql --user="root" --password="vagrant" -e "CREATE USER 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant';"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="vagrant" -e "drop DATABASE test;"

systemctl restart mysqld.service

# 添加 MySQL 时区支持
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user="root" --password="vagrant" mysql

# 安装 Postgres
yum install -y postgresql95 postgresql95-server postgresql95-devel postgresql95-contrib
/usr/pgsql-9.5/bin/postgresql95-setup initdb
systemctl enable postgresql-9.5.service
systemctl start postgresql-9.5.service

# 配置 Postgres 远程访问
sed -i "/#listen_addresses/alisten_addresses = '*'" /var/lib/pgsql/9.5/data/postgresql.conf
echo "host    all             all             10.0.2.2/32               md5" | tee -a /var/lib/pgsql/9.5/data/pg_hba.conf
sudo -u postgres psql -c "CREATE ROLE vagrant LOGIN UNENCRYPTED PASSWORD 'vagrant' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
systemctl restart postgresql-9.5.service

# 配置 Redis
yum install -y redis
systemctl enable redis.service
systemctl start redis.service

# 配置 memcached
yum install -y memcached
systemctl enable memcached.service
systemctl start memcached.service

# 配置 Beanstalkd
yum install -y beanstalkd
systemctl enable beanstalkd.service
systemctl start beanstalkd.service

# Git
yum install -y git
echo 'source /usr/share/doc/git-*/contrib/completion/git-completion.bash' >> .profile

# Clean
yum clean all

# Enable Swap Memory
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

# Minimize The Disk Image
echo "Minimizing disk image..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync

