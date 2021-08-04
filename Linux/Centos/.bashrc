### ***  --- .bashrc ---  *** ##

function bashRCAlias() {
## =======================≠=============
## Aliases
## ======================≠==============
alias ls="ls -a"
alias cp="cp -i"
alias rm="rm -rf"
alias mv="mv -i"



}

## ======================≠==============
#   Bash Комманды 
## =======================≠=============

## 1.Отображение Даты и Времени 
export HISTTIMEFORMAT="%Y%m%d %H:%M #/> "

## 2.Увеличиваем размер и количество строк
export HISTSIZE=50000
export HISTFILESIZE=50000

## 3.Добавл Команд Bash в Файл с Историей 
shopt -s histappend

## 4. Мгновенно Сохранять Историю 
# *         / ==== НЕ БЫЛА ЗАДАНА :
PROMPT_COMMAND='history -a'

# *         / ==== БЫЛА РАНЕЕЗАДАНА :
# PROMPT_COMMAND='$PROMPT_COMMAND; history -a'

## 5. Контролируйте Bash History
# HISTCONTROL — список опций, разделенных двоеточиями.
export HISTCONTROL=ignorespace:erasedups
 
## 6. Игнорировать Определенные Команды 
export HISTIGNORE="ls:ps:history"  # Не сохранять команды ls, ps и history: 

## 7. Исправление случайных ошибок.
shopt -s cdspell

## 8.все строки многостроч.,в одной записи
shopt -s cmdhist

## 9. Изменить Имя Файла с Историй Команд
export HISTFILE=~/.history_"$USER"





## ===================================
##  ----Опция Описание----  ##
##
#$ ignorespace	не сохранять строки начинающиеся с символа <пробел>
# $ ignoredups	не сохранять строки, совпадающие с последней выполненной командой
# $ ignoreboth	использовать обе опции ‘ignorespace’ и ‘ignoredups’
# $ erasedups	удалять ВСЕ дубликаты команд с истории
## Каждая вводимая в терминале команда сохраняется в файле ~/.bash_history. Чтобы посмотреть историю команд – введите history. Настройка истории команд в Bash осуществляется путем добавления переменных окружения в файл  ~/.bashrc.

## Применить изменения в ~/.bashrc:
# $ source ~/.bashrc
