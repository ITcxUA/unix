#!/bin/bash

##=============================================
ASK="Спросить"
while true; do
	read -e -p "$ASK (y/n)? " rsn
  case $rsn in
    [Yy]* ) break;;
    [Nn]* ) echo "ВЫХОДИМ";exit;
  esac
done

echo "==== START ======"
##=============================================
