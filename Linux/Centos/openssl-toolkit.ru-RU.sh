#!/bin/bash

# Variables
default_timeout=3
default_tolerance=7776000 # 90 days
isSelfSigned=false
certificateFiles="*.key *.csr *.crt *.cert *.der"

CREATESERT="Создать сертификаты.";
CONVERSERT="Преобразовать сертификаты.";
# Colors
# example: echo -e "${green} TEXT ${def}"
red='\e[91m' # Red
green='\e[92m' #Bold Green
yellow='\e[93m' #Yellow
underlined='\e[4m'
bold='\e[1m'  #Bold
ubold=`tput bold; tput smul` #Underline Bold
def='\e[0m' # No Color - default

function askYesOrNo {
    REPLY=""
    while [ -z "$REPLY" ] ; do
        read -ep "$1 $YES_NO_PROMPT" -n1 REPLY
        REPLY=$(echo ${REPLY}|tr [:lower:] [:upper:])
        case $REPLY in
            $YES_CAPS ) return 0 ;;
            $NO_CAPS ) return 1 ;;
            * ) REPLY=""
        esac
    done
}

# Initialize the yes/no prompt
YES_STRING=$"y"
NO_STRING=$"n"
YES_NO_PROMPT=$"[y/n]: "
YES_CAPS=$(echo ${YES_STRING}|tr [:lower:] [:upper:])
NO_CAPS=$(echo ${NO_STRING}|tr [:lower:] [:upper:])

# Certificate functions
function certPath {
    while [ true ];do
        read -ep "Введите путь для хранения файлов сертификатов: " certPath;
        if [ ! -d $certPath ]; then
            if askYesOrNo $"Путь не существует, вы хотите создать его сейчас?"; then
                mkdir -p $certPath;
                break;
            fi
        else break;
        fi
    done
}

function newCertPass {
    while :
        do
            read -p "Введите пароль для закрытого ключа: " -s -r pass;
            printf "\n";
            read -p "Подтвердить пароль: " -s -r passCompare;
            if [ "$pass" = "$passCompare" ]; then
                echo
                break;
            else
                    echo -e "\n Пароли не совпадают. \n";
            fi
        done
}

function createSelfSignedCertificate {
    echo -e "\n Примечание: следующее создаст CSR, закрытый ключ и сгенерирует самозаверяющий сертификат.\n"
    createCSRKey
    signCert
    createPEM
}

