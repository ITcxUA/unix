#!/bin/bash


wait() {
	echo "";
	echo "Press any key to continue...";
	read -s -n 1;
}
ENDcom() { 
	echo "";
	echo "Press any key to EXIT..."; 
	read -s -n 1;
}


echo "******************************"
echo "Внести правки в файл .bashrc ?"
sleep 1

#############################
funcBASHRCcomDEF() {
	clear
	echo 'Копируем.....'
	#wait
	sleep 2

	mkdir -p ~/TMP
	cat ~/.bashrc > ~/TMP/bashrc
	cat ~/TMP/bashrc > ~/.bashrc
	sed -i "s/alias rm='rm -i'/alias rm='rm -rf'/" ~/.bashrc
	echo '============ NEXT ================='
}


funcBASHRCstok() {
	clear
	echo 'Создаем Дефолтные'
	#wait
	sleep 2

	echo '# .bashrc' > ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '# User specific aliases and functions' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo "alias rm='rm -rf'" >> ~/.bashrc 
	echo "alias cp='cp -i'" >> ~/.bashrc 
	echo "alias mv='mv -i'" >> ~/.bashrc 
	echo "alias ls='ls -a'" >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '# Source global definitions' >> ~/.bashrc 
	echo 'if [ -f /etc/bashrc ]; then' >> ~/.bashrc 
	echo '        . /etc/bashrc' >> ~/.bashrc 
	echo 'fi' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '============ NEXT ================='
}


## * * * * * * * * * * * * * * * * * * * *
funcBASHcommands() {
	echo '## * * * * * * * * * * * * * * * * * * * * * ##'
	echo '##             | BASH COMMANDS |             ##'
	echo '## * * * * * * * * * * * * * * * * * * * * * ##'
	#wait
	sleep 2

	echo '## * * * * * * * * * * * * * * * * * * * * * ##' >> ~/.bashrc 
	echo '##             | BASH COMMANDS |             ##' >> ~/.bashrc 
	echo '## * * * * * * * * * * * * * * * * * * * * * ##' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## Date and Time:' >> ~/.bashrc 
	echo 'export HISTTIMEFORMAT="%Y%m%d %H:%M%S [$(whoami)@$(hostname -b)]# "' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## Увеличиваем размер и количество строк:' >> ~/.bashrc 
	echo 'export HISTSIZE=50000' >> ~/.bashrc 
	echo 'export HISTFILESIZE=50000' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## COMMANDS Bash in history: ' >> ~/.bashrc 
	echo 'shopt -s histappend' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## Control Bash History' >> ~/.bashrc 
	echo '## HISTCONTROL — список опций, раздел.двоеточ' >> ~/.bashrc 
	echo 'export HISTCONTROL=ignorespace:erasedups' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## Игнорировать Команд:' >> ~/.bashrc 
	echo '## Не сохранять команды ls, ps и history: ' >> ~/.bashrc 
	echo '# export HISTIGNORE="ls:ps:history"' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## Исправление случайных ошибок.' >> ~/.bashrc 
	echo 'shopt -s cdspell' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## все строки многостроч.,в одной записи' >> ~/.bashrc 
	echo 'shopt -s cmdhist' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## Файла с Историею Команд' >> ~/.bashrc 
	echo 'export HISTFILE=~/.history_"$USER"' >> ~/.bashrc
	echo '============ NEXT ================='
}


########################################
funcBASHRCinfo() {
	#wait
	echo ' Запись Info '
	sleep 2

	echo '' >> ~/.bashrc 
	echo '' >> ~/.bashrc 
	echo '## * * * * * * * * * * * * * * * * * * * * * ##' >> ~/.bashrc 
	echo '##              |     info     |             ##' >> ~/.bashrc 
	echo '## * * * * * * * * * * * * * * * * * * * * * ##' >> ~/.bashrc 
	echo '##' >> ~/.bashrc 
	echo '##  Применить изменения в ~/.bashrc:' >> ~/.bashrc 
	echo '## $(source ~/.bashrc)' >> ~/.bashrc 
	echo '##' >> ~/.bashrc 
	echo '## * * * * * * * * * * * * * * * * * * * * * ##' >> ~/.bashrc 
	echo '============ NEXT ================='
}

########################################
funcPROMPT_COMMAND() {
	
	echo 'Внесем изминения в файл  '
	wait
	sleep 2
	
    bashrcCOMM="PROMPT_COMMAND"
    if grep $bashrcCOMM ~/.bashrc
    then
      		#funcBASHRCcomDEF
	      	funcBASHRCstok
      		funcBASHcommands
	      	funcBASHRCinfo
        echo "" >> ~/.bashrc
        # echo "## Мгновенно Сохранять Историю ( ЗАДАНА РАНЕЕ )" >> ~/.bashrc
        # echo "PROMPT_COMMAND='\$PROMPT_COMMAND; history -a'" >> ~/.bashrc
        sed -i "s/^.*PROMPT_COMMAND*.*$/PROMPT_COMMAND='\$PROMPT_COMMAND; history -a'/" ~/.bashrc
    else
	      	#funcBASHRCcomDEF
      		funcBASHRCstok
      		funcBASHcommands
      		funcBASHRCinfo
        echo "" >> ~/.bashrc
        echo "## Мгновенно Сохранять Историю ( НЕ ЗАДАНА РАНЕЕ ):" >> ~/.bashrc
        echo "PROMPT_COMMAND='history -a'" >> ~/.bashrc
    fi

	funcBASHRCinfo
	echo "Применим команды ~/.bashrc "
	wait
	sleep 2
	source ~/.bashrc
	sleep 3
	echo '============ NEXT ================='
}
funcPROMPT_COMMAND;

ENDcom;

exit
