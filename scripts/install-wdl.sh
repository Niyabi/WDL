# Update package list
apt update

# Upgrade packages
apt upgrade -y

# Install MariaDB database server
apt install -y mariadb-server
service mysql start

# Install wget
apt install -y wget

# Install Apache2
cd /tmp && wget http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
dpkg -i libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb; apt install -fy
apt install -y apache2 libapache2-mpm-itk libapache2-mod-fastcgi libapache2-mod-fcgid 
dpkg --configure -a
service apache2 start

# Activate Apache2 mods
a2enmod rewrite actions headers deflate expires fastcgi fcgid alias proxy_fcgi 
service apache2 restart

# Add PHP repo
apt install -y software-properties-common
apt install -y apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update

# Install PHP 7.2 and some of its extensions
apt install -y php7.2 php7.2-bcmath php7.2-bz2 php7.2-cgi php7.2-cli php7.2-common php7.2-curl php7.2-dba php7.2-dev php7.2-enchant php7.2-fpm php7.2-gd php7.2-gmp php7.2-imap php7.2-interbase php7.2-intl php7.2-json php7.2-ldap php7.2-mbstring php7.2-mysql php7.2-odbc php7.2-opcache php7.2-pgslq php7.2-phpdbg php7.2-pspell php7.2-readline php7.2-recode php7.2-snmp php7.2-soap php7.2-sqlite3 php7.2-sybase php7.2-tidy php7.2-xml php7.2-xmlrpc php7.2-xsl php7.2-zip

# Change settings in php.ini
sed -i '/default_socket_timeout/c\default_socket_timeout = 120' /etc/php/7.2/fpm/php.ini
sed -i '/max_input_time/c\max_input_time = 1800' /etc/php/7.2/fpm/php.ini
sed -i '/max_execution_time/c\max_execution_time = 1800' /etc/php/7.2/fpm/php.ini
sed -i '/memory_limit/c\memory_limit = 4G' /etc/php/7.2/fpm/php.ini
sed -i '/opcache.enable/c\opcache.enable=0' /etc/php/7.2/fpm/php.ini
sed -i '/opcache.save_comments/c\opcache.save_comments=1' /etc/php/7.2/fpm/php.ini
sed -i '/cgi.fix_pathinfo/c\cgi.fix_pathinfo=1' /etc/php/7.2/fpm/php.ini
service php7.2-fpm start

# Set PHP 7.2 as default PHP
update-alternatives --set php /usr/bin/php7.2
update-alternatives --set phar /usr/bin/phar7.2
update-alternatives --set phar.phar /usr/bin/phar.phar7.2
update-alternatives --set phpize /usr/bin/phpize7.2
update-alternatives --set php-config /usr/bin/php-config7.2
service php7.2-fpm restart

# Install Composer
mkdir ~/composer/
cd ~/composer/
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php    
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
mv composer.phar /usr/local/bin/composer 

# Install zip & unzip
apt install -y zip unzip

# Install phpMyAdmin
apt install -y php-tcpdf
apt -t buster-backports install -y php-twig
apt install -y phpmyadmin

# Configure Apache2
apt install -y libapache2-mod-php7.2
sed -i '92s/.*/Timeout 600/' /etc/apache2/apache2.conf
sed -i '161s/.*/    AllowOverride All/' /etc/apache2/apache2.conf
sed -i '172s/.*/    AllowOverride All/' /etc/apache2/apache2.conf
sed -i '162s/.*/    Require all granted/' /etc/apache2/apache2.conf
sed -i '173s/.*/    Require all granted/' /etc/apache2/apache2.conf
echo "AcceptFilter http none" >> /etc/apache2/apache2.conf
echo "ProxyTimeout 600" >> /etc/apache2/apache2.conf

# Configure MariaDB
mysql -u root <<MY_QUERY
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
MY_QUERY
service mysql restart

# Update package list
apt update

# Upgrade packages
apt upgrade -y