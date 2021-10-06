#!/bin/bash

title="Install OwnCloud to Ubuntu"

## ==============
## VERSION UBUNTU
OS=$(lsb_release -is);
VER=$(lsb_release -rs);
echo "$OS $VER";
sleep 5


## #########################
function INST_to_UBUNTU18 {
title

#Install ownCloud on Ubuntu 18.04

#Preparation
apt update && \
  apt upgrade -y

#Create the occ Helper Script

FILE="/usr/local/bin/occ"
/bin/cat <<EOM >$FILE
#! /bin/bash

cd /var/www/owncloud
sudo -u www-data /usr/bin/php /var/www/owncloud/occ "\$@"
EOM

chmod +x /usr/local/bin/occ


#Install the Required Packages
apt install -y \
  apache2 \
  libapache2-mod-php \
  mariadb-server \
  openssl \
  php-imagick php-common php-curl \
  php-gd php-imap php-intl \
  php-json php-mbstring php-mysql \
  php-ssh2 php-xml php-zip \
  php-apcu php-redis redis-server \
  wget


#Install the Recommended Packages
apt install -y \
  ssh bzip2 sudo cron rsync curl jq \
  inetutils-ping smbclient php-libsmbclient \
  php-smbclient coreutils php-ldap

#Ubuntu 18.04 includes smbclient 4.7.6, which has a known limitation of only using version 1 of the SMB protocol.


#Installation

#Configure Apache
#Change the Document Root
sed -i "s#html#owncloud#" /etc/apache2/sites-available/000-default.conf

service apache2 restart
Create a Virtual Host Configuration
FILE="/etc/apache2/sites-available/owncloud.conf"
/bin/cat <<EOM >$FILE
Alias /owncloud "/var/www/owncloud/"

<Directory /var/www/owncloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/owncloud
 SetEnv HTTP_HOME /var/www/owncloud
</Directory>
EOM


#Enable the Virtual Host Configuration
a2ensite owncloud.conf
service apache2 reload


#Configure the Database
service mysql start
mysql -u root -e "CREATE DATABASE IF NOT EXISTS owncloud; \
GRANT ALL PRIVILEGES ON owncloud.* \
  TO owncloud@localhost \
  IDENTIFIED BY 'password'";
Enable the Recommended Apache Modules
echo "Enabling Apache Modules"

a2enmod dir env headers mime rewrite setenvif
service apache2 reload
Download ownCloud
cd /var/www/
wget https://download.owncloud.org/community/owncloud-10.8.0.tar.bz2 && \
tar -xjf owncloud-10.8.0.tar.bz2 && \
chown -R www-data. owncloud
Install ownCloud
occ maintenance:install \
    --database "mysql" \
    --database-name "owncloud" \
    --database-user "owncloud" \
    --database-pass "password" \
    --admin-user "admin" \
    --admin-pass "admin"
Configure ownCloud’s Trusted Domains
myip=$(hostname -I|cut -f1 -d ' ')
occ config:system:set trusted_domains 1 --value="$myip"
Set Up a Cron Job
Set your background job mode to cron
occ background:cron
echo "*/15  *  *  *  * /var/www/owncloud/occ system:cron" \
  > /var/spool/cron/crontabs/www-data
chown www-data.crontab /var/spool/cron/crontabs/www-data
chmod 0600 /var/spool/cron/crontabs/www-data
If you need to sync your users from an LDAP or Active Directory Server, add this additional Cron job. Every 15 minutes this cron job will sync LDAP users in ownCloud and disable the ones who are not available for ownCloud. Additionally, you get a log file in /var/log/ldap-sync/user-sync.log for debugging.
echo "*/15 * * * * /var/www/owncloud/occ user:sync 'OCA\User_LDAP\User_Proxy' -m disable -vvv >> /var/log/ldap-sync/user-sync.log 2>&1" > /var/spool/cron/crontabs/www-data
chown www-data.crontab  /var/spool/cron/crontabs/www-data
chmod 0600  /var/spool/cron/crontabs/www-data
mkdir -p /var/log/ldap-sync
touch /var/log/ldap-sync/user-sync.log
chown www-data. /var/log/ldap-sync/user-sync.log

Configure Caching and File Locking
#Execute these commands:
occ config:system:set \
   memcache.local \
   --value '\OC\Memcache\APCu'

occ config:system:set \
   memcache.locking \
   --value '\OC\Memcache\Redis'

service redis-server start

occ config:system:set \
   redis \
   --value '{"host": "127.0.0.1", "port": "6379"}' \
   --type json
##Configure Log Rotation
#Execute this command to set up log rotation.
FILE="/etc/logrotate.d/owncloud"
sudo /bin/cat <<EOM >$FILE
/var/www/owncloud/data/owncloud.log {
  size 10M
  rotate 12
  copytruncate
  missingok
  compress
  compresscmd /bin/gzip
}
EOM
#Finalise the Installation
#Make sure the permissions are correct
cd /var/www/
chown -R www-data. owncloud

echo "OwnCloud is now installed"


}



