#!/bin/bash

firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=23/tcp --permanent
firewall-cmd --zone=public --add-port=25/tcp --permanent
firewall-cmd --zone=public --add-port=53/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=110/tcp --permanent
firewall-cmd --zone=public --add-port=115/tcp --permanent
firewall-cmd --zone=public --add-port=135/tcp --permanent
firewall-cmd --zone=public --add-port=139/tcp --permanent
firewall-cmd --zone=public --add-port=143/tcp --permanent
firewall-cmd --zone=public --add-port=194/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=445/tcp --permanent
firewall-cmd --zone=public --add-port=1433/tcp --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=3389/tcp --permanent
firewall-cmd --zone=public --add-port=5632/tcp --permanent
firewall-cmd --zone=public --add-port=5900/tcp --permanent
firewall-cmd --zone=public --add-port=8096/tcp --permanent
firewall-cmd --zone=public --add-port=25565/tcp --permanent
firewall-cmd --zone=public --add-port=1900/tcp --permanent
firewall-cmd --zone=public --add-port=5353/tcp --permanent
firewall-cmd --zone=public --add-port=32400/tcp --permanent
firewall-cmd --zone=public --add-port=32410/tcp --permanent
firewall-cmd --zone=public --add-port=32412/tcp --permanent
firewall-cmd --zone=public --add-port=32413/tcp --permanent
firewall-cmd --zone=public --add-port=32414/tcp --permanent
firewall-cmd --zone=public --add-port=32469/tcp --permanent
firewall-cmd --reload
exit