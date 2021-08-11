#!/bin/bash

##============ ≠≠≠ ============
TITLE='Backing up Termux'
##============ ≠≠≠ ============


StoragePerm() {
	termux-setup-storage		# Storage permission is granted:
}

##============ ≠≠≠ ============
## create dir Repo RESTIC
VarRESTIC() {
	RESTIC_REPOSITORY=$HOME/storage/shared/Directory/restic-repo

	TMPDIR=$PREFIX/tmp
	XDG_CACHE_HOME=$HOME/.cache
	XDG_TMP_HOME=$HOME/.tmp
	RESTIC_CACHE_DIR=$PREFIX/var/cache
	
	export TMPDIR=$PREFIX/tmp
	export XDG_CACHE_HOME=$HOME/.cache
	export XDG_TMP_HOME=$HOME/.tmp
	export RESTIC_CACHE_DIR=$PREFIX/var/cache
	
	echo 'export TMPDIR=$PREFIX/tmp' >> ~/.bashrc
	echo 'export XDG_CACHE_HOME=$HOME/.cache' >> ~/.bashrc
	echo 'export XDG_TMP_HOME=$HOME/.tmp' >> ~/.bashrc
	echo 'export RESTIC_CACHE_DIR=$PREFIX/var/cache' >> ~/.bashrc
}

##============ ≠≠≠ ============
## Create Directory
ResticRepo() {

	if [[ ! -e $RESTIC_REPOSITORY ]];
		then
			echo "$RESTIC_REPOSITORY NOT exists. Now create dir"
			mkdir $RESTIC_REPOSITORY | VarRESTIC
		elif [[ ! -d $RESTIC_REPOSITORY ]];
			then
			echo "$RESTIC_REPOSITORY exists, but is not a dir!!!" 1>&2
			echo "======== dir ========"
			# rm -rf $RESTIC_REPOSITORY
			# mkdir -p $RESTIC_REPOSITORY

	fi
}

##============ ≠≠≠ ============
## instsall Restic
InstallRESTIC() {
	PKG=restic;
	PKG1=tar busybox;
	RESTIC=`which restic 2> /dev/null`
	TAR=`which tar 2> /dev/null`
	BUSYBOX=`which busybox 2> /dev/null`

	if test "-$RESTIC-" = "--" || test "-$BUSYBOX-" = "--" || test "-$TAR-" = "--"
	then
		echo "You must install $PKG $PKG1"
		while true; do
		read -e -p "Install $PKG $PKG1 (y/n)? " rsn
		  case $rsn in
			[Yy]* ) pkg install $PKG $PKG1 -y;;
			[Nn]* ) exit;
		  esac
		done
	else
	   echo "$PKG $PKG2 is installed";

	fi

}

##============ ≠≠≠ ============
## Backing up
StartBackup() {
	echo '''
	## ==================================== ##
	## ==         BACKUP RESTIC          == ##
	## ==================================== ##
	'''     $$$@@@###
	
	VarRESTIC
	StoragePerm
	ResticRepo
	InstallRESTIC
	
	## START Initialize local restic repository
	restic init -r $RESTIC_REPOSITORY

	## Backing up sysroot ( $PREFIX ):
	echo "============ Backing ( $PREFIX )  ============" | sleep 3
	restic backup -r $RESTIC_REPOSITORY --tag termux $PREFIX

	## Backing up sysroot ( $HOME ):
	echo "============ Backing ( $HOME )  ============" | sleep 3
	restic backup -r $RESTIC_REPOSITORY --tag termux-home $HOME
}

##============ ≠≠≠ ============
## Restoring Termux with Restic
StartRestoring() {
	echo '## ==================================== ##'
	echo '## ==       Restoring RESTIC         == ##'
	echo '## ==================================== ##'
	VarRESTIC
	InstallRESTIC

	## Copy restic binary to $HOME. We are going to erase sysroot.
	mkdir -p $HOME/restic
	#tar czvf $HOME/restic/UsrBinRestic.tar.gz $PREFIX/bin/restic
	( cd $PREFIX/bin/restic; tar cf - . ) | ( cd $HOME/restic; tar xf - )


	## Erase sysroot. All packages will be deleted.
	rm -rf $PREFIX

	## Restore sysroot from latest snapshot:
	unset LD_PRELOAD
	$HOME/restic restore -r $RESTIC_REPOSITORY --tag termux --target / latest
}

