#!/bin/sh

NAMEFILE="Inst.PlexMediaServ.CentOS.sh";
TITLE="Plex Media Server";
SUBTITLE="Установка и настройка";
INFO='Plex - это сервер потокового мультимедиа, который объединяет все ваши коллекции видео, музыки и фотографий и передает их на ваши устройства в любое время и из любого места.'

## УСТАНОВИТЕ PLEX MEDIA SERVER 
### Рекомендуемый метод установки и управления Plex Media Server в CentOS 7 - использование официального репозитория Plex. Он не требует технических знаний и не должен занимать у вас более 20 минут для установки и настройки медиасервера.

## Следующие шаги описывают, как установить Plex Media Server в системе CentOS:

##============ ≠≠≠ ===========
## Добавьте репозиторий Plex
/etc/yum.repos.d/plex.repo
### [PlexRepo]
### name=PlexRepo
### baseurl=https://downloads.plex.tv/repo/rpm/$basearch/
### enabled=1
### gpgkey=https://downloads.plex.tv/plex-keys/PlexSign.key
### gpgcheck=1

## Установить Plex

## Установите последнюю версию Plex Media Server с:

## sudo yum install plexmediaserver
### После завершения установки запустите plexmediaserver службу и включите ее при загрузке системы с помощью следующих команд:

## sudo systemctl start plexmediaserver.servicesudo systemctl enable plexmediaserver.service
### Проверьте установку

## Чтобы проверить, работает ли служба Plex, введите:

## sudo systemctl status plexmediaserver
### ● plexmediaserver.service - Plex Media Server for Linux
###    Loaded: loaded (/usr/lib/systemd/system/plexmediaserver.service; enabled; vendor preset: disabled)
###    Active: active (running) since Sat 2018-07-21 22:22:22 UTC; 12s ago
###  Main PID: 13940 (Plex Media Serv)
###    CGroup: /system.slice/plexmediaserver.service

## НАСТРОЙТЕ ПРАВИЛА БРАНДМАУЭРА 
### Теперь, когда Plex установлен и работает, вам нужно настроить брандмауэр, чтобы разрешить трафик через определенные порты Plex Media Server.

## Если в вашей системе не включен брандмауэр, вы можете пропустить этот раздел.
### Откройте выбранный вами текстовый редактор и создайте следующий сервис Firewalld:

## /etc/firewalld/services/plexmediaserver.xml
### <?xml version="1.0" encoding="utf-8"?>
### <service version="1.0">
### <short>plexmediaserver</short>
### <description>Plex TV Media Server</description>
### <port port="1900" protocol="udp"/>
### <port port="5353" protocol="udp"/>
### <port port="32400" protocol="tcp"/>
### <port port="32410" protocol="udp"/>
### <port port="32412" protocol="udp"/>
### <port port="32413" protocol="udp"/>
### <port port="32414" protocol="udp"/>
### <port port="32469" protocol="tcp"/>
### </service>
### Сохраните файл и примените новые правила брандмауэра, набрав:


## sudo firewall-cmd --add-service=plexmediaserver --permanentsudo firewall-cmd --reload

## Наконец, проверьте, успешно ли применяются новые правила брандмауэра:


## sudo firewall-cmd --list-all
### public (active)
###   target: default
###   icmp-block-inversion: no
###   interfaces: eth0
###   sources:
###   services: ssh dhcpv6-client plexmediaserver
###   ports:
###   protocols:
###   masquerade: no
###   forward-ports:
###   source-ports:
###   icmp-blocks:
###   rich rules:
### НАСТРОИТЬ PLEX MEDIA SERVER 
### Создайте каталоги, в которых вы будете хранить свои медиа файлы:


## sudo mkdir -p /opt/plexmedia/{movies,series}

## Plex Media Server работает как пользователь , plex который должен прочитать и разрешение на выполнение медиа - файлы и каталоги. Чтобы установить владельца, выполните следующую команду.


## sudo chown -R plex: /opt/plexmedia


## Вы можете выбрать любое место для хранения мультимедийных файлов, просто убедитесь, что вы установили правильные разрешения.

## Откройте браузер, введите текст, http://YOUR_SERVER_IP:32400/web и вы увидите мастер настройки, который проведет вас через конфигурацию Plex:



### Чтобы использовать Plex Media Server, вам необходимо создать учетную запись.

## Нажмите кнопку Google, Facebook или Email, чтобы создать бесплатную учетную запись Plex. Если вы хотите получить доступ к премиальным функциям, вы можете приобрести план Plex Pass .

## После регистрации вы будете перенаправлены на страницу с информацией о том, как работает Plex, как показано ниже:




## Нажмите на Got itкнопку.

## На следующем экране введите имя своего сервера Plex, оставьте Allow me to access my media outside my home флажок установленным и нажмите Next.




## Следующим шагом является добавление библиотеки мультимедиа. Нажмите на Add Library кнопку.

## Когда появится всплывающее окно, выберите фильмы в качестве типа библиотеки и нажмите Next.

## На следующем шаге нажмите Browse for media folder и добавьте путь к каталогу, который будет содержать медиа-файлы Movies, в нашем случае /opt/plexmedia/movies.




## Нажмите на Addкнопку, а затем на Add Library.

## Вы можете добавить столько библиотек, сколько захотите.




## Нажмите Next, затем, Done и вы будете перенаправлены на веб-панель управления Plex.
#wate
#exit

###≠≠≠≠≠≠≠INFO≠≠≠≠≠≠≠≠###
# установить приложение Plex на свой Android, iPhone, Smart TV, Xbox, Roku или любое другое поддерживаемое устройство. Вы можете найти список поддерживаемых приложений и устройств на странице загрузок Plex или просто установить приложение из магазина приложений устройства.