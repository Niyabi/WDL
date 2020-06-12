#!/bin/bash

FLAG=true
PROJECT_NAME=''

while $FLAG
do                
        read -p "Enter name of virtual host you want to remove (e.g. myproject): " PROJECT_NAME

        if [  -f "/etc/apache2/sites-available/$PROJECT_NAME.local.conf" ]; then
                FLAG=false
                rm /etc/apache2/sites-available/$PROJECT_NAME.local.conf
                service apache2 reload
                echo "Virtual host has beed removed."
        else
                FLAG=true
                echo "${RED}Virtual host already exists.${CLC} Choose different virtual host name."
        fi
done

#Sleep to let user read console
sleep 4