#!/bin/bash

#Update package list
apt update

#Upgrade packages
apt upgrade

#Install MariaDB database server
apt install -y mariadb-server
service mysql start

#Install wget
apt install -y wget

#Install Apache2
cd /tmp && wget http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
dpkg -i libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb; apt install -f
apt install -y apache2 libapache2-mpm-itk libapache2-mod-fastcgi
dpkg --configure -a

#Activate Apache2 mods
a2enmod rewrite actions headers fastcgi fcgid alias proxy_fcgi 
service apache2 restart

#Add PHP repo
apt install -y software-properties-common
apt update
apt install -y apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update

#Install PHP 7.2 and some of its mods required by Magento 2
apt install -y php7.2 php7.2-fpm php7.2-common php7.2-xml php7.2-bcmath php7.2-bz2 php7.2-curl php7.2-gd php7.2-intl php7.2-json php7.2-mbstring php7.2-opcache php7.2-mysql php7.2-readline php7.2-soap

#Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer 