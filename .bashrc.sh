#!/bin/bash

wait() { echo ""; echo "Press any key to continue..."; read -s -n 1; }


echo "******************************"
echo "Внести правки в файл .bashrc ?"
wait
echo "Вносим . . ."
echo " "
sleep 5

#################################################
cat>> ~/.bashrc <<EOF

## * * * * * * * * * * * * * * * * * * * * * * ##
##              | BASH COMMANDS |              ##
## * * * * * * * * * * * * * * * * * * * * * * ##

## * * * * * * * * * * * * * * * * * * * * * * 
## Aliases
alias rm='rm -rf'

## * * * * * * * * * * * * * * * * * * * * * * 
## Date and Time:
export HISTTIMEFORMAT="%Y%m%d %H:%M:%S [$(whoami)@$(hostname -b) ]# "

## * * * * * * * * * * * * * * * * * * * * * * 
## Увеличиваем размер и количество строк:
export HISTSIZE=50000
export HISTFILESIZE=50000

## * * * * * * * * * * * * * * * * * * * * * * 
## COMMANDS Bash in history: 
shopt -s histappend

## * * * * * * * * * * * * * * * * * * * * * * 
## Мгновенно Сохранять Историю РАНЕЕ:
## \\// -| НЕ ЗАДАНА |- :
PROMPT_COMMAND='history -a'
## \\// -|  ЗАДАНА   |- :
#PROMPT_COMMAND='$PROMPT_COMMAND; history -a'

## * * * * * * * * * * * * * * * * * * * * * * 
## Control Bash History
export HISTCONTROL=ignorespace:erasedups        # HISTCONTROL — список опций, разделенных двоеточиями.
 
## * * * * * * * * * * * * * * * * * * * * * * 
## Игнорировать Команд:
export HISTIGNORE="ls:ps:history"               # Не сохранять команды ls, ps и history: 

## * * * * * * * * * * * * * * * * * * * * * * 
## Исправление случайных ошибок.
shopt -s cdspell

## * * * * * * * * * * * * * * * * * * * * * * 
## все строки многостроч.,в одной записи
shopt -s cmdhist

## * * * * * * * * * * * * * * * * * * * * * * 
## Файла с Историею Команд
export HISTFILE=~/.history_"$USER"

## * * * * * * * * * * * * * * * * * * * * * * 
## Применить изменения в ~/.bashrc:
#$ source ~/.bashrc
EOF

echo "Применяем параметры"
sleep 5
source ~/.bashrc
echo "Добавили и применили. Выйти?"
wait
exit
