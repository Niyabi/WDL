#!/bin/bash

#Update package list
apt update

#Upgrade packages
apt upgrade -y

#Install MariaDB database server
apt install -y mariadb-server
service mysql start

#Install wget
apt install -y wget

#Install Apache2
cd /tmp && wget http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
dpkg -i libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb; apt install -fy
apt install -y apache2 libapache2-mpm-itk libapache2-mod-fastcgi libapache2-mod-fcgid 
dpkg --configure -a
service apache2 start

#Activate Apache2 mods
a2enmod rewrite actions headers deflate expires fastcgi fcgid alias proxy_fcgi 
service apache2 restart

#Add PHP repo
apt install -y software-properties-common
apt install -y apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update

#Install PHP 7.2 and some of its extensions
apt install -y php7.2 php7.2-fpm php7.2-common php7.2-xml php7.2-bcmath php7.2-bz2 php7.2-curl php7.2-gd php7.2-intl php7.2-json php7.2-mbstring php7.2-opcache php7.2-mysql php7.2-readline php7.2-soap php7.2-zip

#Change settings in php.ini
sed -i '/default_socket_timeout/c\default_socket_timeout = 120' /etc/php/7.2/fpm/php.ini
sed -i '/max_input_time/c\max_input_time = 1800' /etc/php/7.2/fpm/php.ini
sed -i '/max_execution_time/c\max_execution_time = 1800' /etc/php/7.2/fpm/php.ini
sed -i '/memory_limit/c\memory_limit = 4G' /etc/php/7.2/fpm/php.ini
sed -i '/opcache.save_comments/c\opcache.save_comments=1' /etc/php/7.2/fpm/php.ini
sed -i '/cgi.fix_pathinfo/c\cgi.fix_pathinfo=1' /etc/php/7.2/fpm/php.ini
service php7.2-fpm start

#Set PHP 7.2 as default PHP
update-alternatives --set php /usr/bin/php7.2
update-alternatives --set phar /usr/bin/phar7.2
update-alternatives --set phar.phar /usr/bin/phar.phar7.2
update-alternatives --set phpize /usr/bin/phpize7.2
update-alternatives --set php-config /usr/bin/php-config7.2
service php7.2-fpm restart

#Install Composer
mkdir ~/composer/
cd ~/composer/
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer 

#Install zip & unzip
apt install -y zip unzip

#Install phpMyAdmin
apt install -y php-tcpdf
apt -t buster-backports install -y php-twig
apt install -y phpmyadmin

#Configure Apache2
apt install -y libapache2-mod-php7.2
sed -i '92s/.*/Timeout 300/' /etc/apache2/apache2.conf
sed -i '161s/.*/    AllowOverride All/' /etc/apache2/apache2.conf
sed -i '172s/.*/    AllowOverride All/' /etc/apache2/apache2.conf
sed -i '162s/.*/    Require all granted/' /etc/apache2/apache2.conf
sed -i '173s/.*/    Require all granted/' /etc/apache2/apache2.conf
echo "AcceptFilter http none" >> /etc/apache2/apache2.conf
echo "ProxyTimeout 600" >> /etc/apache2/apache2.conf

#Configure MariaDB
mysql -u root <<MY_QUERY
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
MY_QUERY
service mysql restart

#Update package list
apt update

#Upgrade packages
apt upgrade -y

echo "
WDL - WSL Debian localhost
Copyright (C) 2020  Szymon Krawiec

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
"