#!/bin/bash

# Устанавливаем пакет
yum install -y zsh nano

#Меняем используемый по умолчанию shell
chsh -s /bin/zsh

#Всё готово, осталось перезайти в систему, 
#после чего у необходимо будет ответить на не сложные вопросы, 
#но мне этого мало и я устанавливаю дополнительные «плюшки» 
#(готовый конфиг zsh) под названием oh-my-zsh.
#Проверяем установлен ли у нас git и curl
 yum install -y git curl

#Далее копируем с git файлы oh-my-zsh в домашний каталог
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

#Делаем навсякий случай бэкап оригинального файла конфигурации zsh
cp ~/.zshrc ~/.zshrc.orig

#Устанавлием конфиг от oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

#После этого я устанавливаю тему для oh-my-zsh
nano ~/.zshrc
ZSH_THEME=»bira»	# bira название темы, которые хранятся в ~/.oh-my-zsh/themes/

#Список тем
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Так же можно установить необходимые плагины из ~/.oh-my-zsh/plugins/ для этого в файле ~/.zshrc ищем строку plugins
plugins=(git yum systemd firewalld) # добавляем нужные вам плагины в скобки


