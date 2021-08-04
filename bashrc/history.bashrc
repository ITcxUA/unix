# ============= .bashrc ============= #

##============ ≠≠≠ ============##
## Aliases

alias ls="ls -a"
alias rm='rm -rf'
alias cp='cp -i'
alias mv='mv -i'

##============ ≠≠≠ ============##
## Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

##============ ≠≠≠ ============##
######### BASH COMMANDS #########


##============ ≠≠≠ ============##
## Отображение Даты и Времени 
export HISTTIMEFORMAT="%Y%m%d %H:%M [$(whoami)@$(hostname -b)]# "

##============ ≠≠≠ ============##
##  Увеличиваем размер и количество строк
export HISTSIZE=50000
export HISTFILESIZE=50000

##============ ≠≠≠ ============##
## Добавл Команд Bash в Файл с Историей 
shopt -s histappend

##============ ≠≠≠ ============##
## Мгновенно Сохранять Историю 
###*    / == РАНЕЕ НЕ ЗАДАНА :
PROMPT_COMMAND='history -a'
###*    / == РАНЕЕ ЗАДАНА :
#PROMPT_COMMAND='$PROMPT_COMMAND; history -a'

##============ ≠≠≠ ============##
## Контролируйте Bash History HISTCONTROL — список опций, разделенных двоеточиями.
export HISTCONTROL=ignorespace:erasedups
 
##============ ≠≠≠ ============##
## Игнорировать Определенные Команды 
export HISTIGNORE="ls:ps:history"  # Не сохранять команды ls, ps и history: 

##============ ≠≠≠ ============##
## Исправление случайных ошибок.
shopt -s cdspell

##============ ≠≠≠ ============##
##  все строки многостроч.,в одной записи
shopt -s cmdhist

##============ ≠≠≠ ============##
## Изменить Имя Файла с Историй Команд
export HISTFILE=~/.history_"$USER"

##============ ≠≠≠ ============##
## Применить изменения в ~/.bashrc:
$ source ~/.bashrc


