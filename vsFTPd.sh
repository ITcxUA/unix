#!/bin/bash

wait() { 
echo "Нажмите клавишу,чтобы продолжить.";
read -s -n 1; 
}


vsFTPdStart() {
echo "Простая настройка ftp в CentOS 7"
wait
yum update
#Устанавливаем vsftpd:
yum install vsftpd

# Переходим к настройке
DATA="$(date +%Y%m%d-%H%M%S)"
tar czvf /etc/vsftpd$DATA.tar.gz /etc/vsftpd
rm -rf /etc/vsftpd/*

FTPCONF="/etc/vsftpd/vsftpd.conf"
touch $FTPCONF

cat>> $FTPCONF <<EOF
# Запуск сервера в режиме службы
listen=YES

# Работа в фоновом режиме
background=YES

# Имя pam сервиса для vsftpd
pam_service_name=vsftpd

# Входящие соединения контроллируются через tcp_wrappers
tcp_wrappers=YES

# Запрещает подключение анонимных пользователей
anonymous_enable=NO

# Каталог, куда будут попадать анонимные пользователи, если они разрешены
#anon_root=/ftp

# Разрешает вход для локальных пользователей
local_enable=YES

# Разрешены команды на запись и изменение
write_enable=YES

# Указывает исходящим с сервера соединениям использовать 20-й порт
connect_from_port_20=YES

# Логирование всех действий на сервере
xferlog_enable=YES

# Путь к лог-файлу
xferlog_file=/var/log/vsftpd.log

# Включение специальных ftp команд, некоторые клиенты без этого могут зависать
async_abor_enable=YES

# Локальные пользователи по-умолчанию не могут выходить за пределы своего домашнего каталога
chroot_local_user=YES

# Разрешить список пользователей, которые могут выходить за пределы домашнего каталога
chroot_list_enable=YES

# Список пользователей, которым разрешен выход из домашнего каталога
chroot_list_file=/etc/vsftpd/chroot_list

# Разрешить запись в корень chroot каталога пользователя
allow_writeable_chroot=YES

# Контроль доступа к серверу через отдельный список пользователей
userlist_enable=YES

# Файл со списками разрешенных к подключению пользователей
userlist_file=/etc/vsftpd/user_list

# Пользователь будет отклонен, если его нет в user_list
userlist_deny=NO

# Директория с настройками пользователей
user_config_dir=/etc/vsftpd/users

# Показывать файлы, начинающиеся с точки
force_dot_files=YES

# Маска прав доступа к создаваемым файлам
local_umask=022

# Порты для пассивного режима работы
pasv_min_port=49000
pasv_max_port=55000

EOF


#Добавим тестового пользователя ftp в систему:
useradd -s /sbin/nologin ftp-user
passwd ftp-user

# отключить проверку оболочки в настройках pam для vsftpd.
FTPPAM="/etc/pam.d/vsftpd"
cat>> $FTPPAM <<EOF
#%PAM-1.0
session    optional     pam_keyinit.so    force revoke
auth       required	pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
#auth       required	pam_shells.so
auth       include	password-auth
account    include	password-auth
session    required     pam_loginuid.so
session    include	password-auth
EOF

# Создаем каталог для персональных настроек
mkdir /etc/vsftpd/users

#файл с именем пользователя ftp-user и укажем его домашний каталог:
touch /etc/vsftpd/users/ftp-user
echo 'local_root=/ftp/ftp-user/' >> /etc/vsftpd/users/ftp-user
 
# создать этот каталог и назначить владельца:
mkdir /ftp && chmod 0777 /ftp
mkdir /ftp/ftp-user && chown ftp-user. /ftp/ftp-user/
 
#Создаем файл c пользователями, которым можно выходить за пределы домашнего каталога:
touch /etc/vsftpd/chroot_list
 
# Добавляем туда рута:
echo 'root' >> /etc/vsftpd/chroot_list

# Создаем файл со списком пользователей ftp, которым разрешен доступ к серверу:

touch /etc/vsftpd/user_list
echo 'root' >> /etc/vsftpd/user_list && echo 'ftp-user' >> /etc/vsftpd/user_list
# ограничить доступ к ftp серверу системных пользователей

# создать файл для логов:
touch /var/log/vsftpd.log && chmod 600 /var/log/vsftpd.log

# Добавляем vsftpd в автозагрузку и запускаем:
systemctl enable vsftpd
systemctl start vsftpd
# Проверяем, запустился ли он:
 netstat -tulnp | grep vsftpd

## tcp 0 0 0.0.0.0:21 0.0.0.0:* LISTEN 19505/vsftpd
}


vsFTPdVirtStart() {
    
}

UserSaveMYSQL() {
    
}

vsftpdcentos8() {
    
}

SetingSSLTLS() {
    
}



#########################################
menu() { 
echo "************ -MENU- *************"; 
echo "#============== ≠≠≠ ==============#"; 
echo " 1) Простая настройка ftp в CentOS 7"; 
echo " 2) Настройка vsftpd с вирт. пользователями"; 
echo " 3) Хранение vsftpd пользователей в mysql"; 
echo " 4) Настройка vsftpd в Centos 8"; 
echo " 5) Настройка SSL / TLS"; 
echo " *) Exit";
echo "#================ ≠≠≠ ================#";
}
 
##============ ≠≠≠ ============
menu 
read n 
case $n in
  1) vsFTPdStart ;;
  2) vsFTPdVirtStart ;;
  3) UserSaveMYSQL ;;
  4) vsftpdcentos8 ;;
  5) SetingSSLTLS ;;
  *) echo "$n - ERROR. EXIT";sleep 5;
  exit;;
esac