##============ ≠≠≠ ============
BACKUPTermuxTAR() {

	echo '## ==================================== ##'
	echo '## ==         BACKUP TAR             == ##'
	echo '## ==================================== ##'

# Archiving sysroot and home directories is the simplest way to backup your data. You can install it using TAR.
pkg install tar -y

# In this example, a backup of both home and sysroot will be shown. 
# The resulting archive will be stored on your shared storage (/sdcard) 
# and compressed with gzip.

## Go to Termux base directory:
cd ~/../

##============ ≠≠≠ ============
#  Create Directory
TarREPO() {
	BACKUP_TARFILE="termux-backup.tar.gz"
	BACKUP_REPODIR="~/storage/shared/Directory/termux-backup-tar"
	BACKUPTARREPO="$BACKUP_REPODIR/$BACKUP_TARFILE"
	
	if [[ ! -e $BACKUP_REPODIR ]];
		then
			echo "$BACKUP_REPODIR NOT exists. Now create dir"
			mkdir -p $BACKUP_REPODIR;
				elif [[ ! -d $BACKUP_REPODIR ]];
			then
				echo "$BACKUP_REPODIR exists, but is not a dir!!!" 1>&2
				echo "======== dir ========"

	fi
}

TarREPO

## Backing up files:
tar -zcvf $BACKUPTARREPO home usr;

# Backup should be finished without any error. There shouldn't be any permission denials unless the user abused root permissions. Warnings about sockets are okay.
# !WARNING!: never store your backups in Termux private directories. Their paths may look like:

# /data/data/com.termux								# - private Termux directory on internal storage
# /sdcard/Android/data/com.termux					# - private Termux directory on shared storage
# /storage/XXXX-XXXX/Android/data/com.termux		# -private Termux directory on external storage, XXXX-XXXX is the UUID of your micro-sd card.
# ${HOME}/storage/external-1						# - alias for Termux private directory on your micro-sd.

# Once you clear Termux data from settings, these
# directories will be erased too. Unconditionally.
}



############ ≠≠≠ ############
RESTORETermux() {

	echo '## ==================================== ##'
	echo '## ==         Restoring TAR          == ##'
	echo '## ==================================== ##'

	# Instructions for home directory and usr (sysroot or prefix) 
	# are separate, though if you did backup in the way shown above,
	# these directories are stored in the same archive. 
	# There also will be assumed you have granted access to shared 
	# storage and your archive is stored at  
	# /sdcard/Directory/termux-backup-tar/termux-backup.tar.gz  .
	# By following these instructions all your Termux files will 
	# be overwritten with ones from back up.

	#== Home directory ==#
	## Go to Termux base directory:
	cd ~/../

	## Replace home directory with one from your backup:
	rm -rf home
	tar -zxvf $BACKUPTARREPO home

	## The home directory isn't runtime-critical, no additional steps like closing/re-opening Termux required.


echo "#=== Sysroot (prefix) ===#"

## Go to Termux base directory:
cd ~/../

## Copy busybox binary in the way shown here. You can't use any other archiver binary here as only busybox doesn't have dependencies which will gone in next step.
pkg install busybox -y
cp ./usr/bin/busybox ./tar

## Erase sysroot. At this point, all packages will be deleted.
rm -rf usr

## Restore sysroot from backup:
unset LD_PRELOAD
tar -zxvf $BACKUPTARREPO usr

## Now close Termux with the "exit" button from notification and open it again.
exit
}

MENU="
echo "*******  -select-  *******"
echo "**************************"
echo "  1) Backing up Termux - RESTIC"
echo "  2) Restoring Termux  - RESTIC"
echo "  3) Backing up Termux    - TAR"
echo "  4) Restoring Termux     - TAR"
echo "  *) EXIT                      "
echo "**************************"
"

read n
case $n in
  1)# Backing up Termux - RESTIC
echo "Backing up Termux - RESTIC" | sleep 3
StartBackup
;;
  2)# Restoring Termux  - RESTIC
echo "Restoring Termux  - RESTIC" | sleep 3
StartRestoring
 ;;
  3)# Backing up Termux    - TAR
echo "Backing up Termux    - TAR" | sleep 3
BACKUPTermuxTAR
 ;;
  4)# Restoring Termux     - TAR
echo "Restoring Termux     - TAR" | sleep 3
RESTORETermux
 ;;
  *)## EXIT
  echo 'Select is ERROR. Scripts Exit.....' |  sleep 3
  exit
 ;;
esac

