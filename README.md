WDL - Under Construction
Under Construction everywhere!

1. Download WDL
2. Run wdl.sh:
sudo sh wdl.sh
3. Configurate MariaDB:
sudo mysql -u root
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
exit;
sudo service mysql restart
4. Now you can access database through phpMyAdmin, HeidiSQL etc. 
5. To create your virtual host run virtual-host.sh
sudo virtual-host.sh