function createCSRKey {
    #Начало создания сценария CSR и ключа.
    certPath
        cd $certPath;
        echo -e "\n Создание ключа и CSR";
        newCertPass

    echo ""
    openssl genrsa -passout pass:${pass} -des3 -out server.key 2048;
    openssl req -sha256 -new -key server.key -out server.csr -passin pass:${pass};
    key=${PWD##&/}"/server.key";
    csr=${PWD##&/}"/server.csr";

    echo -e "\nserver.key можно найти по адресу "$key;
    echo -e "server.csr можно найти по адресу "$csr;
}

function signCert {
    # Предполагая, что мы находимся в каталоге
    isSelfSigned=true
    crt=${PWD##&/}"/server.crt"
    echo -e "\nПодпись сертификата."
    if [ -f $key ] && [ -f $csr ];then
        read -ep " Введите количество дней, в течение которых сертификат будет действителен (ПРИМЕР, 730): " certDays;
        if [[ -z "$certDays" ]]; then
            certDays=730;
        fi
        openssl x509 -req -sha256 -days $certDays -in $csr -signkey $key -out $crt -passin pass:${pass} 2>/dev/null;
        echo -e "Сертификат сервера создан в $crt";
        else
            echo "Не удалось найти server.key ИЛИ server.csr in "${PWD##&/};
    fi
}

function createPEM {
    echo -e "\nСоздание PEM ..."

    # Ask for files/path if not self-signed
    if (! $isSelfSigned); then
        echo -e "Пожалуйста, предоставьте закрытый ключ, открытый ключ или сертификат, а также любой промежуточный ЦС или пакеты.\n"
        read -ep "Введите полный путь к файлам сертификатов (например, /root/certificates): " path;
        if [ -d $path ];then
            cd $path;
            ls --format=single-column | column
            if [ $? -eq 0 ]; then
                echo ""
                while true;
                do
                    read -ep "Введите имя файла закрытый ключ   (key): " key;
                    read -ep "Введите имя файла открытого ключа (crt): " crt;
                    if [ -f "$key" ] && [ -f "$crt" ];then
                        break
                    else echo -e "Неверное имя файла.\n";
                    fi
                done
                newCertPass
            else
                echo -e "Невозможно найти какие-либо или все файлы сертификатов.";
            fi
        else echo "Неверный путь к файлу.";
        fi
    fi

    # Создать PEM
    if [ -f "$key" ] && [ -f "$crt" ];then
        # dos2unix файлы для удаления проблемных символов
        dos2unix $key $crt &>/dev/null

        # Удаление пароля из закрытого ключа, если он содержит
        openssl rsa -in $key -out nopassword.key -passin pass:${pass} 2>/dev/null;
        if [ $? -eq 0 ]; then
            echo "$(cat nopassword.key)" > server.pem;
            rm -f nopassword.key;
            echo "$(cat $crt)" >> server.pem;

            if (! $isSelfSigned); then
                while [ true ];
                do
                crtName=""
                echo
                if askYesOrNo $"Добавить промежуточный сертификат?";then
                    ls --format=single-column | column
                    read -ep "Промежуточное имя файла: " crtName;
                    if [ ! -z "$crtName" ];then
                        dos2unix $crtName &>/dev/null
                        echo "$(cat $crtName)" >> server.pem;
                    fi
                else
                    break;
                fi
                done
            fi
            echo -e "Создание server.pem at "${PWD##&/}"/server.pem\n";
        else echo "Неверный пароль.";
        fi
    else echo "Неверный ввод файла.";
    fi
}

function verifyCSRPrivateKeyPair {
    echo -e "\nПожалуйста, предоставьте открытый и закрытый ключ CSR\n"
    read -ep "Введите полный путь к файлам сертификатов (например, /root/certificates): " path;
    if [ -d $path ];then
        cd $path;
    echo "Список файлов сертификатов ..."
        ls -l
        if [ $? -ne 0 ]; then
            echo -e "\nНе удалось найти файлы сертификатов (.key, .crt, *.csr). Список всех: ";
            ls
        fi
        echo
        read -ep "Введите закрытый ключ (.key): " key;
        read -ep "Введите CSR: " csr;
        if [ -f ${PWD}"/$key" ]  && [ -f ${PWD}"/$csr" ]; then
            echo
            key=`openssl rsa -noout -modulus -in $key | openssl md5`
            csr=`openssl req -noout -modulus -in $csr | openssl md5`
            echo
            if [ "$key" == "$csr" ]; then
                echo -e "${green}Success${def}.CSR - открытый ключ закрытого ключа"
            else echo "${red}Ошибка${def}. Недопустимая пара! CSR не является открытым ключом закрытого ключа."
            fi
            echo "key: " $key
            echo "csr: " $csr
        else
            echo -e "Неверный ввод файла.";
        fi
    fi
}
function verifyServerCertificatePrivateKeyPair {
    echo -e "\nПожалуйста, предоставьте закрытый ключ и открытый key/certificate\n"
    read -ep "Введите полный путь к файлам сертификатов (например, /root/certificates): " path;
    if [ -d $path ];then
        cd $path;
    echo "Список файлов сертификатов ..."
        ls -l
        if [ $? -ne 0 ]; then
            echo -e "\nНе удалось найти файлы сертификатов (.key, .crt). Список всех:";
            ls
        fi
        echo
        read -ep "Введите закрытый ключ (.key): " key;
        # read -ep "Enter the CSR: " csr;
        read -ep "Введите открытый ключ (.crt): " crt;
        if [ -f ${PWD}"/$key" ]  && [ -f ${PWD}"/$crt" ]; then
            echo
            crt=`openssl x509 -noout -modulus -in $crt | openssl md5`
            key=`openssl rsa -noout -modulus -in $key | openssl md5`
            echo
            if [ "$crt" == "$key" ]; then
                echo "${green}Success${def}. Сертификаты подтверждены."
            else echo "${red}Ошибка${def}. Несовпадение сертификата!"
            fi
            echo "key: " $key
            echo "crt: " $crt
        else
            echo -e "Неверный ввод файла.";
        fi
    fi
    echo -e "\nГотово."
    read -p "Нажмите [Enter], чтобы продолжить"
}
function verifyChainFileAppliesToSignedCertificate {
    echo -e "\nПожалуйста,предоставьте корневой/промежуточный и подписанный CA сертификаты\n"
    read -ep "Введите полный путь к файлам сертификатов (например,/root/certificates): " path;
    if [ -d $path ];then
        cd $path;
    echo "Список файлов сертификатов ..."
        ls -l
        echo
        read -ep "Введите файл, содержащий как root, так и промежуточные звенья: " cafile;
        read -ep "Введите файл, содержащий подписанный сертификат: " crt;
        if [ -f ${PWD}"/$cafile" ]  && [ -f ${PWD}"/$crt" ]; then
            echo
            openssl verify -verbose -purpose sslserver -CAfile "$cafile" "$crt"
            if [ $? -eq 0 ]; then
                echo -e "\n${green}Успешно${def}. Сертификаты совпадают, образуя полную цепочку SSL."
            else echo -e "\n${red}Ошибка${def}. Сертификаты не образуют полную цепочку SSL."
            fi
            echo "cafile: " "${PWD}/$cafile"
            echo "crt: " "${PWD}/$crt"
        else
            echo -e "Неверный ввод файла.";
        fi
    fi
}
function testSSLCertificateInstallation {
    # Prompt for server address
    local valid
    while [ "$valid" != "true" ]; do
        echo -e "Проверить подтверждение SSL-сертификата. Примечание. Результаты будут переданы по конвейеру меньше.\n"
        read -ep "DNS/IP-адрес сервера и порт (server:port): " server;
        if [[ $server =~ .*:[[:digit:]]*$ ]]; then
            valid=true
            else echo -e "Неверный синтаксис для DNS / IP-адреса сервера. Повторите попытку.\n"
        fi
    done

    echo -e "Проверка установки сертификата SSL ..."
    timeout $default_timeout echo | openssl s_client -connect $server | less
    echo -e "Отображен вывод подключения."

}

function checkPermittedProtocols {
    # TODO: запрашивать разрешенные протоколы (в настоящее время жестко запрограммированы)
    # по умолчанию: проверяет, может ли быть установлено соединение, отличное от SSL3 или TLS

    # Запрашивать адрес сервера
    local valid
    while [ "$valid" != "true" ]; do
        echo -e "Проверять разрешенные протоколы.\n"
        read -ep "DNS / IP-адрес сервера и порт (server:port): " server;
        if [[ $server =~ .*:[[:digit:]]*$ ]]; then
            valid=true
            else echo -e "Неверный синтаксис для DNS/IP-адреса сервера.Повторите попытку.\n"
        fi
    done

    echo -e "\nПроверка разрешенных протоколов (соединение, отличное от SSL3 или TLS1) для $server...\n"
    bad_protocol=false; bad_cipher=false;
    timeout $default_timeout openssl s_client -connect $server -no_ssl3 -no_tls1
    if [ $? -eq 0 ]; then
        bad_protocol=true
    fi
    timeout $default_timeout openssl s_client -connect $server -cipher NULL,LOW
    if [ $? -eq 0 ]; then
        bad_cipher=true
    fi

    # TODO: Handle other errors: dns lookup for hostname fails, fail to connect
    if($bad_protocol || $bad_cipher); then
        echo -e "\nНе разрешенный протокол может быть установлен!";
        else echo -e "\nТолько разрешенные протоколы могут быть установлены. Проблем не обнаружено."
    fi

}

function checkValidityOfCertificateFile {
    local path;
    local crtFile;
    echo -e "\nПроверьте дату действия сертификатов. \n\nПожалуйста, предоставьте файл сертификата."
    read -ep "Введите полный путь для файлов сертификатов (например, /root/certificates): " path;
    if [ -d $path ];then
        cd $path;
    echo "Список файлов сертификатов ..."
        ls -l
        echo
        read -ep "Введите сертификат: " crtFile;
        if [[ -f ${PWD}"/$crtFile" ]]; then

            checkStatus=$(openssl x509 -checkend $default_tolerance -in $crtFile)
            checkStatus+=" within $(echo "$default_tolerance / 86400" | bc) days"
            echo -e "\n$checkStatus"
            openssl x509 -noout -enddate -in $crtFile

        else
            echo -e "Неверный ввод файла.";
        fi
    fi
}

function getFilename {
    local file="$1"
    echo "${file%%.*}"
}
function getFileExtension {
    local file="$1"
    echo "${file##*.}"
}
# Convert
function checkFileExtension {
    local file="$1"
    local exp="$2"
    local ext=$(getFileExtension "$file")
    if [ "$ext" == "$exp" ]; then
        echo 0
    else
        if askYesOrNo $"Расширение файла. $ext (expected .$exp), вы уверены?"; then
            echo 0
        else echo 1
        fi
    fi
}
function handleConversionOutput {
    if [[ $1 -eq 0 ]]; then
        echo -e "\n${green}Успешно${def}."
        echo -e "Преобразован '$2' to '$3'"
        echo -e "${PWD}/$target"
        else echo -e "\n${red}Ошибка${def}."
    fi
}
function convertCertificate {
    local source
    echo -e "\nПреобразовать сертификат: $1. \n\nPlease provide the certificate file."
    read -ep "Enter the full path for certificate files (ie. /root/certificates): " path;
    if [ -d $path ];then
        cd $path;
    echo "Вывод файлов сертификатов ..."
        ls -l
        echo
        read -ep "Enter the certificate: " source;
        if [[ -f ${PWD}"/$source" ]]; then
             sourcename=$(getFilename "$source") # filename without extension
        else
            echo -e "Неверный ввод файла.";
        fi
    fi

    local sourcename=$(getFilename "$source")
    local target="$sourcename"
    case "$1" in
        "convertPEMtoDER")
            target="$target.der"
            rc=$(checkFileExtension "$source" "pem")
            if [[ $rc -eq 0 ]]; then
                openssl x509 -outform der -in "$source" -out "$target"
                handleConversionOutput "$?" "$source" "$target"
            fi;;
        "convertPEMtoP7B")
            target="$target.p7b"
            rc=$(checkFileExtension "$source" "pem")
            if [[ $rc -eq 0 ]]; then
                openssl crl2pkcs7 -nocrl -certfile "$source" -out "$target"
                handleConversionOutput "$?" "$source" "$target"
            fi;;
        "convertPEMtoPFX")
            target="$target.pfx"
            rc=$(checkFileExtension "$source" "pem")
            if [[ $rc -eq 0 ]]; then
                openssl pkcs12 -export -out "$target" -inkey "$source" -in "$source" -certfile "$source"
                handleConversionOutput "$?" "$source" "$target"
            fi;;
        "convertDERtoPEM")
            target="$target.pem"
            rc=$(checkFileExtension "$source" "der")
            if [[ $rc -eq 0 ]]; then
                openssl x509 -inform der -in "$source" -out "$target"
                handleConversionOutput "$?" "$source" "$target"
            fi;;
        "convertP7BtoPEM")
            target="$target.pem"
            rc=$(checkFileExtension "$source" "p7b")
            if [[ $rc -eq 0 ]]; then
                openssl pkcs7 -print_certs -in "$source" -out "$target"
                handleConversionOutput "$?" "$source" "$target"
            fi;;
        "convertP7BtoPFX")
            target="$target.pfx"
            rc=$(checkFileExtension "$source" "p7b")
            if [[ $rc -eq 0 ]]; then
                openssl pkcs7 -print_certs -in "$source" -out "$target"
                handleConversionOutput "$?" "$source" "$target"
            fi;;
        "convertPFXtoPEM")
            target="$target.pem"
            rc=$(checkFileExtension "$source" "pfx")
            if [[ $rc -eq 0 ]]; then
                openssl pkcs12 -in "$source" -out "$target" -nodes
                handleConversionOutput "$?" "$source" "$target"
            fi;;
        *) echo -e "\nЗапрошено неподдерживаемое преобразование: $1"
    esac
}

