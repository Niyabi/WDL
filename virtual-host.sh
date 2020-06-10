#!/bin/bash

# Step #1: Define variables

RED='\e[91m'
STD='\e[0;0;39m'

# Step #2: User defined function

#Install WDL function
install_wdl(){
        sh ./wdl.sh
}

#Create virtual host function
create_vhost() {
        local FLAG=true

        while $FLAG
        do                
                read -p "Enter your virtual host name, make it simple (e.g. myproject): " PROJECT_NAME

                if [  -f "/etc/apache2/sites-available/$PROJECT_NAME.local.conf" ]; then
                        FLAG=true
                        echo "${RED}Virtual host already exists.\e[0m Choose different virtual host name."
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
                        echo "${RED}Directory does not exists.\e[0m Choose existing directory."
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
        sleep 4
}

#Remove virtual host function
remove_vhost(){
        echo "//TODO" && sleep 2
}

#Function to display menus
show_menu() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Install WDL"
	echo "2. Create virtual host"
	echo "3. Remove virtual host"
        echo "4. Exit"
}

#Read input from the keyboard and take a action
read_options(){
	local choice
	read -p "Enter choice [ 1 - 4] " choice
	case $choice in
		1) install_wdl ;;
		2) create_vhost ;;
                3) remove_vhost ;;
		4) exit 0;;
		*) echo "${RED}Error...${STD}" && sleep 2
	esac
}

# Step #3: Trap CTRL+C, CTRL+Z and quit singles
trap '' SIGINT SIGQUIT SIGTSTP

# Step #4: Main logic - infinite loop
while true
do
	show_menu
	read_options
done
