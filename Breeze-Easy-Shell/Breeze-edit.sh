#!/bin/bash
ver="v1.9.2"
title="Breeze Easy Shell"
title_full="$title $ver"
#-----------------
#типовые функции
#-----------------

#для рабты с цветами
normal="\033[0m"
green="\033[32m"
red="\033[1;31m"
blue="\033[1;34m"
black="\033[40m"
textcolor=$green
bgcolor=$black

color()
{
case "$1" in
  normal|default)
    sed -i -e 's/^textcolor=.*/textcolor=$normal/' -e 's/^bgcolor=.*/bgcolor=$normal/' breeze.sh #меняем переменную в самом скрипте
    textcolor=$normal #меняем переменную в текущей сессии
    bgcolor=$normal #меняем переменную в текущей сессии
    chosen=0 #выходим из терминала в главное меню
  ;;
  green)
    sed -i -e 's/^textcolor=.*/textcolor=$green/' -e 's/^bgcolor=.*/bgcolor=$black/' breeze.sh #меняем переменную в самом скрипте
    textcolor=$green #меняем переменную в текущей сессии
    bgcolor=$black #меняем переменную в текущей сессии
    chosen=0 #выходим из терминала в главное меню
  ;;
  blue)
    sed -i -e 's/^textcolor=.*/textcolor=$blue/' -e 's/^bgcolor=.*/bgcolor=$black/' breeze.sh #меняем переменную в самом скрипте
    textcolor=$blue #меняем переменную в текущей сессии
    bgcolor=$black #меняем переменную в текущей сессии
    chosen=0 #выходим из терминала в главное меню
  ;;
  red)
    sed -i -e 's/^textcolor=.*/textcolor=$red/' -e 's/^bgcolor=.*/bgcolor=$black/' breeze.sh #меняем переменную в самом скрипте
    textcolor=$red #меняем переменную в текущей сессии
    bgcolor=$black #меняем переменную в текущей сессии
    chosen=0 #выходим из терминала в главное меню
  ;;
  *)
echo "цвет указан неверно. Поддерживается только green, blue, red и default/normal"
  ;;
esac
}

my_clear()
{
echo -e "$textcolor$bgcolor"
clear
}

#функция, которая запрашивает только один символ
myread()
{
temp=""
while [ -z "$temp" ] #защита от пустых значений
do
read -n 1 temp
done
eval $1=$temp
echo
}

#функция, которая запрашивает только да или нет
myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]] #запрашиваем значение, пока не будет "y" или "n"
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}

#функция, которая запрашивает только цифру
myread_dig()
{
temp=""
counter=0
while [[ "$temp" != "0" && "$temp" != "1" && "$temp" != "2" && "$temp" != "3" && "$temp" != "4" && "$temp" != "5" && "$temp" != "6" && "$temp" != "7" && "$temp" != "8" && "$temp" != "9" ]] #запрашиваем значение, пока не будет цифра
do
if [ $counter -ne 0 ]; then echo -n "Неправильный выбор. Ведите цифру: "; fi
let "counter=$counter+1"
read -n 1 temp
echo
done
eval $1=$temp
}

#функция установки с проверкой не установлен ли уже пакет
myinstall()
{
if [ -z `rpm -qa $1` ]; then
	yum -y install $1
else
	echo "Пакет $1 уже установлен"
	br
fi
}

title()
{
my_clear
echo "$title"
}

menu()
{
my_clear
echo "$menu"
echo "Выберите пункт меню:"
}

wait()
{
echo "Нажмите любую клавишу, чтобы продолжить..."
read -s -n 1
}

br()
{
echo ""
}

updatescript()
{
wget $updpath/$filename -r -N -nd --no-check-certificate
chmod 777 $filename
}

#Функция проверки установленного приложения, exist возвращает true если установлена и false, если нет.
installed()
{
if [ "$2" == "force" ]; then exist=`rpm -qa $1` #добавили возможности форсированно использовать длинный вариант проверки
else #если нет ключа force, используем старый двойной вариант
	exist=`whereis $1 | awk {'print $2'}` #вариант быстрый, но не всегда эффективный
	if [ -z $exist ]
		then #будем использовать оба варианта
		exist=`rpm -qa $1` #вариант медленнее, но эффективнее
	fi
fi

if [ -n "$exist" ]
then
exist=true
else
exist=false
fi
}

#функция которая открывает на редактирование файл в приоритете: mc, nano, vi
edit()
{
installed mc
if [ $exist == true ]; then mcedit  $1
  else
  installed nano
  if [ $exist == true ]; then nano  $1
    else
    vi $1
  fi
fi
}

#функция удаления.
uninstall()
{
if [ $osver1 -eq 5 ]; then yum erase $1 $2 $3 $4 $5;
else
myinstall yum-remove-with-leaves | tee > /dev/null
yum --remove-leaves remove $1 $2 $3 $4 $5
fi
}

#Определяем активный внешний интерфейс
whatismyiface()
{
if [ $osver1 -eq 7 ]; then
  installed net-tools
  if [ $exist == false ]; then yum -y install net-tools | tee > /dev/null; fi
fi
if [ -n "$(ifconfig | grep eth0)" ]; then iface="eth0"
else
    if [ -n "$(ifconfig | grep venet0:0)" ]; then iface=venet0:0; fi
fi
}

#определяем ip на внешнем интерфейсе
whatismyip()
{
whatismyiface
case "$osver1" in
4|5|6)
ip=`ifconfig $iface | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
;;
7)
ip=`ifconfig $iface | grep 'inet' | sed q | awk {'print $2'}`
;;
*)
echo "Версия ОС неизвестна. Выходим."
wait
;;
esac
}

#определяем внешний IP через запрос
whatismyipext()
{
installed wget
if [ $exist == false ]; then myinstall wget; fi
ipext=`wget --no-check-certificate -qO- https://2ip.ru/index.php | grep "Ваш IP адрес:" | sed s/.*button\"\>// | sed s_"<"_" "_ | awk {'print $1'}`
}

