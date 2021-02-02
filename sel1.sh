#!/bin/bash
menu() { 
echo "**** -select- *****"; 
echo "#============ ≠≠≠ ============#"; 
echo " 1)operation 1";
echo " 2)operation 2"; 
echo " 3)operation 3"; 
echo " 4)operation 4" ; 
echo "#============ ≠≠≠ ============#";
}

##============ ≠≠≠ ============
menu 
read n 
case $n in
  1) echo "You chose Option $n";;
  2) echo "You chose Option $n";;
  3) echo "You chose Option $n";;
  4) echo "You chose Option $n";;
  *) echo "$n - ERROR. EXIT";sleep 3;
  exit;;
esac
