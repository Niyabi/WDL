Everthing is still under construction.

# WSL Debian localhost

Project purpose is to help with creating local Apache web server with PHP and MariaDB database.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development purposes. 

### Prerequisites

What things you need to install the software and how to install them


* Windows Subsystem for Linux
* Debian linux from Microsoft Store

### Installing

A step by step how to install WDL

Update packages list, upgrade packages and install git

```shell
sudo apt update && sudo apt upgrade -y && sudo apt install -y git
```

Then clone repo

```shell
cd ~ && git clone https://github.com/Niyabi/WDL.git
```

Then let's run script which will install required packages and configure them. At The end phpMyAdmin installer will ask few things. When asked if to configure database check *Yes*, when asked about webserver check (using Spacebar) *apache2*. 

```shell
sudo sh wdl.sh
```
<!-- Now you need to configure MariaDB.

```
sudo mysql -u root
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
exit;
sudo service mysql restart
``` -->

### How to use

To start web server run start.sh.

```shell
sudo sh ~/WDL/start.sh
```

To stop web server run stop.sh.

```shell
sudo sh ~/WDL/stop.sh
```

To create virtual host run virtual-host.sh. You will be asked for project name and path to project, eg *myproject* in */mnt/c/Users/YourUserName/Documents/myproject* so your URL will be myproject.local.

```shell
sudo sh ~/WDL/virtual-host.sh
```

To connect to virtual host open Notepad as administrator, open hosts file in *C:\Windows\System32\drivers\etc*. Type your local IP adress (you can check it in Debian commandline with *ip a* command) and project URL e.g. *192.168.0.2 myproject.local*. Save and close file.

To access database use use HeidiSQL or phpMyAdmin (http://localhost/phpmyadmin/). To login to phpMyAdmin (if not asked for username during phpMyAdmin installation) username will be phpmyadmin and password then one you set during installation.

## Notes

This configuration allows use of mutiple version of PHP at the same time. To install different, than 7.2, version of PHP use this command:

```shell
sudo apt install -y phpX.Y phpX.Y-fpm
```

For example:

```shell
sudo apt install -y php7.0 php7.0-fpm
```

To install PHP extension run:

```shell
sudo apt install -y phpX.Y-ext
```

For example:

```shell
sudo apt install -y php7.0-pdo
```

In virtual host config file (found here: */etc/apache2/sites-available/*) you have to change php-fpm sock in this line:

```apache
SetHandler "proxy:unix:/var/run/php/php7.2-fpm.sock|fcgi://localhost/"
```

For example:

```apache
SetHandler "proxy:unix:/var/run/php/php7.0-fpm.sock|fcgi://localhost/"
```

### TODO

1. User able to choose PHP version
2. Additional PHP version installer
3. Exception protection
4. Apache optimization
5. MariaDB optimization
6. PHP optimization

## Authors

* **Szymon Krawiec** - [Niyabi](https://github.com/Niyabi)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details