whatismyip_full()
{
whatismyip
echo "Ваш внешний IP: $ip?"
myread_yn ans
case "$ans" in
  y|Y)
  #ничего не делаем, выходим из case
  ;;
  n|N|т|Т)
  echo "Если был неправильно определен IP, вы можете произвести настройку в ручном режиме."
  echo "Для этого Вам нужно определить как называется Ваш сетевой интерфейс, через который Вы выходите в интернет."
  echo "Если хотите вывести на экран все сетевые интерфейсы, чтобы определить какой из них внешний - нажмите 1."
  myread ans
  if [ "$ans" == "1" ]; then ifconfig; br; wait; fi
  br
  echo "Укажите название интерфейса, который имеет внешний IP (обычно eth0, venet0 или venet0:0)"
  read int
  ip=`ifconfig $int | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
  #centOS7
  if [ $osver1 -eq 7 ]; then ip=`ifconfig $int | grep 'inet' | sed q | awk {'print $2'}`; fi
  echo "Ваш внешний IP: $ip?"
  myread_yn ans
  case "$ans" in
    y|Y)
    ;;
    n|N|т|Т)
    echo "Тогда введите IP вручную:"
    read ip
    ;;
    *)
    echo "Неправильный ответ. Выходим."
    wait
    sh $0
    exit 0
    ;;
  esac
  ;;
  *)
  echo "Неправильный ответ. Выходим."
  wait
  sh $0
  exit 0
  ;;
esac
}

bench_cpu () {
threads=$cpu_cores #делаем кол-во потоков, равное кол-ву ядер
if [ -z $threads ]; then threads=1; fi #если по какой-то причине мы не знаем сколько ядер, ставим в один поток
#if [ -z $cpu_clock ]; then cpu_clock=2394; fi #если по какой-то причине мы не знаем свою частоту, то берем эталонную
totalspeed=$(sysbench cpu --cpu-max-prime=10000 run --num-threads=$threads | grep "events per second:" | awk {'print $4'}) #записали общую скорость
temp=$(echo "${totalspeed/./}") #убрали точку, т.е. умножили на 100.
if [ ${temp:0:1} -eq 0 ]; then temp=$(echo "${temp:1}"); fi #проверили нет ли нуля в начале, если есть - убрали
reference=75000 #скорость на эталонном процессоре, умноженная на 100.
#let "discountpower = $power * 2394 / $cpu_clock" #сколько тестов он бы прошёл при той же частоте, что и эталонный процессор
let "powerpercent = $temp * 1000 / $reference" #мощность этого процессора делим на мощность эталлонного процессора и выражаем в процентах с десятыми долями (но без точки)
powerpercent=$(echo $powerpercent|sed 's/.$/.&/') #добавили точку
#let "discountpowerpercent = $discountpower * 100 / $reference " #мощность этого процессора делим на мощность эталлонного процессора и выражаем в процентах
if [ $threads -gt 1 ]; then #если ядер больше одного, посчитаем еще относительную мощность одного ядра к эталону
let "speedpercore= $temp / $threads" #тут скорость уже умножена на 100
let "powerpercorepercent = $speedpercore * 1000 / $reference " #мощность одного ядра этого процессора к мощности эталонного процессора, выражено в процентах с десятыми долями, но без точки
powerpercorepercent=$(echo $powerpercorepercent|sed 's/.$/.&/') #добавили точку
fi
}


bench_hdd () {
        # Measuring disk speed with DD
        io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        echo "   Первый прогон: $io"
        io2=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        echo "   Второй прогон: $io2"
        io3=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        echo "   Третий прогон: $io3"
        # Calculating avg I/O (better approach with awk for non int values)
        if [ $(echo $io | awk '{print $2}') = "GB/s" ] #проверили а не гигабайты ли это
        then #гигабайты
        ioraw=$( echo $io | awk 'NR==1 {print $1}' ) #взяли только число
        gb=$(echo $ioraw |  sed 's/\./ /' | awk '{print $1}') #взяли кол-во гигабайт
        mb=$(echo $ioraw |  sed 's/\./ /' | awk '{print $2}') #взяли кол-во мегабайт
        if [ ${#mb} -eq 1 ]; then let "mb=$mb*1024/10"; else #переводим десятые доли гигабайт в мегабайты
          if [ ${#mb} -eq 2 ]; then let "mb=$mb*1024/100"; else #переводим сотвые долги гигабайт в мегабайты
            if [ ${#mb} -eq 3 ]; then let "mb=$mb*1024/1000"; else #переводим тысячные долги гигабайт в мегабайты
            mb=0
            fi   
          fi
        fi
        let "ioraw=$gb*1024+$mb"
        else ioraw=$( echo $io | awk 'NR==1 {print $1}' )           
        fi

        if [ $(echo $io2 | awk '{print $2}') = "GB/s" ] #проверили а не гигабайты ли это
        then #гигабайты
        ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' ) #взяли только число
        gb=$(echo $ioraw2 |  sed 's/\./ /' | awk '{print $1}') #взяли кол-во гигабайт
        mb=$(echo $ioraw2 |  sed 's/\./ /' | awk '{print $2}') #взяли кол-во мегабайт
        if [ ${#mb} -eq 1 ]; then let "mb=$mb*1024/10"; else #переводим десятые доли гигабайт в мегабайты
          if [ ${#mb} -eq 2 ]; then let "mb=$mb*1024/100"; else #переводим сотвые долги гигабайт в мегабайты
            if [ ${#mb} -eq 3 ]; then let "mb=$mb*1024/1000"; else #переводим тысячные долги гигабайт в мегабайты
            mb=0
            fi   
          fi
        fi
        let "ioraw2=$gb*1024+$mb"
        else ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )           
        fi

        if [ $(echo $io3 | awk '{print $2}') = "GB/s" ] #проверили а не гигабайты ли это
        then #гигабайты
        ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' ) #взяли только число
        gb=$(echo $ioraw3 |  sed 's/\./ /' | awk '{print $1}') #взяли кол-во гигабайт
        mb=$(echo $ioraw3 |  sed 's/\./ /' | awk '{print $2}') #взяли кол-во мегабайт
        if [ ${#mb} -eq 1 ]; then let "mb=$mb*1024/10"; else #переводим десятые доли гигабайт в мегабайты
          if [ ${#mb} -eq 2 ]; then let "mb=$mb*1024/100"; else #переводим сотвые долги гигабайт в мегабайты
            if [ ${#mb} -eq 3 ]; then let "mb=$mb*1024/1000"; else #переводим тысячные долги гигабайт в мегабайты
            mb=0
            fi   
          fi
        fi
        let "ioraw3=$gb*1024+$mb"
        else ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )           
        fi

        ioall=$( awk 'BEGIN{print '$ioraw' + '$ioraw2' + '$ioraw3'}' )
        ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
        
        echo "Среднее значение: $ioavg MB/s"
}


showinfo()
{
echo "┌──────────────────────────────────────────────────────────────┐"
echo "│                     Информация о системе                     │"
echo "└──────────────────────────────────────────────────────────────┘"
echo "                            CPU: $cpu_cores x $cpu_clock MHz ($cpu_model)"
if [ $swap_mb -eq 0 ]; then echo "                            RAM: $mem_mb Mb"; else
echo "                            RAM: $mem_mb Mb (Плюс swap $swap_mb Mb)"; fi
#Определяем диск (делаем это при каждом выводе, т.к. данные меняются)
hdd_total=`df | awk '(NR == 2)' | awk '{print $2}'`
let "hdd_total_mb=$hdd_total / 1024"
hdd_free=`df | awk '(NR == 2)' | awk '{print $4}'`
let "hdd_free_mb=$hdd_free / 1024"
#Определяем uptime системы (делаем это при каждом выводе)
uptime=$(uptime | sed -e "s/ * / /g") #сразу берем аптайм без двойных пробелов
uptime=$(echo "${uptime%,* user*}")
uptime=$(echo "${uptime#*up }")
echo "                            HDD: $hdd_total_mb Mb (свободно $hdd_free_mb Mb)"
echo "                             ОС: $osfamily $osver2"
echo "                 Разрядность ОС: $arc bit"
echo "              Версия ядра Linux: $kern"
echo "                 Аптайм системы: $uptime"
if [ ${#iface} -eq 4 ]; then #проверяем какой сетевой интерфейс. Если мы его не определили, то вообще не выводим эту строку
echo "      Ваш IP на интерфейсе $iface: $ip"; fi #длина строки подобрана под eth0
if [ ${#iface} -eq 8 ]; then
echo "  Ваш IP на интерфейсе $iface: $ip"; fi #длина строки подобрана под venet0:0
echo "Ваш внешний IP определяется как: $ipext"
}

about()
{
echo "Данную утилиту написал Павел Евтихов (aka Brizovsky).
г. Екатеринбург, Россия.
2016-2019 год.
"
}
changelog()
{
wget $updpath/changelog.txt -r -N -nd
cat changelog.txt
br
}

log()
{
changelog
}

release() #функция принудительной загрузки релиза
{
wget https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/master/$filename -r -N -nd --no-check-certificate
chmod 777 $filename
sh $0
exit
}

beta() #функция принудительной загрузки Бета-версии
{
wget https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/beta/$filename -r -N -nd --no-check-certificate
chmod 777 $filename
sh $0
exit
}

#-----------------
#задаем переменные
#-----------------
#Задаём переменную с нужным количеством пробелов, чтобы меню не разъезжалось от смены версии
title_full_len=${#title_full}
title_len=${#title}
space=""
      let "space_len=43-$title_full_len" 
      while [ "${#space}" -le $space_len ]
      do
      space=$space" "
      done

space2=""
      let "space2_len=30-$title_len" 
      while [ "${#space2}" -le $space2_len ]
      do
      space2=$space2" "
      done

filename='breeze.sh'
#updpath='https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/master' #релиз
updpath='https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/beta' #бета

#определяем сколько RAM
mem_total=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
swap_total=`cat /proc/meminfo | grep SwapTotal | awk '{print $2}'`
let "mem_mb=$mem_total / 1024"
let "swap_mb=$swap_total / 1024"

#Определяем данные процессора
cpu_clock=`cat /proc/cpuinfo | grep "cpu MHz" | awk {'print $4'} | sed q`
let "cpu_clock=$(printf %.0f $cpu_clock)"
#cpu_cores=`cat /proc/cpuinfo | grep "cpu cores" | awk {'print $4'}`
cpu_cores=`grep -o "processor" <<< "$(cat /proc/cpuinfo)" | wc -l`
cpu_model=`cat /proc/cpuinfo | grep "model name" | sed q | sed -e "s/model name//" | sed -e "s/://" | sed -e 's/^[ \t]*//' | sed -e "s/(tm)/™/g" | sed -e "s/(C)/©/g" | sed -e "s/(R)/®/g"`
#уберём двойные пробелы:
cpu_model=`echo $cpu_model | sed -e "s/ * / /g"`

#Определяем ОС
if [ "$(cat /etc/redhat-release | awk {'print $2'})" == "release" ]
then
  osfamily=$(cat /etc/redhat-release | awk {'print $1'})
  osver2=$(cat /etc/redhat-release | awk {'print $3'})
else
  if [ "$(cat /etc/redhat-release | awk {'print $3'})" == "release" ]
    then
    osfamily=$(cat /etc/redhat-release | awk {'print $1'})" "$(cat /etc/redhat-release | awk {'print $2'})
    osver2=$(cat /etc/redhat-release | awk {'print $4'})
  else osver2=0
  fi
fi
osver1=`echo $osver2 | cut -c 1` #берём только первый символ от версии для определения поколения
if [ "$osfamily" == "CentOS Linux" ]; then osfamily="CentOS"; fi

#Определяем разрядность ОС
arc=`arch`
if [ "$arc" == "x86_64" ]; then arc=64 #В теории возможно обозначение "IA-64" и "AMD64", но я не встречал
else arc=32 #Чтобы не перебирать все возможные IA-32, x86, i686, i586 и т.д.
fi 

#определяем версию ядра Linux
kern=`uname -r | sed -e "s/-/ /" | awk {'print $1'}`

menu="
┌─────────────────────────────────────────────┐
│ $title $ver$space│
├───┬─────────────────────────────────────────┤
│ 1 │ Информация о системе                    │
├───┼─────────────────────────────────────────┤
│ 2 │ Работа с ОС                             │
├───┼─────────────────────────────────────────┤
│ 3 │ Установить панель управления хостингом  │
├───┼─────────────────────────────────────────┤
│ 4 │ Установка и настройка VPN-сервера       │
├───┼─────────────────────────────────────────┤
│ 5 │ Работа с Proxy                          │
├───┼─────────────────────────────────────────┤
│ 6 │ Работа с файлами и программами          │
├───┼─────────────────────────────────────────┤
│ 7 │ Очистка системы                         │
├───┼─────────────────────────────────────────┤
│ 8 │ Терминал                                │
├───┼─────────────────────────────────────────┤
│ 9 │ Обновить $title$space2│
├───┼─────────────────────────────────────────┤
│ 0 │ Выход                                   │
└───┴─────────────────────────────────────────┘
"
menu1="
● Информация о системе:
│
│ ┌───┬──────────────────────────────────────┐
├─┤ 1 │ Показать общую информацию о системе  │
│ ├───┼──────────────────────────────────────┤
├─┤ 2 │ Провести тест скорости CPU           │
│ ├───┼──────────────────────────────────────┤
├─┤ 3 │ Провести тест скорости диска         │
│ ├───┼──────────────────────────────────────┤
├─┤ 4 │ Описание теста производительности    │
│ ├───┼──────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх               │
  └───┴──────────────────────────────────────┘
"
menu2="
● Работа с ОС:
│
│ ┌───┬──────────────────────────────────────┐
├─┤ 1 │ Добавить внешние репозитории         │
│ ├───┼──────────────────────────────────────┤
├─┤ 2 │ Обновить ОС                          │
│ ├───┼──────────────────────────────────────┤
├─┤ 3 │ Установить популярные приложения     │
│ ├───┼──────────────────────────────────────┤
├─┤ 4 │ Антивирус                            │
│ ├───┼──────────────────────────────────────┤
├─┤ 5 │ Firewall (iptables)                  │
│ ├───┼──────────────────────────────────────┤
├─┤ 6 │ Планировщик задач (cron)             │
│ ├───┼──────────────────────────────────────┤
├─┤ 7 │ Установить часовой пояс              │
│ ├───┼──────────────────────────────────────┤
├─┤ 8 │ Сменить пароль текущего пользователя │
│ ├───┼──────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх               │
  └───┴──────────────────────────────────────┘
"
menu24="
● Работа с ОС:
│
└─● Антивирус:
  │
  │ ┌───┬───────────────────────────┐
  ├─┤ 1 │ Установить Антивирус      │
  │ ├───┼───────────────────────────┤
  ├─┤ 2 │ Обновить антивирус        │
  │ ├───┼───────────────────────────┤
  ├─┤ 3 │ Проверить папку на вирусы │
  │ ├───┼───────────────────────────┤
  ├─┤ 4 │ Удалить антивирус         │
  │ ├───┼───────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх    │
    └───┴───────────────────────────┘
"
menu25="
● Работа с ОС:
│
└─● Firewall (iptables):
  │
  │ ┌───┬───────────────────────────────────────────────┐
  ├─┤ 1 │ Включить firewall (помощник настройки)        │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 2 │ Отключить firewall (рарешить все подключения) │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 3 │ Временно выключить firewall                   │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 4 │ Перезапустить firewall                        │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 5 │ Открыть порт в iptables                       │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 6 │ Закрыть ранее открытый порт в iptables        │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 7 │ Посмотреть текущую политику firewall          │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 8 │ Сохранить текущие правила firewall            │
  │ ├───┼───────────────────────────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх                        │
    └───┴───────────────────────────────────────────────┘
"
menu26="
● Работа с ОС:
│
└─● Планировщик задач (cron):
  │
  │ ┌───┬─────────────────────────────────────────┐
  ├─┤ 1 │ Проверить запущен ли планировщик (cron) │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 2 │ Перезапустить cron                      │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 3 │ Добавить задание в планировщик (cron)   │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 4 │ Открыть файл с заданиями cron           │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 5 │ Выключить планировщик (cron)            │
  │ ├───┼─────────────────────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх                  │
    └───┴─────────────────────────────────────────┘
"
menu27="
● Работа с ОС:
│
└─● Установить часовой пояс:
  │
  │ ┌───┬────────────────────────┐
  ├─┤ 1 │ Калининград            │
  │ ├───┼────────────────────────┤
  ├─┤ 2 │ Москва                 │
  │ ├───┼────────────────────────┤
  ├─┤ 3 │ Самара                 │
  │ ├───┼────────────────────────┤
  ├─┤ 4 │ Екатеринбург           │
  │ ├───┼────────────────────────┤
  ├─┤ 5 │ Новосибирск            │
  │ ├───┼────────────────────────┤
  ├─┤ 6 │ Красноярск             │
  │ ├───┼────────────────────────┤
  ├─┤ 7 │ Иркутск                │
  │ ├───┼────────────────────────┤
  ├─┤ 8 │ Владивосток            │
  │ ├───┼────────────────────────┤
  ├─┤ 9 │ Камчатка               │
  │ ├───┼────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх │
    └───┴────────────────────────┘
"
menu3="
● Установить панель управления хостингом:
│
│ ┌───┬────────────────────────┐
├─┤ 1 │ ISPmanager 4           │
│ ├───┼────────────────────────┤
├─┤ 2 │ ISPmanager 5           │
│ ├───┼────────────────────────┤
├─┤ 3 │ Brainy CP              │
│ ├───┼────────────────────────┤
├─┤ 4 │ Vesta CP               │
│ ├───┼────────────────────────┤
├─┤ 5 │ Webuzo                 │
│ ├───┼────────────────────────┤
├─┤ 6 │ CentOS Web Panel (CWP) │
│ ├───┼────────────────────────┤
├─┤ 7 │ ZPanel CP              │
│ ├───┼────────────────────────┤
├─┤ 8 │ Ajenti                 │
│ ├───┼────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх │
  └───┴────────────────────────┘
"
menu4="
● Установка и настройка VPN-сервера:
│
│ ┌───┬────────────────────────────────────────────────┐
├─┤ 1 │ Установить VPN-сервер (pptpd)                  │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 2 │ Добавить пользователей VPN                     │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 3 │ Открыть файл с логинами/паролями пользователей │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 4 │ Добавить правила для работы VPN в IPTables     │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 5 │ Удалить VPN-сервер                             │
│ ├───┼────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                         │
  └───┴────────────────────────────────────────────────┘
"
menu5="
● Работа с Proxy:
│
│ ┌───┬────────────────────────────────────────────────┐
├─┤ 1 │ Установить Proxy-сервер (на базе Squid)        │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 2 │ Удалить Proxy (Squid)                          │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 3 │ Поменять MTU для интерфейса                    │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 4 │ Открыть файл настроек Squid                    │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 5 │ Добавить пользователя Proxy                    │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 6 │ Открыть файл с логинами/паролями пользователей │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 7 │ Перезапустить сервис Proxy (Squid)             │
│ ├───┼────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                         │
  └───┴────────────────────────────────────────────────┘
"
menu6="
● Работа с файлами и программами:
│
│ ┌───┬─────────────────────────────────────────────────────┐
├─┤ 1 │ Установить какую-либо программу                     │
│ ├───┼─────────────────────────────────────────────────────┤
├─┤ 2 │ Удалить какую-либо программу                        │
│ ├───┼─────────────────────────────────────────────────────┤
├─┤ 3 │ Удалить какую-либо программу со всеми зависимостями │
│ ├───┼─────────────────────────────────────────────────────┤
├─┤ 4 │ Посмотреть сколько свободного места на диске        │
│ ├───┼─────────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                              │
  └───┴─────────────────────────────────────────────────────┘
"
menu7="
● Очистка системы:
│
│ ┌───┬─────────────────────────────────────────────────┐
├─┤ 1 │ Удалить старые установочные пакеты (кэш yum)    │
│ ├───┼─────────────────────────────────────────────────┤
├─┤ 2 │ Удалить логи Apache, Nginx, Squid и прочие логи │
│ ├───┼─────────────────────────────────────────────────┤
├─┤ 3 │ Удалить логи Apache конкретного пользователя    │
│ ├───┼─────────────────────────────────────────────────┤
├─┤ 4 │ Посмотреть сколько свободного места на диске    │
│ ├───┼─────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                          │
  └───┴─────────────────────────────────────────────────┘
"

#-----------------
#Интерфейс
#-----------------
repeat=true
chosen=0
chosen2=0
while [ "$repeat" = "true" ] #выводим меню, пока не надо выйти
do

#пошёл вывод
if [ $chosen -eq 0 ]; then #выводим меню, только если ещё никуда не заходили
menu
myread_dig pick
else
pick=$chosen
fi

case "$pick" in
1) #Информация о системе
chosen=1
my_clear
echo "$title"
echo "$menu1"
myread_dig pick
    case "$pick" in
    1) #Показать общую информацию о системе
    ;;
    2) #Провести тест скорости CPU
    ;;
    3) #Провести тест скорости диска
    ;;
    4) #Описание теста производительности
    ;;
    0)
     chosen=0
    ;;
    esac
;;
2) #Работа с ОС
chosen=2
my_clear
if [ $chosen2 -eq 0 ]; then #выводим меню, только если ещё никуда не заходили
echo "$title"
echo "$menu2"
myread_dig pick
else
pick=$chosen2
fi
    case "$pick" in
    1) #Добавить внешние репозитории
    ;;
    2) #Обновить ОС
    ;;
    3) #Установить популярные приложения
    ;;
    4) #Антивирус
    chosen2=4
    my_clear
    echo "$title"
    echo "$menu24"
    myread_dig pick
    case "$pick" in
      1) #Установить Антивирус
      ;;
      2) #Обновить антивирус
      ;;
      3) #Проверить папку на вирусы
      ;;
      4) #Удалить антивирус
      ;;
      0)
      chosen2=0
      ;;
    esac
    ;;
    5) #Firewall (iptables)
    chosen2=5
    my_clear
    echo "$title"
    echo "$menu25"
    myread_dig pick
    case "$pick" in
      1) #Включить firewall (помощник настройки)
      ;;
      2) #Выключить firewall (рарешить все подключения
      ;;
      3) #Временно выключить firewall
      ;;
      4) #Перезапустить firewall
      ;;
      5) #Открыть порт в iptables
      echo "Укажите в какую сторону вы хотите открыть порт:"
      echo "1) Входящие соединения (чтобы к этому серверу можно было подключиться по заданному порту)"
      echo "2) Исходящие соединения (чтобы этот сервер мог подключиться к другим компьютерам по заданному порту)"
      echo "3) Перенаправление пакетов (раздел FORWARD)"
      myread_dig taffic_type
      case "$taffic_type" in
      1)
      ;;
      2)
     
      ;;
      3)
    
      ;;      
      *)
      echo "Неправильный выбор. Аварийный выход."
      wait
      exit
      ;;
      esac
      br
      echo "Укажите какой порт вы хотите открыть:"
      read port
      br
      echo "Выберите протокол, по которому его нужно открыть:"
      echo "1) TCP"
      echo "2) UDP"
      echo "3) TCP и UDP"
      myread_dig protocol
      case "$protocol" in
		1)
		openport $taffic_type tcp $port
		;;
		2)
		openport $taffic_type udp $port
		;;
		3)
		openport $taffic_type tcp $port
		openport $taffic_type udp $port
		;;
		*)
		echo "Неправильный выбор."
		;;
      esac
      br
      echo "Готово."
      wait
      ;;
      6) #Закрыть ранее открытый порт в iptables
	  br
	  iptables --list --line-numbers
	  br
	  echo "Из какого раздела вы хотите удалить правило?"
      echo "1) Входящие соединения (раздел INPUT)"
      echo "2) Исходящие соединения (раздел OUTPUT)"
      echo "3) Перенаправление пакетов (раздел FORWARD)"
      myread_dig section
      case "$section" in
      	1)
      	section=INPUT
      	;;
      	2)
      	section=OUTPUT
      	;;
	  	3)
      	section=FORWARD
      	;;      
      	*)
      	echo "Неправильный выбор. Аварийный выход."
      	wait
      	exit
      	;;
      esac
      echo "Правило под каким номером нужно удалить?"
      myread_dig rule_number
      iptables -D $section $rule_number
	  iptables_save
	  br
      echo "Правило удалено"
	  wait
	  ;;
      7) #Посмотреть текущую политику firewall
      iptables -nvL
      br
      wait
      ;;
      8) #Сохранить текущие правила firewall
      iptables_save
      br
      echo "Готово."
      wait
      ;;
      0)
      chosen2=0
      ;;
    esac
    ;;
    6) #Планировщик задач (cron)
    chosen2=6
    my_clear
    echo "$title"
    echo "$menu26"
	myread_dig pick
    case "$pick" in
		1) #Проверить запущен ли планировщик (cron)
		installed crond
		if [ $exist == false ]; then 
			echo "Сервис Cron не установлен. Установить?"
			myread_yn pick
			case "$pick" in
				y|Y)
					case "$osver1" in
						4|5|6)
							myinstall vixie-cron crontabs
						;;
						7)
							myinstall cronie
						;;
					esac
				br
				echo "Установка завершена, продолжаем работу..."
				wait
				my_clear
				;;
			esac
		fi
		if [[ -n $(service crond status | grep "is running") ]]; then
			echo "Планировщик Cron работает..."
			wait
		else
			echo "Планировщик Cron в данный момент не запущен. Попробовать запустить?"
			myread_yn pick
			case "$pick" in
				y|Y)
				service crond start
				br
				echo "Готово. Хотите добавить Cron в автозагрузку, чтобы он запускался после каждой перезагрузки?"
				myread_yn pick
				case "$pick" in
					y|Y)
					echo "Добавляем..."
					chkconfig crond on
					echo "Готово."
					br
					wait
					;;
				esac	
				;;
			esac
		fi
		;;
		2) #Перезапустить cron
		service crond restart
		br
		wait
		;;
		3) #Добавить задание в планировщик (cron)
		my_clear
		echo "Введите команду, которую должен выполнять планировщик:"
		read cron_task
		br
		echo "Выберите интервал, с которым должна выполняться эта задача:"
		echo "1) При каждой загрузке системы"
		echo "2) Один или несколько раз в час"
		echo "3) Один или несколько раз в день"
		echo "4) Один раз в неделю"
		echo "5) Один раз в месяц"
		echo "0) Не нужно выполнять, я передумал"
		myread_dig pick
		case "$pick" in
			1)
			echo "@reboot $cron_task" >> /var/spool/cron/$(whoami)
			echo "Готово. Задание будет выполняться после каждой загрузки системы."
			;;
			2)
			br
			echo "Выберите интервал"
			echo "1) Каждый час"
			echo "2) Два раза в час (каждые 30 минут)"
			echo "3) Три раза в час (каждые 20 минут)"
			echo "4) Четыре раза в час (каждые 15 минут)"
			echo "5) Шесть раз в час (каждые 10 минут)"
			echo "6) Двенадцать раз в час (каждые 5 минут)"
			echo "7) Тридцать раз в час (каждые 2 минуты)"
			echo "8) Шестьдесят раз в час (каждую минуту)"
			echo "0) Не нужно выполнять, я передумал"
			myread_dig pick
			case "$pick" in
				1)
				echo "0 * * * * $cron_task" >> /var/spool/cron/$(whoami) # @hourly
				echo "Готово. Задание будет выполняться в 0 минут каждого часа."
				;;
				2)
				echo "*/30 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 30 минут"					
				;;
				3)
				echo "*/20 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 20 минут"				
				;;
				4)
				echo "*/15 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 15 минут"				
				;;
				5)
				echo "*/10 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 10 минут"				
				;;
				6)
				echo "*/5 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 5 минут"				
				;;
				7)
				echo "*/2 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 2 минуты"				
				;;
				8)
				echo "* * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждую минуту"				
				;;
				0)
				;;
				*)
				echo "Неправильный выбор..."
				;;				
			esac
			;;
			3)
			br
			echo "Выберите интервал"
			echo "1) Каждый день (можно выбрать в какой час)"
			echo "2) Два раза в день (каждые 12 часов)"
			echo "3) Три раза в день (каждые 8 часов)"
			echo "4) Четыре раза в день (каждые 6 часов)"
			echo "5) Шесть раз в день (каждые 4 часа)"
			echo "6) Двенадцать раз в день (каждые 2 часа)"
			echo "0) Не нужно выполнять, я передумал"
			myread_dig pick
			case "$pick" in
				1)
				br
				echo "Укажите в какой час запускать задание (0-23)"
				read temp
				let temp2=$temp+0
				if [[ $temp2 -gt 0 && $temp2 -le 23 ]]; then #введён правильно
					echo "0 $temp * * * $cron_task" >> /var/spool/cron/$(whoami)
					echo "Готово. Задание будет выполняться каждый $temp-й час"
				else #возможно введён неправильно
					if [[ "$temp" = "0" ]]; then #всё-таки введён правильно
						echo "0 $temp * * * $cron_task" >> /var/spool/cron/$(whoami)
						echo "Готово. Задание будет выполняться каждый $temp-й час"
					else #точно введён неправильно
						echo "Неправильно указали час"
					fi
				fi
				;;
				2)
				echo "0 */12 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 12 часов"					
				;;
				3)
				echo "0 */8 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 8 часов"					
				;;
				4)
				echo "0 */6 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 6 часов"					
				;;
				5)
				echo "0 */4 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 4 часа"					
				;;
				6)
				echo "0 */2 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 2 часа"					
				;;
				0)
				;;
				*)
				echo "Неправильный выбор..."
				;;	
			esac
			;;
			4)
			br
			echo "Выберите день недели, в который надо запускать задание"
			echo "1) Понедельник"
			echo "2) Вторник"
			echo "3) Среда"
			echo "4) Четверг"
			echo "5) Пятница"
			echo "6) Суббота"
			echo "7) Воскресенье"
			echo "0) Не нужно выполнять, я передумал"
			myread_dig pick
			case "$pick" in
				1|2|3|4|5|6|7)
				echo "0 4 * * $pick $cron_task" >> /var/spool/cron/$(whoami)
				case "$pick" in
					1) day="каждый понедельник"
					;;
					2) day="каждый вторник"
					;;
					3) day="каждую среду"
					;;
					4) day="каждый четверг"
					;;
					5) day="каждую пятницу"
					;;
					6) day="каждую субботу"
					;;
					7) day="каждое воскресенье"
					;;
				esac
				echo "Готово. Задание будет выполняться $day в 4 часа утра."
				;;
				0)
				;;
				*)
				echo "Неправильный выбор..."
				;;
			esac
			;;
			5)
			br
			echo "Укажите в какой день месяца запускать задание"
			read temp
			let temp=$temp+0
			if [[ $temp -gt 0 && $temp -le 31 ]]; then #введён правильно
				echo "0 4 $temp * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждое $temp-ое часло каждого месяца в 4 часа утра."
			else # введён неправильно
				echo "Неправильно выбрано число"
			fi
			;;
			0)
			;;
			*)
			echo "Неправильный выбор..."
			;;
		esac
		service crond reload  | tee > /dev/null
		br
		wait
		;;
		4) #Открыть файл с заданиями cron
		edit /var/spool/cron/$(whoami)
		;;
		5) #Выключить планировщик (cron)
		echo "Планировщик не рекомендуется отключать. Вы уверены что хотите отключить его?"
		myread_yn pick
		case "$pick" in
			y|Y)
			br
			service crond stop
			br
			echo "Планировщик был выключен. Если он стоял в автозагрузке, то он вновь будет запущен после перезагрузки системы"
			br
			wait
			;;
		esac
		;;
		0) #Выйти на уровень вверх
		chosen2=0
		;;
	esac	
    ;;
    7) #Установить часовой пояс
    my_clear
    echo "$title"
    echo "$menu27"
    echo "Текущее время на этом компьютере: $(date +%H:%M). Выберите часовой пояс, который хотите установить."
    myread_dig pick
        case "$pick" in
        1)
        settimezone Europe Kaliningrad
        ;;
        2)
        settimezone Europe Moscow
        ;;
        3)
        settimezone Europe Samara
        ;;
        4)
        settimezone Asia Yekaterinburg
        ;;
        5)
        settimezone Asia Novosibirsk
        ;;
        6)
        settimezone Asia Krasnoyarsk
        ;;
        7)
        settimezone Asia Irkutsk
        ;;
        8)
        settimezone Asia Vladivostok
        ;;
        9)
        settimezone Asia Kamchatka
        ;;
        0)
        ;;
        *)
        echo "Неправильный выбор."
        wait
        esac
    ;;
    8) #Сменить пароль текущего пользователя
    passwd
    br
    wait
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор"
    wait
    ;;
    esac
;;
3) #Установить панель управления хостингом
chosen=3
my_clear
echo "$title"
echo "$menu3"
myread_dig pick
    case "$pick" in
    1) #ISPmanager 4
    my_clear
    echo 'Панель управления "ISPManager 4"'
    echo 'Поддержка ОС: CentOS | RHEL | Debian | Ubuntu'
    echo 'Системные требования: минимальные не определены'
    echo 'Лицензия: Панель управления ПЛАТНАЯ! Без лицензии, активированной на ваш IP даже не установится.'
    echo 'Язык: Русский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
        wget "http://download.ispsystem.com/install.4.sh" -r -N -nd
        sh install.4.sh
        wait
        rm -f install.4.sh
      ;;
    esac
    ;;
    2) #ISPmanager 5
    my_clear
    echo 'Панель управления "ISPManager 5"'
    echo 'Поддержка ОС: CentOS | RHEL | Debian | Ubuntu'
    echo 'Системные требования: минимальные не определены'
    echo 'Лицензия: Панель управления ПЛАТНАЯ! После установки будет Trial на 14 дней.'
    echo 'Язык: Русский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
        wget http://cdn.ispsystem.com/install.sh -r -N -nd
        sh install.sh
        rm -f install.sh
      ;;
    esac
    ;;
    3) #Brainy CP
    my_clear
    echo 'Панель управления "Brainy"'
    echo 'Поддержка ОС: CentOS 7 64bit (и только эта ОС!)'
    echo 'Системные требования (минимальные): 512 Mb RAM + 1Gb SWAP, HDD 2 Gb в корневом разделе'
    echo 'Системные требования (рекомендованные): 2 Gb RAM + 2Gb SWAP, HDD 3 Gb в корневом разделе'
    echo 'Лицензия: Панель абсолютно бесплатная'
    echo 'Язык: Русский, Английский, Польский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
	  yum clean all && yum install -y wget && wget http://core.brainycp.com/install.sh && bash ./install.sh
	  wait
      ;;
    esac
    ;;
    4) #Vesta CP
    my_clear
    echo 'Панель управления "Vesta CP"'
    echo 'Поддержка ОС: CentOS | RHEL | Debian | Ubuntu'
    echo 'Системные требования: минимальные не определены'
    echo 'Лицензия: Панель управления полностью бесплатна.'
    echo 'Язык: Английский, русский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      if [[ $(pidof httpd) != "" ]] #проверяем установлен ли httpd
      then
        echo "У вас установлен http-сервер, а Vesta CP требует установки на чистую машину."
        echo 'Хотите удалить его перед установкой "Vesta CP"?'
        myread_yn pick
        case "$pick" in
          y|Y)
          service httpd stop
          yum erase httpd -y
          ;;
        esac
      fi
      br
      echo 'Начинаем установку...'
      openport in tcp 8083
      wget http://vestacp.com/pub/vst-install.sh -r -N -nd
      sh vst-install.sh --force
      rm -f vst-install.sh
      ;;
    esac
    ;;
    5) #Webuzo
    my_clear
    echo 'Панель управления "Webuzo"'
    echo 'Поддержка ОС: CentOS 5.x, 6.x | RHEL 5.x, 6.x | Scientific Linux 5.x, 6.x | Ubuntu LTS'
    echo 'Системные требования: 512 Mb RAM (minimum)'
    echo 'Лицензия: Панель управления имеет платную и бесплатную версию. Установите без лицензии для использования бесплатной версии.'
    echo 'Язык: Английский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        5|6)
        webuzo_install
        ;;
        7)
        echo 'У вас CentOS 7.x. Данная панель управления не поддерживает эту версию. Выходим.'
        wait
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          webuzo_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    6) #CentOS Web Panel (CWP)
    my_clear
    echo 'Панель управления "CentOS Web Panel (CWP)"'
    echo 'Поддержка ОС: CentOS 6.x | RHEL 6.x | CloudLinux 6.x'
    echo 'Системные требования: 512 MB RAM (minimum)'
    echo 'Лицензия: Панель управления полностью бесплатна.'
    echo 'Язык: Английский'
    br
    echo "ВНИМАНИЕ! Данная панель будет устанавливаться очень долго (до 1 часа)!"
    br
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        5|7)
        echo "У вас CentOS $osver1.x. Данная панель управления не поддерживает эту версию. Выходим."
        wait
        ;;
        6)
        cwp_install
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          cwp_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    7) #ZPanel CP
    my_clear
    echo 'Панель управления "ZPanel CP"'
    echo 'Поддержка ОС: CentOS 6.x | RHEL 6.x'
    echo 'Системные требования: не указаны разработчиком'
    echo 'Лицензия: Панель управления полностью бесплатна.'
    echo 'Язык: Английский, немецкий'
    br
    echo 'ВНИМАНИЕ! Поддержка данной панели давно прекращена, русификации нет. Устанавливайте на свой страх и риск.'
    br
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        5|7)
        echo "У вас CentOS $osver1.x. Данная панель управления не поддерживает эту версию. Выходим."
        wait
        ;;
        6)
        zpanel_install
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          zpanel_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    8) #Ajenti
    my_clear
    echo 'Панель управления "Ajenti"'
    echo 'Поддержка ОС: CentOS 6, 7 | Debian 6, 7, 8 | Ubuntu | Gentoo'
    echo 'Системные требования: 35 Mb RAM '
    echo 'Лицензия: Панель имеет как бесплатную версию, так и платную'
    echo 'Описание: Ajenti - это панель управления сервером, но к ней есть Addon под названием Ajenti V,'
    echo '          с помощью которого можно управлять хостингом.'
    echo 'Язык: Английский, русский и ещё 42 других языка'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        4|5)
        echo "У вас CentOS $osver1.x. Данная панель управления не поддерживает эту версию. Выходим."
        wait
        ;;
        6|7)
        ajenti_install
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          ajenti_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор."
    wait
    ;;
    esac
;;
4) #Установка и настройка VPN-сервера
chosen=4
my_clear
echo "$title"
echo "$menu4"
myread_dig pick
    case "$pick" in
    1) #Установить VPN-сервер (pptpd)
        echo "Внимание! Данный скрипт работает ТОЛЬКО на centOS!"
        echo "Внимание! Для работы VPN нужен интерфейс PPP, который обычно отключен при виртуализации"
        echo "на OpenVZ. Его можно включить через тех.поддержку или в панели управления сервером."
        echo "Если у вас технология виртуализации XEN или KVM, то всё нормально."
        br
        echo "Далее будет произведено обновление ОС и установка нужных компонентов для VPN-сервера."
        wait
        br
        echo "установка PPTP"
        #CentOS 5
        if [ $osver1 -eq 5 ]; then rpm -Uvh http://pptpclient.sourceforge.net/yum/stable/rhel5/pptp-release-current.noarch.rpm; fi
        #yum update -y
        yum -y install ppp pptpd pptp
        br
        whatismyip_full
          #открываем порты и настраиваем маршрутизацию
          br
          echo "Открываем порты в firewall для работы VPN"
          br
            iptables -I INPUT -p 47 -j ACCEPT
            iptables -I OUTPUT -p 47 -j ACCEPT
			openport in tcp 1723
			openport out tcp 1723
            iptables -t nat -I POSTROUTING -j SNAT --to $ip
            iptables -I FORWARD -s 10.1.0.0/24 -j ACCEPT
            iptables -I FORWARD -d 10.1.0.0/24 -j ACCEPT
          #теперь делаем так, чтобы сохранились правила после перезагрузки
          iptables_save
          br
          echo "Введите имя пользователя, которое нужно создать (н.п.. client1 or john):"
          read u
          echo "Введите пароль для этого пользователя:"
          read p
          br
          echo "Создание конфигурации сервера"
          cat > /etc/ppp/pptpd-options <<END
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
nodefaultroute
lock
nobsdcomp
END
          sed -i -e '/net.ipv4.ip_forward = 0/d' /etc/sysctl.conf #Удаляем строчку net.ipv4.ip_forward = 0
          echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
          sysctl -p
          # setting up pptpd.conf
          echo "option /etc/ppp/pptpd-options" > /etc/pptpd.conf
          echo "logwtmp" >> /etc/pptpd.conf
          echo "localip $ip" >> /etc/pptpd.conf
          echo "remoteip 10.1.0.1-100" >> /etc/pptpd.conf
          #autostart pptpd
          chkconfig pptpd on          
          # adding new user
          echo "$u * $p *" >> /etc/ppp/chap-secrets
          # правим mtu для 10 ppp-юзеров
          sed -i -e '/exit 0/d' /etc/ppp/ip-up #Удаляем exit 0 в конце файла
          cat >> /etc/ppp/ip-up <<END
ifconfig ppp0 mtu 1400
ifconfig ppp1 mtu 1400
ifconfig ppp2 mtu 1400
ifconfig ppp3 mtu 1400
ifconfig ppp4 mtu 1400
ifconfig ppp5 mtu 1400
ifconfig ppp6 mtu 1400
ifconfig ppp7 mtu 1400
ifconfig ppp8 mtu 1400
ifconfig ppp9 mtu 1400
exit 0 #возвращаем exit 0
END
          br
          echo "Перезапуск PPTP"
          service pptpd restart
          #centOS7
          if [ $osver1 -eq 7 ]; then systemctl start pptpd; systemctl enable pptpd.service; fi
          br
          echo "Настройка вашего собственного VPN завершена!"
          echo "Ваш IP: $ip? логин и пароль:"
          echo "Имя пользователя (логин):$u ##### Пароль: $p"
          br
          wait
    ;;
    2) #Добавить пользователей VPN
    echo "Введите имя пользователя для создания (eg. client1 or john):"
    read u
    echo "введите пароль для создаваемого пользователя:"
    read p
    # adding new user
    echo "$u * $p *" >> /etc/ppp/chap-secrets
    echo
    echo "Дополнительный пользователь создан!"
    echo "Имя пользователя (логин):$u ##### Пароль: $p"
    br
    wait
    ;;
    3) #Открыть файл с логинами/паролями пользователей
    edit /etc/ppp/chap-secrets
    ;;
    4) #Добавить правила для работы VPN в IPTables
    whatismyip_full    
    iptables -I INPUT -p 47 -j ACCEPT
    iptables -I OUTPUT -p 47 -j ACCEPT
	openport in tcp 1723
	openport out tcp 1723
    iptables -t nat -I POSTROUTING -j SNAT --to $ip
    iptables -I FORWARD -s 10.1.0.0/24 -j ACCEPT
    iptables -I FORWARD -d 10.1.0.0/24 -j ACCEPT
    br
    echo 'Хотите, чтобы это правило сохранялось после перезагрузки?'
    myread_yn ans
    case "$ans" in
      y|Y)
      iptables_save  
      ;;
    esac
    br
    wait
    ;;
    5) #Удалить VPN-сервер
    ;;
    n|N)
    ;;
    *)
    echo "Неправильный ответ"
    ;;
    esac
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор"
    ;;
    esac
;;
5) #Работа с Proxy
chosen=5
my_clear
echo "$title"
echo "$menu5"
myread_dig pick
    case "$pick" in
    1) #Установить Proxy-сервер (на базе Squid)
    echo "Выберите вариант авторизации на Proxy:"
    echo "1) Свободный доступ (любой, кто знает IP и порт - может воспользоваться)"
    echo "2) Доступ по логину/паролю"
    myread_dig ans
    case "$ans" in
		1) ##########
		;;
		2) ###########
		case "$osver1" in
			4|5)
	        	;;
			6|7)
			;;
		esac
		;;
		*)
		echo "Неправильный выбор. Аварийный выход."
		wait
		exit
		;;
    esac
 
    ;;
    2) #Удалить 
    ;;
    3) #Поменять MTU
    ;;
    4) #Открыть файл
   
    ;;
    5) #Добавить пользователей Proxy
	br
	case "$osver1" in
		4|5) # punktu 4 5
		;;
		6|7) # punktu 6 7
			;;
	esac
        wait
    ;;
    6) #Открыть
    ;;    
    7) #Перезапустить
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор" ;wait
    ;;
    esac
;;
6) #Работа с файлами и программами
chosen=6
my_clear
echo "$title"
echo "$menu6"
myread_dig pick
    case "$pick" in
    1) #Установить
    ;;
    2) #Удалить
    ;;
    3) #Удалить
    ;;
    4) #Посмотреть 
    br
    df -h
    br
    wait    
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор"
    wait
    ;;
    esac
;;
7) #Очистка системы
chosen=7
my_clear
echo "$title"
echo "$menu7"
myread_dig pick
    case "$pick" in
    1) #Очистить кэш yum
    ;;
    2) #Удалить 
    ;;
    3) #Удалить 
    ;;
    4) #По
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор. Нажмите любую клавишу, чтобы продолжить."
    ;;
    esac
;;
8) #терминал
chosen=8
echo "Введите команду:"
;;
9) #Обновить Breeze Easy Shell
echo "обновляю..."
repeat=false
sh $0
exit 0
;;
0)
repeat=false
;;
*)
echo "Неправильный выбор."
wait
;;
esac
done
echo "Скрипт ожидаемо завершил свою работу."
echo -e "$normal"
clear
