#!/usr/bin/env bash

# 安装 Nginx
yum install -y nginx

# 设置 Nginx
cat << EOF > /etc/nginx/fastcgi_params
fastcgi_param   QUERY_STRING        \$query_string;
fastcgi_param   REQUEST_METHOD      \$request_method;
fastcgi_param   CONTENT_TYPE        \$content_type;
fastcgi_param   CONTENT_LENGTH      \$content_length;
fastcgi_param   SCRIPT_FILENAME     \$request_filename;
fastcgi_param   SCRIPT_NAME         \$fastcgi_script_name;
fastcgi_param   REQUEST_URI         \$request_uri;
fastcgi_param   DOCUMENT_URI        \$document_uri;
fastcgi_param   DOCUMENT_ROOT       \$document_root;
fastcgi_param   SERVER_PROTOCOL     \$server_protocol;
fastcgi_param   GATEWAY_INTERFACE   CGI/1.1;
fastcgi_param   SERVER_SOFTWARE     nginx/\$nginx_version;
fastcgi_param   REMOTE_ADDR         \$remote_addr;
fastcgi_param   REMOTE_PORT         \$remote_port;
fastcgi_param   SERVER_ADDR         \$server_addr;
fastcgi_param   SERVER_PORT         \$server_port;
fastcgi_param   SERVER_NAME         \$server_name;
fastcgi_param   HTTPS               \$https if_not_empty;
fastcgi_param   REDIRECT_STATUS     200;
EOF

sed -i "s/user nginx;/user vagrant;/" /etc/nginx/nginx.conf
sed -i "/types_hash_max_size/a \    server_names_hash_bucket_size 64\;" /etc/nginx/nginx.conf
sed -i ':begin;/server/,${$! {N; bbegin}};s/server {.*50x\.html {\s*}\s*}//' /etc/nginx/nginx.conf
sed -i '/^http/,${/^}/s/}/    include \/etc\/nginx\/sites\/\*;\n}/}' /etc/nginx/nginx.conf
chown vagrant.vagrant -R /var/log/nginx/
chown vagrant.vagrant -R /var/lib/nginx/
mkdir /etc/nginx/sites

systemctl enable nginx.service
systemctl start nginx.service