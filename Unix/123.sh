#!/bin/bash

yum update -y && yum upgrade -y
yum install mc nano

cp -r /usr/share/mc/syntax/sh.syntax /usr/share/mc/syntax/unknown.syntax


yum install net-tools
## Чтобы у нас работали команды nslookup или, к примеру, host необходимо установить пакет bind-utils. Если этого не сделать, то на команду:

 nslookup
#Будет вывод:

# -bash: nslookup: command not found

# Так что устанавливаем bind-utils:
# yum install bind-utils


Отключить SELinux
Отключаем SELinux. Его использование и настройка отдельный разговор. Сейчас я не буду этим заниматься. Так что отключаем:

# mcedit /etc/sysconfig/selinux
меняем значение

SELINUX=disabled
Чтобы изменения вступили в силу, можно перезагрузиться:

# reboot
А если хотите без перезагрузки применить отключение SELinux, то выполните команду:

# setenforce 0