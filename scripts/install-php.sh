FLAG=true
PHP_VERSION=''

while $FLAG
do   
    read -p "Enter PHP version you want to install (e.g. 7.1): " PHP_VERSION

    # Validate input
    VALIDATED="$(echo $PHP_VERSION | grep '^[5-8]\.[0-9]$')"

    # Check if input is correct
    if [ "$PHP_VERSION" = "$VALIDATED" ] ; then

        apt-cache show php${PHP_VERSION}

        # Check if PHP version exist
        if [ "$?" = "0" ] ; then
        
            # Install PHP with extensions
            apt install -y php${PHP_VERSION} php${PHP_VERSION}-bcmath php${PHP_VERSION}-bz2 php${PHP_VERSION}-cgi php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-dba php${PHP_VERSION}-dev php${PHP_VERSION}-enchant php${PHP_VERSION}-fpm php${PHP_VERSION}-gd php${PHP_VERSION}-gmp php${PHP_VERSION}-imap php${PHP_VERSION}-interbase php${PHP_VERSION}-intl php${PHP_VERSION}-json php${PHP_VERSION}-ldap php${PHP_VERSION}-mbstring php${PHP_VERSION}-mysql php${PHP_VERSION}-odbc php${PHP_VERSION}-opcache php${PHP_VERSION}-pgslq php${PHP_VERSION}-phpdbg php${PHP_VERSION}-pspell php${PHP_VERSION}-readline php${PHP_VERSION}-recode php${PHP_VERSION}-snmp php${PHP_VERSION}-soap php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-sybase php${PHP_VERSION}-tidy php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-xsl php${PHP_VERSION}-zip
            
            echo "PHP ${PHP_VERSION} has been installed."

            # Set flag to false to leave loop
            FLAG=false

        else
            echo "${RED}PHP ${PHP_VERSION} does not exists.${CLC} Choose different PHP version."
        fi

    else
        echo "${RED}Incorrect input.${CLC} Try again."
    fi   
    
done

# Sleep to let user read console
sleep 4