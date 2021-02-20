#!/bin/sh
## ========install.centos7.nextcloud.sh======== ##

##=====================================
## VAR
DATA_TIME="$(date +%Y%m%d_%k%M%S)";


##=====================================
cat /etc/redhat-release
yum update
yum install -y epel-release
yum install nginx -y
systemctl enable nginx
systemctl start nginx
systemctl status nginx

# ИЛИ для APACHe
#yum install httpd -y
#systemctl enable httpd
#systemctl start httpd

rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install yum-utils -y
yum-config-manager --enable remi-php70
yum install php php-mysql php-pecl-zip php-xml php-mbstring php-gd php-fpm php-intl

## BACKUP
tar czvf /etc/php-fpm.d."$DATA_TIME".bac.tar.gz /etc/php-fpm.d

#Теперь давайте найдем следующие строки в /etc/php-fpm.d/www.conf
cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bac

# Замените значения user = apache => user = nginx
sed -i 's/^user = .*/user = nginx/g' /etc/php-fpm.d/www.conf
# Замените значения group = apache => group = nginx
sed -i 's/^group = .*/group = nginx/g' /etc/php-fpm.d/www.conf


##=====================================
# разрешение для каталога сеансов PHP
# вам нужно пропустить этот шаг, если вы хотите использовать Apache вместо Nginx.
chown -R root:nginx /var/lib/php/session/
#перезапуск php-fpm
systemctl restart php-fpm

##=====================================
##=====================================
## Установка сервера базы данных MariaDB

touch /etc/yum.repos.d/MariaDB.repo
cat > /etc/yum.repos.d/MariaDB.repo <<EOF
	[mariadb]
	name = MariaDB
	baseurl = http://yum.mariadb.org/10.2/centos7-amd64
	gpgkey = https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
	gpgcheck = 1
EOF

yum install MariaDB-server MariaDB-client -y
systemctl start mariadb
systemctl enable mariadb
systemctl status mariadb

# создать пароль root, удалить тестовую базу данных, удалить анонимного пользователя, а затем перезагрузить эти привилегии.
mysql_secure_installation

##=====================================
##================ INFO ================
# Set root password? [Y/n] y
# Remove anonymous users? [Y/n] y
# Disallow root login remotely? [Y/n] Y
# Remove test database and access to it? [Y/n] Y
# Reload privilege tables now? [Y/n] Y

#После создания вы можете протестировать пароль:
mysql -u root -p

##=====================================
# Шаг 6. Создание базы данных.
mysql -uroot -p -e "CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
mysql -uroot -p -e "GRANT ALL on nextcloud.* to nextcloud@localhost identified by 'numbnet'"
mysql -uroot -p -e "FLUSH privileges"

##=====================================
##=====================================
### Шаг 7. Настройка веб-сервера.
## На предыдущем шаге вы выбрали веб-сервер для установки, теперь вам нужно его настроить.

##=====================================
#Конфигурация Nginx
#Если вы хотите использовать nginx, создайте файл конфигурации для блока сервера nginx

cat > /etc/nginx/conf.d/192.168.1.10.conf <<EOF
upstream php {
	server 127.0.0.1:9000;
	}

server {
	server_name 192.168.1.10;

	add_header X-Content-Type-Options nosniff;
	add_header X-XSS-Protection "1; mode=block";
	add_header X-Robots-Tag none;
	add_header X-Download-Options noopen;
	add_header X-Permitted-Cross-Domain-Policies none;

	# Путь к корневому каталогу установки
	root /var/www/nextcloud/;

		location = /robots.txt {
		allow all;
		log_not_found off;
		access_log off;
	}

	location = /.well-known/carddav {
		return 301 $scheme://$host/remote.php/dav;
	}

	location = /.well-known/caldav {
		return 301 $scheme://$host/remote.php/dav;
	}

	# установить максимальный размер загружаемого файла
	client_max_body_size 512M;
	fastcgi_buffers 64 4K;

	# Включить gzip, но не удалять заголовки ETag
	gzip on;
	gzip_vary on;
	gzip_comp_level 4;
	gzip_min_length 256;
	gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
	gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

	location / {
		rewrite ^ /index.php$request_uri;
	}

	location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
		deny all;
	}
	location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
		deny all;
	}

	location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+)\.php(?:$|/) {
		fastcgi_split_path_info ^(.+?\.php)(/.*)$;
		include fastcgi_params;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_param PATH_INFO $fastcgi_path_info;
		fastcgi_param HTTPS on;
		#Avoid sending the security headers twice
		fastcgi_param modHeadersAvailable true;
		fastcgi_param front_controller_active true;
		fastcgi_pass php;
		fastcgi_intercept_errors on;
		fastcgi_request_buffering off;
		}

	location ~ ^/(?:updater|ocs-provider)(?:$|/) {
		try_files $uri/ =404;
		index index.php;
	}

	# Добавление заголовка cache control для файлов js и css
	# Убедитесь, что он находится ниже блока PHP
	location ~ \.(?:css|js|woff|svg|gif)$ {
		try_files $uri /index.php$request_uri;
		add_header Cache-Control "public, max-age=15778463";

		add_header X-Content-Type-Options nosniff;
		add_header X-XSS-Protection "1; mode=block";
		add_header X-Robots-Tag none;
		add_header X-Download-Options noopen;
		add_header X-Permitted-Cross-Domain-Policies none;
		# Необязательно: не журналировать доступ к ресурсам
		access_log off;
	}

	location ~ \.(?:png|html|ttf|ico|jpg|jpeg)$ {
		try_files $uri /index.php$request_uri;
		# Необязательно: не регистрировать доступ к другим ресурсам
		access_log off;
	}
}
EOF

## Проверьте конфигурационный файл nginx, затем перезапустите службу
nginx -t
systemctl restart nginx

##=====================================
##=====================================
# Конфигурация Apache
# Создайте файл конфигурации виртуального хоста для домена, для размещения Nextcloud.

#cat > /etc/httpd/conf.d/192.168.1.10.conf <<EOF
#<VirtualHost *:80>

#ServerAdmin admin@192.168.1.10
#DocumentRoot /var/www/nextcloud
#ServerName 192.168.1.10
#ServerAlias www.192.168.1.10

#<Directory /var/www/html/nextcloud>
#Options +FollowSymlinks
#AllowOverride All

#<IfModule mod_dav.c>
#Dav off
#</IfModule>

#SetEnv HOME /var/www/nextcloud
#SetEnv HTTP_HOME /var/www/nextcloud
#</Directory>

#ErrorLog /var/log/httpd/nextcloud-error_log
#CustomLog /var/log/httpd/nextcloud-access_log common

#</VirtualHost>
#EOF

##=====================================
# Перейдите на официальный сайт Nextcloud и загрузите последнюю стабильную версию приложения
wget https://download.nextcloud.com/server/releases/nextcloud-14.0.0.zip


#Распакуйте загруженный zip-архив в корневой каталог документа на вашем сервере
unzip nextcloud-14.0.0.zip -d /var/www/
mkdir /var/www/nextcloud/data
chown -R nginx: /var/www/nextcloud

##=====================================
#Если вы выбрали Apache, то вам нужно установить разрешение для пользователя Apache
# chown -R apache: /var/www/nextcloud
exit