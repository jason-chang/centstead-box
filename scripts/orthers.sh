#!/usr/bin/env bash

# 安装 Node
yum install -y nodejs
/usr/bin/npm install -g gulp
/usr/bin/npm install -g bower
/usr/bin/npm install -g webpack

# 安装 SQLite
yum install -y sqlite sqlite-devel

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

# Fuck gfw 希望成功 安装 Composer
php -r "copy('http://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# 添加 Composer 程序目录到全局变量
printf "\nPATH=\"/home/vagrant/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile