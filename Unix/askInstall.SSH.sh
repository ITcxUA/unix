#!/bin/bash

#======  SSH.ed25519.sh  =======#

function variable {
    # NKEY='id'
    # CKEY='mail@gmail.com'
	PKEY="";
	# TKEY=rsa;
	# TKEY=dsa;
	# TKEY=ecdsa;
    # TKEY=xmss;
	TKEY=ed25519;
	BKEY=2048;
	HOST=$(hostname -s);
	HOSTIP=$(hostname -i);
	DKEY=$HOME/.ssh/"$NKEY"_"$TKEY"

}

### ВВОДИВОДИМЫЕ ДАННЫЕ ###
#
  echo 'NAME ssh key:'; read NKEY
  echo 'Add Coment ssh key:'; read CKEY
# echo 'PASSWORD ssh key:'; read PKEY
# echo 'TIP sshkey(ed25519):'; reed TKEY
# echo 'BIT ssh key:'; reed BKEY
#
##########################

# func init
variable


###  -Проверка папки- ###
echo "## -Find folder: $HOME/.ssh "

	if [ -d $HOME/.ssh ]; then
		echo "Directory already exists"
else
	echo "NO EXISTS. Create $HOME/.ssh "
	echo
	mkdir $HOME/.ssh

fi
###############################

echo "#== Add sshkey $TKEY =#"
ssh-keygen -t "$TKEY" -b "$BKEY" -f $HOME/.ssh/"$NKEY"_"$TKEY" -C "$CKEY" -N "$PKEY"


ssh-copy-id -i "$DKEY".pub "$USER"@"$HOSTIP"
eval "$(ssh-agent -s)"
ssh-add "$DKEY"
# echo "# connect $HOSTIP #";
# ssh "$USER"@"$HOSTIP"
exit