## #########################
function INST_to_UBUNTU {

# Preparation
apt update && \
  apt upgrade -y

# Create the occ Helper Script
# Create a helper script to 
# simplify running occ commands.
  FILE="/usr/local/bin/occ"
  /bin/cat <<EOM >$FILE
#! /bin/bash
cd /var/www/owncloud
sudo -E -u www-data /usr/bin/php /var/www/owncloud/occ "\$@"
EOM
chmod +x /usr/local/bin/occ

# Install the Required Packages
apt install -y \
  apache2 \
  libapache2-mod-php \
  mariadb-server \
  openssl \
  php-imagick php-common php-curl \
  php-gd php-imap php-intl \
  php-json php-mbstring php-mysql \
  php-ssh2 php-xml php-zip \
  php-apcu php-redis redis-server \
  wget


Note : php 7.4 is the default version installable with Ubuntu 20.04
Install the Recommended Packages
apt install -y \
  ssh bzip2 rsync curl jq \
  inetutils-ping coreutils
Installation
Configure Apache
Change the Document Root
sed -i "s#html#owncloud#" /etc/apache2/sites-available/000-default.conf
service apache2 restart
Create a Virtual Host Configuration
FILE="/etc/apache2/sites-available/owncloud.conf"
/bin/cat <<EOM >$FILE
Alias /owncloud "/var/www/owncloud/"

<Directory /var/www/owncloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/owncloud
 SetEnv HTTP_HOME /var/www/owncloud
</Directory>
EOM
Enable the Virtual Host Configuration
a2ensite owncloud.conf
service apache2 reload
Configure the Database
mysql -u root -e "CREATE DATABASE IF NOT EXISTS owncloud; \
GRANT ALL PRIVILEGES ON owncloud.* \
  TO owncloud@localhost \
  IDENTIFIED BY 'password'";
Enable the Recommended Apache Modules
echo "Enabling Apache Modules"
a2enmod dir env headers mime rewrite setenvif
service apache2 reload
Download ownCloud
cd /var/www/
wget https://download.owncloud.org/community/owncloud-10.8.0.tar.bz2 && \
tar -xjf owncloud-10.8.0.tar.bz2 && \
chown -R www-data. owncloud
Install ownCloud
occ maintenance:install \
    --database "mysql" \
    --database-name "owncloud" \
    --database-user "owncloud" \
    --database-pass "password" \
    --admin-user "admin" \
    --admin-pass "admin"
Configure ownCloud’s Trusted Domains
myip=$(hostname -I|cut -f1 -d ' ')
occ config:system:set trusted_domains 1 --value="$myip"
Set Up a Cron Job
Set your background job mode to cron
occ background:cron
echo "*/15  *  *  *  * /var/www/owncloud/occ system:cron" \
  > /var/spool/cron/crontabs/www-data
chown www-data.crontab /var/spool/cron/crontabs/www-data
chmod 0600 /var/spool/cron/crontabs/www-data
If you need to sync your users from an LDAP or Active Directory Server, add this additional Cron job. Every 15 minutes this cron job will sync LDAP users in ownCloud and disable the ones who are not available for ownCloud. Additionally, you get a log file in /var/log/ldap-sync/user-sync.log for debugging.
echo "*/15 * * * * /var/www/owncloud/occ user:sync 'OCA\User_LDAP\User_Proxy' -m disable -vvv >> /var/log/ldap-sync/user-sync.log 2>&1" >> /var/spool/cron/crontabs/www-data
chown www-data.crontab  /var/spool/cron/crontabs/www-data
chmod 0600  /var/spool/cron/crontabs/www-data
mkdir -p /var/log/ldap-sync
touch /var/log/ldap-sync/user-sync.log
chown www-data. /var/log/ldap-sync/user-sync.log


# Configure Caching and File Locking:
occ config:system:set \
   memcache.local \
   --value '\OC\Memcache\APCu'
occ config:system:set \
   memcache.locking \
   --value '\OC\Memcache\Redis'
occ config:system:set \
   redis \
   --value '{"host": "127.0.0.1", "port": "6379"}' \
   --type json

## Configure Log Rotation
  FILE="/etc/logrotate.d/owncloud"
  /bin/cat <<EOM >$FILE
/var/www/owncloud/data/owncloud.log {
  size 10M
  rotate 12
  copytruncate
  missingok
  compress
  compresscmd /bin/gzip
}
EOM

# Finalise the Installation
# Make sure the permissions are correct
cd /var/www/
chown -R www-data. owncloud
echo "ownCloud is now installed"

}









