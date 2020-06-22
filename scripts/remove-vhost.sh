FLAG=true
PROJECT_NAME=''

while $FLAG
do                
        read -p "Enter name of virtual host you want to remove (e.g. myproject): " PROJECT_NAME

        # Validate input
        VALIDATED="$(echo $PROJECT_NAME | grep '^[a-z0-9]\+\-\?[a-z0-9]\+$')"

        # Check if input is correct
        if [ "$PROJECT_NAME" = "$VALIDATED" ] ; then

                # Check if given vhost exists
                if [  -f "/etc/apache2/sites-available/$PROJECT_NAME.local.conf" ]; then
                        
                        # Remove vhost and reload Apache
                        rm /etc/apache2/sites-available/$PROJECT_NAME.local.conf
                        service apache2 reload
                        
                        echo "Virtual host has beed removed."

                        # Set flag to false to leave loop
                        FLAG=false
                else
                        echo "${RED}Virtual host does not exist.${CLC} Check if virtual host name is correct."
                fi

        else
                echo "${RED}Incorrect input.${CLC} Try again."
        fi
done

# Sleep to let user read console
sleep 4