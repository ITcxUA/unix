#!/bin/bash



#########################################################
##################   MEBU  ##############################


##=============================================
ASK="Начнем установку"
while true; do
	read -e -p "$ASK (y/n)? " rsn
  case $rsn in
    [Yy]* ) break;;
    [Nn]* ) echo "ВЫХОДИМ";exit;
  esac
done

echo "==== START ======"
##=============================================

menu() {
echo "****  -select-  *****";
echo "*********************";
echo "  1) Общая настройка системы";
echo "  2) Установка веб-сервера Apache";
echo "  3) Установка сервера баз данных MySQL";
echo "  4) Установка PHP";
echo "  5) Установка phpMyAdmin" ;
echo "  6) Ортимизация PHP" ;
echo "  7) Добавление нового домена и оптимизация" ;
echo "  8) Загрузка и установка WordPress" ;
echo "  9) " ;
echo "*********************";
}

menu
read n
case $n in
  1) SettingsINST;;
  2) installApache;;
  3) installMySQL;;
  4) installPHP;;
  5) installphpMyAdmin;;
  6) Optimization;;
  7) AddDOMAIN;;
  8) ADDWP;;
  9) ;;
  *) echo "$n-ERROR. EXIT";sleep 3;exit;;
esac
