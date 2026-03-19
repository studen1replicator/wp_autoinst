#!/usr/bin/bash

# ___INSTALL___


# Prepare repository:

apt install ca-certificates curl -y

curl -o /etc/apt/trusted.gpg.d/angie-signing.gpg \
      https://angie.software/keys/angie-signing.gpg

echo "deb https://download.angie.software/angie/$(. /etc/os-release && echo "$ID/$VERSION_ID $VERSION_CODENAME") main" \
    | sudo tee /etc/apt/sources.list.d/angie.list > /dev/null

apt update

# install angie:
apt install angie -y

# PHP packets:
apt install php8.1-fpm php8.1 php8.1-mysql mysql-server-8.0 php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip -y

# wordpress:
wget https://wordpress.org/latest.tar.gz -P /tmp
tar xvfz /tmp/latest.tar.gz
mkdir -p /var/www/html/
cp -r wordpress/ /var/www/html/
mkdir /var/www/html/wordpress/wp-content/uploads
chmod -R 755 /var/www/html/wordpress/
chown -R www-data:www-data /var/www/html/wordpress/

# mysql setup:
echo "CREATE DATABASE wordpress_db;" | mysql
echo "CREATE USER 'wp-user'@'localhost' IDENTIFIED BY 'passwd';" | mysql
echo "GRANT ALL ON wordpress_db.* TO 'wp-user'@'localhost';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

cp angie.conf /etc/angie/
cp default.conf /etc/angie/http.d/

cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

systemctl restart angie


