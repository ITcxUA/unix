# ============| .bashrc |============ #

##============ ≠≠≠ ============
## Aliases
alias ls="ls -a"
alias rm='rm -rf'
alias cp='cp -i'
alias mv='mv -i'

##============ ≠≠≠ ============
## Source global definitions:
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi


##============ ≠≠≠ ============##
##  ====| BASH COMMANDS |====  ##
##============ ≠≠≠ ============##

##============ ≠≠≠ ============
## Дата и Время:
export HISTTIMEFORMAT="%Y%m%d %H:%M [$(whoami)@$(hostname -b)] # "

##============ ≠≠≠ ============
## Увеличиваем размер и количество строк:
export HISTSIZE=50000
export HISTFILESIZE=50000

##============ ≠≠≠ ============
## Команд Bash в Файл с Историей: 
shopt -s histappend

##============ ≠≠≠ ============
## Мгновенно Сохранять Историю РАНЕЕ:
## \\// -| НЕ ЗАДАНА |- :
PROMPT_COMMAND='history -a'
## \\// -|  ЗАДАНА   |- :
#PROMPT_COMMAND='$PROMPT_COMMAND; history -a'

##============ ≠≠≠ ============
## Контролируйте Bash History
export HISTCONTROL=ignorespace:erasedups
 
##============ ≠≠≠ ============
## Игнорировать Команд:
export HISTIGNORE="ls:ps:history"

##============ ≠≠≠ ============
## Исправление случайных ошибок.
shopt -s cdspell

##============ ≠≠≠ ============
## все строки многостроч.,в одной записи
shopt -s cmdhist

##============ ≠≠≠ ============
## Файла с Историею Команд
export HISTFILE=~/.history_"$USER"

##============ ≠≠≠ ============
## Применить изменения в ~/.bashrc:
#$ source ~/.bashrc

