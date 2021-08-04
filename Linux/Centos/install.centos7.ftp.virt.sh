# ====install.centos7.ftp.virt.sh==== #

# Настройка vsftpd с виртуальными пользователями
DATA = $(date +%Y%m%d-%H%M%S)
# установим доп.пакет compat-db (виртуальных пользователей):
yum install compat-db -y

# На всякий случай сохраните оригинальный pam.d файл, если захотите снова вернуться к системным пользователям:
cp /etc/pam.d/vsftpd /etc/pam.d/vsftpd.$DATA.orig
# Нужно изменить pam файл /etc/pam.d/vsftpd, приведя его к следующему виду:

/etc/pam.d/vsftpd
auth required pam_userdb.so db=/etc/vsftpd/virt_users
account required pam_userdb.so db=/etc/vsftpd/virt_users
session required pam_loginuid.so

##=====================================
##
touch /etc/vsftpd/vsftpd.conf
tar czvf /etc/vsftpd.bac.virt."$DATA".tar.gz /etc/vsftpd

cat > /etc/vsftpd/vsftpd.conf <<EOF
# Запуск сервера в режиме службы
listen=YES

# Работа в фоновом режиме
background=YES

# Разрешить подключаться виртуальным пользователям
guest_enable=YES

# Системный пользователь от имени котрого подключаются виртуальные
guest_username=ftp

# Виртуальные пользователи имеют те же привелегии, что и локальные
virtual_use_local_privs=YES

# Автоматическое назначение домашнего каталога для виртуальных пользователей
user_sub_token=$USER
local_root=/ftp/$USER

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


# конфиг для vsftpd vsftpd.conf Создаем файл с виртуальными пользователями:
touch /etc/vsftpd/virt_users

# Добавляем туда в первую строку имя пользователя, во вторую его пароль. В конце не забудьте перейти на новую строку, это важно. Файл должен быть примерно таким:

ftp-virt1
password1
ftp-virt2
password2

# Сохраняем файл и генерируем локальное хранилище учеток:
db_load -T -t hash -f /etc/vsftpd/virt_users /etc/vsftpd/virt_users.db
# У вас должен появиться файл virt_users.db.

# Нужно создать каталоги для этих пользователей:
mkdir /ftp/ftp-virt1 /ftp/ftp-virt2

# Для папки /ftp надо назначить соответствующего владельца, от которого ftp сервер будет пускать виртуальных пользователей:

chown -R ftp. /ftp
# На этом настройка виртуальных пользователей ftp закончена. Перезапускаем vsftpd и пробуем залогиниться:

systemctl restart vsftpd

##=====================================
# script add new user:
touch /etc/vsftpd/add_virt_user.sh

cat > /etc/vsftpd/add_virt_user.sh <<EOF
#!/bin/sh

echo -n "Enter name of virtual user: "
read VIRTUSER

echo -n "Enter password: "
read VIRTPASS

mkdir /ftp/$VIRTUSER
chown ftp. /ftp/$VIRTUSER
touch /etc/vsftpd/users/$VIRTUSER

echo "$VIRTUSER" >> /etc/vsftpd/virt_users
echo "$VIRTPASS" >> /etc/vsftpd/virt_users

db_load -T -t hash -f /etc/vsftpd/virt_users /etc/vsftpd/virt_users.db
EOF

#Делаете файл исполняемым и запускаете:
chmod 0700 /etc/vsftpd/add_virt_user.sh
/etc/vsftpd/add_virt_user.sh

exit