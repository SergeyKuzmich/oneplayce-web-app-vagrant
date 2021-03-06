#!/bin/sh

sudo rm /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list
sudo apt-get update

# Setup locales
sudo locale-gen UTF-8
sudo dpkg-reconfigure locales

sudo touch /var/lib/cloud/instance/locale-check.skip

## APACHE
sudo service apache2 stop
sudo rm /etc/apache2/sites-enabled/*
sudo rm /etc/apache2/sites-available/scotchbox.local.conf
sudo a2ensite 000-default.conf
sudo service apache2 start

# XDebug
sudo apt-get install -y --force-yes php-xdebug php-apcu php7.0-xml
sudo echo "xdebug.remote_enable = on" >> /etc/php/7.0/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_connect_back = on" >> /etc/php/7.0/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.idekey = 'vagrant'" >> /etc/php/7.0/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_port = 9000" >> /etc/php/7.0/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.default_enable=1" >> /etc/php/7.0/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_host=10.0.2.2" >> /etc/php/7.0/apache2/conf.d/20-xdebug.ini

sudo echo 'export XDEBUG_CONFIG="idekey=PHPSTORM"' >> /home/vagrant/.bashrc

sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 35M/' /etc/php/7.0/apache2/php.ini

sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/7.0/apache2/php.ini

sed -i 's/post_max_size = 8M/post_max_size = 35M/' /etc/php/7.0/apache2/php.ini

sed -i 's/expose_php = On/expose_php = Off/' /etc/php/7.0/apache2/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/php/7.0/cli/php.ini

# Restart apache2 to get new PHP configuration
sudo service apache2 restart
