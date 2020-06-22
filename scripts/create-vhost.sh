FLAG=true
PROJECT_NAME=''
PROJECT_PATH=''


while $FLAG
do                
        read -p "Enter your virtual host name, make it simple (e.g. myproject): " PROJECT_NAME

        # Validate input
        VALIDATED="$(echo $PROJECT_NAME | grep '^[a-z0-9]\+\-\?[a-z0-9]\+$')"

        # Check if input is correct
        if [ "$PROJECT_NAME" = "$VALIDATED" ] ; then

                # Check if given vhost exists
                if [  -f "/etc/apache2/sites-available/$PROJECT_NAME.local.conf" ]; then
                        
                        echo "${RED}Virtual host already exists.${CLC} Choose different virtual host name."       
                else
                        # IF vhost doesn't exist then leave loop
                        FLAG=false
                fi
        fi
done

FLAG=true

while $FLAG
do
        read -p "Enter path to your project (e.g. /var/www/myproject/ or /mnt/c/Users/myuser/Documents/myproject/): " PROJECT_PATH

        # Check if path exists
        if [ ! -d "$PROJECT_PATH" ]; then
                
                echo "${RED}Directory does not exists.${CLC} Choose existing directory."
        else
                # IF path do exists then leave loop
                FLAG=false
        fi
done

# Available PHP versions
#declare -a AVAILABLE_PHP

ALL_PHP=( $(ls /etc/php/ | grep '^[5-8]\.[0-9]$') )

for value in "${ALL_PHP[@]}"
do
        if [ -d "/etc/php/${value}/fpm/" ]; then
                AVAILABLE_PHP+=($value)
        fi
done

echo "These PHP versions are available:"
for value in "${AVAILABLE_PHP[@]}"; do echo "$value"; done

# Choosing available PHP version
FLAG=true
PHP_VERSION=''

while $FLAG
do   
        read -p "Enter PHP version you want to use (e.g. 7.1): " PHP_VERSION

        # Validate input
        VALIDATED="$(echo $PHP_VERSION | grep '^[5-8]\.[0-9]$')"

        # Check if input is correct
        if [ "$PHP_VERSION" = "$VALIDATED" ] ; then

                # Check if PHP version exist
                if [[ "${AVAILABLE_PHP[*]}" == *"${PHP_VERSION}"* ]] ; then

                        # Set flag to false to leave loop
                        FLAG=false
                else
                        echo "${RED}PHP ${PHP_VERSION} is not available.${CLC} Choose different PHP version."
                fi

        else
                echo "${RED}Incorrect input.${CLC} Try again."
        fi   
        
done

# Prepare vhost config file
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
        SetHandler "proxy:unix:/var/run/php/php'"$PHP_VERSION"'-fpm.sock|fcgi://localhost/"
        </FilesMatch>
        ErrorLog ${APACHE_LOG_DIR}/'"$PROJECT_NAME"'.error.log
        CustomLog ${APACHE_LOG_DIR}/'"$PROJECT_NAME"'.access.log combined
</VirtualHost>'

# Write vhost config file
echo "$CONFIG" > /etc/apache2/sites-available/"$PROJECT_NAME".local.conf

# Enable your virtual host
a2ensite "$PROJECT_NAME".local

# Reload Apache2
service apache2 reload

# Show message
echo "Virtual host has been created."

# Sleep to let user read console
sleep 4