function checkValidityOfSSLServer {

    local valid;
    local server;
    while [ "$valid" != "true" ]; do
        echo -e "Проверьте срок действия ssl-сервера. \n\n Предоставьте информацию о сервере."
        read -ep "Сервер DNS/IP-адрес и порт(server:port): " server;
        if [[ $server =~ .*:[[:digit:]]*$ ]]; then
            valid=true
            else echo -e "Неверный синтаксис для DNS/IP-адреса сервера. Пожалуйста, попробуйте еще раз.\n"
        fi
    done

    echo -e "\n Проверка срока действия даты $server \n"
    timeout $default_timeout echo | openssl s_client -connect "$server" 2>&1 | openssl x509 -text | grep -i -B1 -A3 validity

}

function output {
    type="$1"
    echo -e "\n Вывести информацию о сертификате ($type). Примечание. Результаты будут переданы по конвейеру меньше. \n\n Предоставьте файл сертификата."
    read -ep "Введите полный путь для файлов сертификатов (например,  /root/certificates): " path;
    if [ -d $path ];then
        cd $path;
    echo "Вывод файлов сертификатов ..."
        ls -l
        echo
        read -ep "Введите сертификат: " crtFile;
        if [[ -f ${PWD}"/$crtFile" ]]; then
            echo "Информация о сертификате была отображена."

            if [ "$type" == "csr" ]; then
                openssl req -text -in ${PWD}"/$crtFile" | less
            elif [ "$type" == "crt" ]; then
                openssl x509 -text -in ${PWD}"/$crtFile" | less
            else echo "Неверный тип вывода: $type"
            fi

        else
            echo -e "Неверный ввод файла.";
        fi
    fi
}

