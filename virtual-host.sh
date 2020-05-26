#!/bin/bash

/bin/echo -n "Enter your virtual host name, make it simple (e.g. myproject): "
read PROJECT_NAME

/bin/echo -n "Enter path to your project (e.g. /var/html/myproject/): "
read PROJECT_PATH

CONFIG='
<VirtualHost *:80>
        ServerName '"$PROJECT_NAME"'.local
        ServerAdmin webmaster@localhost
        DocumentRoot  '"$PROJECT_PATH"'
	AllowEncodedSlashes NoDecode
        <Directory '"$PROJECT_PATH"'>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
	Order allow,deny
	allow from all
        </Directory>
        <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php7.2-fpm.sock|fcgi://localhost/"
        </FilesMatch>
        ErrorLog ${APACHE_LOG_DIR}/'"$PROJECT_NAME"'.error.log
        CustomLog ${APACHE_LOG_DIR}/'"$PROJECT_NAME"'.access.log combined
</VirtualHost>'

echo "$CONFIG" > /etc/apache2/sites-available/"$PROJECT_NAME".local.conf

#Enable your virtual host
a2ensite "$PROJECT_NAME".local

#Reload Apache2
service apache2 reload