
	#Установка Docker в Centos 7
FuncDockerInsWP() {
	#Для теста можете запустить что-то с помощью docker-compose. Например, установить WordPress. 
	#Для этого создаем файл docker-compose.yaml следующего содержания.

	DockerInsWP='docker-compose.yaml'

	cat > $DockerInsWP<<EOF
version: '3'

services:
  mysql:
    image: mysql:8
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: wordpress
    volumes:
      - "./db:/var/lib/mysql"

  wordpress:
    image: wordpress:php7.4-apache
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: root
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - "./wp:/var/www/html/"
EOF

	#После этого запускаем проект.
	docker-compose up

}

installDockerCentos7() {

	#В Centos 7 Docker устанавливается так же штатно, через официальный репозиторий. 
	#Прежде чем его подключить, убедитесь, что у вас установлен пакет yum-utils.

	yum install yum-utils
	#После этого подключаем репозиторий докера.

	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

	#Теперь можно приступить к установке Docker на Centos 7.

	yum install docker-ce docker-ce-cli containerd.io
	#Установка Docker в Centos 7

	#Запускаем докер и добавляем в автозагрузку.

	systemctl enable --now docker
	#Проверяем работу:

	systemctl status docker
	#Запускаем контейнер c nginx для теста.

	docker run -d -p 80:80 --restart=always --name nginx-proxy nginx
	#Убеждаемся, что все запущено и корректно работает.

	docker ps
	ss -tulnp
	## Проверка docker

	## На этом установка Docker на Centos 7 закончена. Для верности можете в браузере проверить, что nginx запущен и работает.

	#Установка docker-compose на Centos
	#Зачастую для работы с докером требуется также docker-compose. Он позволяет быстро запускать проекты, состоящие из нескольких контейнеров. По своей сути docker-compose просто скрипт на python. Так что для его работы нужен собственно сам скрипт и некоторые компоненты python. Последнюю версию скрипта можно посмотреть в репозитории на github - https://github.com/docker/compose/releases/. В моем случае это 1.27.4.

	#Устанавливаем docker-compose на Centos.

	curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
	#Делаем файл исполняемым и на всякий случай добавляем символьную ссылку еще и в /usr/bin.

	chmod +x /usr/local/bin/docker-compose
	ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

	#Смотрим, все ли корректно установилось.
	docker-compose -v

	FuncDockerInsWP

	# Вам необходимо отключить firewalld и перезапустить докер.
	systemctl stop firewalld
	systemctl restart docker
}
installDockerCentos7