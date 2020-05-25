Everthing is still under construction.

# WSL Debian localhost

Project purpose is to help with creating local Apache web server with PHP and MariaDB database.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Windows Subsystem for Linux
Debian linux from Microsoft Store
```

### Installing

A step by step how to install WDL

First clone repo

```shell
cd ~
git clone https://github.com/Niyabi/WDL.git
```

Then let's run script which will install required packages and configure them. At The end phpMyAdmin installer will ask few things. When asked if to configure database check *Yes*, when asked about webserver check (using Spacebar) *apache2*. 

```shell
sudo sh wdl.sh
```
Now you need to configure MariaDB.

```
sudo mysql -u root
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
exit;
sudo service mysql restart
```

### Using

To start web server run start.sh.

```shell
sudo sh ~/WDL/start.sh
```

To stop web server run stop.sh.

```shell
sudo sh ~/WDL/stop.sh
```

To create virtual host run virtual-host.sh. You will be asked for project name and path to project, eg myproject in /mnt/c/Users/*YourUserName*/Documents/myproject so your URL will be myproject.local.

```shell
sudo sh ~/WDL/virtual-host.sh
```

To connect to virtual host open Notepad as administrator, open hosts file in C:\Windows\System32\drivers\etc. Type your local IP adress (you can check it in PowerShell with *ipconfig* command) and project URL eg 192.168.0.2 myproject.local. Save and close file.

To access database use use HeidiSQL or phpMyAdmin (http://localhost/phpmyadmin/). To login to phpMyAdmin (if not asked for username during phpMyAdmin installation) username will be phpmyadmin and password then one you set during installation.

## Authors

* **Szymon Krawiec** - *Initial work* - [Niyabi](https://github.com/Niyabi)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details