function showBanner {
clear
echo -e "
      ____                __________     ______          ____    _ __
     / __ \___  ___ ___  / __/ __/ / ___/_  __/__  ___  / / /__ (_) /_
    / /_/ / _ \/ -_) _ \_\ \_\ \/ /_/___// / / _ \/ _ \/ /  '_// / __/
    \____/ .__/\__/_//_/___/___/____/   /_/  \___/\___/_/_/\_\/_/\__/
        /_/
"
}

function run {
    clear;
    $1 $2
    finished;
}

function finished {
    echo
    read -p "Готово. Нажмите [Enter], чтобы продолжить...";
}

while :
do
    showBanner
    echo -e "\n\t${underlined} Параметры подменю: ${def}\n"
    echo -e "\t1. $CREATESERT"
    echo -e "\t2. $CONVERSERT"
    echo -e "\n\t3. Проверять сертификаты локально."
    echo -e "\t4. Внешняя проверка сертификатов (s_client)"
    echo -e "\n\t5. Вывести информацию о сертификате."

    echo -e "\n\tq. Выйти."
    echo -n -e "\n\t Выбор: "

    read -n1 opt
    a=true;
    case $opt in
        1) # submenu: Create
            while :
            do
                showBanner
                echo -e "\n\t${underlined} Создать сертификаты: ${def}\n"
                echo -e "\t1. Самоподписанный сертификат SSL (key, csr, crt)"
                echo -e "\t2. Закрытый ключ и запрос на подпись сертификата (key, csr)"
                echo -e "\t3. PEM с ключом и всей цепочкой доверия"

                echo -e "\n\t0. Назад "
                echo -n -e "\n\t Выбор: "
                read -n1 opt;
                case $opt in

                    1) run "createSelfSignedCertificate";;
                    2) run "createCSRKey";;
                    3) run "createPEM";;

                    /q | q | 0)break;;
                    *) ;;

            esac
            done
            ;;

        2) # submenu: Convert
            while :
            do
                showBanner
                echo -e "\n\t${underlined} Преобразование сертификатов: ${def}\n"

                echo -e "\t1. PEM -> DER"
                echo -e "\t2. PEM -> P7B"
                echo -e "\t3. PEM -> PFX"
                echo -e "\t4. DER -> PEM"
                echo -e "\t5. P7B -> PEM"
                echo -e "\t6. P7B -> PFX"
                echo -e "\t7. PFX -> PEM"

                echo -e "\n\t0. Назад "
                echo -n -e "\n\t Выбор: "
                read -n1 opt;
                case $opt in

                    1) run "convertCertificate" "convertPEMtoDER";;
                    2) run "convertCertificate" "convertPEMtoP7B";;
                    3) run "convertCertificate" "convertPEMtoPFX";;
                    4) run "convertCertificate" "convertDERtoPEM";;
                    5) run "convertCertificate" "convertP7BtoPEM";;
                    6) run "convertCertificate" "convertP7BtoPFX";;
                    7) run "convertCertificate" "convertPFXtoPEM";;

                    /q | q | 0)break;;
                    *) ;;

            esac
            done
            ;;

        3) # submenu: Verify
            while :
            do
                showBanner
                echo -e "\n\t${underlined} Проверить сертификаты: ${def}\n"
                echo -e "\t1. CSR - это открытый ключ из закрытого ключа"
                echo -e "\t2. Подписанный сертификат - это открытый ключ от закрытого ключа"
                echo -e "\t3. Файл цепочки применяется к подписанному сертификату (полная цепочка ssl)"
                echo -e "\t4. Проверить срок действия сертификатов"

                echo -e "\n\t0. Назад "
                echo -n -e "\n\t Выбор: "
                read -n1 opt;
                case $opt in

                    1) run "verifyCSRPrivateKeyPair";;
                    2) run "verifyServerCertificatePrivateKeyPair";;
                    3) run "verifyChainFileAppliesToSignedCertificate";;
                    4) run "checkValidityOfCertificateFile";;

                    /q | q | 0)break;;
                    *) ;;

            esac
            done
            ;;

        4) # submenu: Test
            while :
            do
                showBanner
                echo -e "\n\t${underlined} Тестировать ssl-сервер (s_client): ${def}\n"
                echo -e "\t1. Подтверждение сертификата SSL "
                echo -e "\t2. Срок действия даты SSL-сервера "
                echo -e "\t3. Разрешенные протоколы "

                echo -e "\n\t0. Назад "
                echo -n -e "\n\t Выбор: "
                read -n1 opt;
                case $opt in

                    1) run "testSSLCertificateInstallation";;
                    2) run "checkValidityOfSSLServer";;
                    3) run "checkPermittedProtocols";;

                    /q | q | 0)break;;
                    *) ;;

            esac
            done
            ;;

        5) # submenu: Info
            while :
            do
                showBanner
                echo -e "\n\t${underlined} Вывод информации сертификата: ${def}\n"
                echo -e "\t1. Вывести данные из запроса на подпись сертификата "
                echo -e "\t2. Вывести данные из подписанного сертификата "

                echo -e "\n\t0. Назад "
                echo -n -e "\n\t Выбор: "
                read -n1 opt;
                case $opt in

                    1) run "output" "csr";;
                    2) run "output" "crt";;

                    /q | q | 0)break;;
                    *) ;;

            esac
            done
            ;;

        /q | q | 0) echo; break;;
        *) ;;

    esac
    done
