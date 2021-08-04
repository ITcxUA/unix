#!/bin/bash

## "Создание сертификата";

###==============================
## Var
#NAMESERT='server'
BITSERT='2048'
echo 'Enter sert name: ' && read NAMESERT
mkdir -p $HOME/.csr && cd $HOME/.csr



##==============================
DODONE="## Генерация CSR  сертификата"
while true; do
read -e -p "$DODONE (y/n)? " rsn
  case $rsn in
    [Yy]* ) break;;
    [Nn]* ) exit;
  esac
done
 
echo "CREATE SERTIFICATE START"
sleep 5

openssl genrsa -des3 -out $NAMESERT.key $BITSERT
openssl req -new -key $NAMESERT.key -out $NAMESERT.csr


##==============================
DODONE2="Создать CRT сертификат "

while true; do
read -e -p "$DODONE2 (y/n)? " rsn
  case $rsn in
    [Yy]* ) break;;
    [Nn]* ) exit ;;
  esac
done
openssl x509 -req -days 730 -in $NAMESERT.csr -signkey $NAMESERT.key -out $NAMESERT.crt



##=================================
DODONE3="## Удаление секретной фразы-пароля из приватного ключа"

while true; do
read -e -p "$DODONE3 (y/n)? " rsn
  case $rsn in
    [Yy]* ) break;;
    [Nn]* ) exit ;;
  esac
done
mv -r $NAMESERT.pem $NAMESERT_.pem;
openssl rsa -in $NAMESERT_.pem -out $NAMESERT.pem


## ===================================
DODONE4="## Download OpenSSL Toolkit ver.1.1.0 or see below one-liner to download, extract, launch:"

while true; do
read -e -p "$DODONE4 (y/n)? " rsn
  case $rsn in
    [Yy]* ) break;;
    [Nn]* ) exit;
  esac
done

echo "Download openssl-toolkit-1.1.0.zip or see below one-liner to download, extract, launch:";
sleep
cd $HOME;


echo https://github.com/tdharris/openssl-toolkit/releases/download/1.1.0/openssl-toolkit-1.1.0.zip \
| cp -r $HOME/openssl-toolkit-1.1.0.zip $HOME/git \
| xargs wget -qO- -O tmp.zip && unzip -o tmp.zip && rm tmp.zip && ./openssl-toolkit/openssl-toolkit.sh

exit
