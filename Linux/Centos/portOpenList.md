common ports
21 FTP				|	open
22 SSH				|	open
23 TELNET			|	open
25 SMTP				|	closed
53 DNS				|	closed
80 HTTP				|	open
110 POP3			|	closed
115 SFTP			|	closed
135 RPC				|	closed
139 NetBIOS			|	closed
143 IMAP			|	closed
194 IRC				|	open
443 SSL				|	open
445 SMB				|	open
1433 MSSQL			|	open
3306 MySQL			|	open
3389 RDP			|	open	
5632 PCAnywhere		|	closed
5900 VNC			|	open
25565 Minecraft		|	closed

firewall-cmd --zone=public --add-port=


21 
22
23 TELNET
25 SMTP
53 DNS
80 HTTP
110 POP3
115 SFTP
135 RPC
139 NetBIOS
143 IMAP
194 IRC
443 SSL
445 SMB
1433 MSSQL
3306 MySQL
3389 RDP
5632 PCAnywhere
5900 VNC
25565 Minecraft
