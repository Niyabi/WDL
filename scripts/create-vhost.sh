#!/bin/bash

FLAG=true
PROJECT_NAME=''
PROJECT_PATH=''

while $FLAG
do                
        read -p "Enter your virtual host name, make it simple (e.g. myproject): " PROJECT_NAME

        if [  -f "/etc/apache2/sites-available/$PROJECT_NAME.local.conf" ]; then
                FLAG=true
                echo "${RED}Virtual host already exists.${CLC} Choose different virtual host name."
        else
                FLAG=false
        fi
done

FLAG=true

while $FLAG
do
        read -p "Enter path to your project (e.g. /var/html/myproject/): " PROJECT_PATH

        if [ ! -d "$PROJECT_PATH" ]; then
                FLAG=true
                echo "${RED}Directory does not exists.${CLC} Choose existing directory."
        else
                FLAG=false
        fi
done


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

#Sleep to let user read console
sleep 4