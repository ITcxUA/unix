#!/bin/bash

echo "*******  -select-  *******"
echo "**************************"
echo "  1) = Sel 1"
echo "  2) = Sel 2"
echo "  3) = Sel 3"
echo "  4) = Sel 4"
echo "  *) = EXIT               "
echo "**************************"


read n
case $n in
  1)# Sel 1 
echo " Select 1" | sleep 3
;;
  2)# Sel 2
echo " Select 2" | sleep 3
 ;;
  3)# Sel 3
echo " Select 3" | sleep 3
 ;;
  4)# Sel 4
echo " Select 4" | sleep 3
 ;;
  *)## 
  echo 'ERROR Select. Exit.....'
  sleep 5
  exit
 ;;
esac
