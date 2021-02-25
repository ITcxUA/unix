#!/bin/bash
function BACKUPMENU {
echo "*******  -select-  *******"
echo "**************************"
echo "  1) = Backup with RESTIC "
echo "  2) = RESTORE with RESTIC"
echo "  3) = BACKUP with TAR    "
echo "  4) = RESTORE with TAR   "
echo "  *) = EXIT               "
echo "**************************"
}

BACKUPMENU

read n
case $n in
  1)
function BACKUPRESTIC {
    
echo '## #################### ##'
echo '##  ==BACKUP= =RESTIC== ##'
echo '## #################### ##'
sleep 5

# Storage permission is granted:
termux-setup-storage

# Create Dir
# cd $HOME
# mkdir -p $HOME/storage/emulated
# ln -s /storage/emulated/0 $HOME/storage/emulated/0

# create dir Repo RESTIC
###########################
function VARIABLERESTIC {
TMPDIR=$PREFIX/tmp
XDG_CACHE_HOME=$HOME/.cache
XDG_TMP_HOME=$HOME/.tmp
RESTIC_CACHE_DIR=$PREFIX/var/cache
RESTIC_REPOSITORY=$HOME/storage/shared/Directory/restic-repo
 export TMPDIR=$PREFIX/tmp
 export XDG_CACHE_HOME=$HOME/.cache
 export XDG_TMP_HOME=$HOME/.tmp
 export RESTIC_CACHE_DIR=$PREFIX/var/cache
echo 'export TMPDIR=$PREFIX/tmp' >> ~/.bashrc
echo 'export XDG_CACHE_HOME=$HOME/.cache' >> ~/.bashrc
echo 'export XDG_TMP_HOME=$HOME/.tmp' >> ~/.bashrc
echo 'export RESTIC_CACHE_DIR=$PREFIX/var/cache' >> ~/.bashrc
}

###########################

RESTIC_REPOSITORY="$HOME/storage/shared/Directory/restic-repo"
if [[ ! -e $RESTIC_REPOSITORY ]];
	then
		echo "$RESTIC_REPOSITORY NOT exists, create dir and START FUNC VARIABLERESTIC"
		VARIABLERESTIC
		mkdir $RESTIC_REPOSITORY
			elif [[ ! -d $RESTIC_REPOSITORY ]];
	then
		echo "$RESTIC_REPOSITORY exists, but is not a dir" 1>&2
		# rm -rf $RESTIC_REPOSITORY
		# mkdir -p $RESTIC_REPOSITORY
fi


# mkdir -p $HOME/storage/shared/Directory/restic-repo

##== Restic is a utility for doing incremental backups. It can work with both local and remote backups. Backed up data is encrypted and de-duplicated. This package is not available by default. Install it with the following command:
# echo "name pkg:" & read PKG;

PKG=restic;
PKG2=tar;
PKG3=busybox;
RESTIC=`which $PKG 2> /dev/null`
TAR=`which $PKG2 2> /dev/null`
BUSYBOX=`which $PKG3 2> /dev/null`
if test "-$RESTIC-" = "--" || test "-$TAR-" = "--" || test "-$BUSYBOX-" = "--"
then
    echo "You must install $PKG $PKG2 $PKG3 "
    sleep 3
    pkg install $PKG $PKG2 $PKG3 -y
#  exit 1
else
   echo "$PKG $PKG2 $PKG3 is installed";

fi

# Notice: restic is for advanced users only. While it provides more features than tar, it is harder in use. Most people will use it in scripts rather than manually in the command line. Instructions here provided only as an example. environment variable permanently is put below statement in your script,

# if [[ ! -d "$VARNAME" ]]; then 
#    export VARNAME="$VARVALUE"
#    echo 'export "$VARNAME"="$VARVALUE"' >> ~/.bashrc
# fi


echo "#==  Backing up ==#"
sleep 5
#  restic -r /srv/restic-repo backup ~/work
# These steps will backup only sysroot (prefix) and not your home. The repository will be stored on shared storage.
##== Initialize local restic repository. You will be prompted for a password because encryption is enabled (no way to turn off). If the password is lost - your data will be locked forever.
echo "##  ====INIT====  ##"
restic init -r $RESTIC_REPOSITORY
sleep 5

##== Backing up sysroot ($PREFIX):
echo "##  ==Backup SYSROOT==  ##"
restic backup -r $RESTIC_REPOSITORY --tag termux $PREFIX

sleep
##== A tag is not necessary but will be useful in case if you decide to backup multiple directories into the same repository. For example, you can backup home directory in this way
echo "##== Backing up ( $HOME ): "
sleep 5
restic backup -r $RESTIC_REPOSITORY --tag termux-home $HOME

echo "#== END ==#"
sleep 5
exit
## * * * * * * * * * ##
}
    BACKUPRESTIC
    BACKUPMENU
 ;;
  2)
  function RESTORERESTIC {
echo '## * * * * * * * * * ##'
echo '#== Restoring ==#'
# Same as with tar-based backups, restoring of sysroot is tricky. Following steps are applicable only for local backups:

##== Make sure that restic is available install restic
#$ pkg install restic

##== Ensure that storage permission is granted:
#$ termux-setup-storage

##Copy restic binary to $HOME. We are going to erase sysroot.
#$ cp $PREFIX/bin/restic $HOME/restic

##== Erase sysroot. All packages will be deleted.
#$ rm -rf $PREFIX

##== Restore sysroot from latest snapshot:
#$ unset LD_PRELOAD
#$ $HOME/restic restore -r $RESTIC_REPOSITORY --tag termux --target / latest

##== If everything is done right, you should now have a Termux restored from the backup. Close your Termux application and open it again.
##== Tip: if you do not want to enter a restic password or specify repository each time, you can set environment variables "RESTIC_PASSWORD" and "RESTIC_REPOSITORY".
}
RESTORERESTIC
BACKUPMENU
 ;;
  3)
function BACKUPTermux {
## * * * * * * * * * ##
#== Backing up Termux ==#
## * * * * * * * * * ##

# On this page, you will find some methods of backing up and restoring your Termux installation. It is highly recommended to understand what commands listed here do before copy-pasting them. Misunderstanding the purpose of each step may irrecoverably damage your data, if that happened to you - do not complain.

## * * * * * * * * * ##
##  ==BACKUP==   ==TAR==  ##
## ####################
# Archiving sysroot and home directories is the simplest way to backup your data. You can install it using TAR.
#$ pkg install tar

#==    START     ==#
#== Backing up ==#

# In this example, a backup of both home and sysroot will be shown. The resulting archive will be stored on your shared storage (/sdcard) and compressed with gzip.
##== Ensure that storage permission is granted:
#$ termux-setup-storage

##== Go to Termux base directory:
#$ cd /data/data/com.termux/files

# 2.2 Create Dir
#$ mkdir -p /sdcard/Directory/termux-backup-tar

##== Backing up files:
#$ tar -zcvf /sdcard/Directory/termux-backup-tar/termux-backup.tar.gz home usr

# Backup should be finished without any error. There shouldn't be any permission denials unless the user abused root permissions. Warnings about sockets are okay.
# Warning: never store your backups in Termux private directories. Their paths may look like:
# /data/data/com.termux		# - private Termux directory on internal storage
# /sdcard/Android/data/com.termux		# - private Termux directory on shared storage
# /storage/XXXX-XXXX/Android/data/com.termux		# -private Termux directory on external storage, XXXX-XXXX is the UUID of your micro-sd card.
# ${HOME}/storage/external-1		# - alias for Termux private directory on your micro-sd.

# Once you clear Termux data from settings, these directories will be erased too. Unconditionally.

}
BACKUPTermux
BACKUPMENU
;;
  4)
  function RESTORETermux {
## * * * * * * * * * ##
#== Restoring ==#
## * * * * * * * * * ##

# Instructions for home directory and usr (sysroot or prefix) are separate, though if you did backup in the way shown above, these directories are stored in the same archive. There also will be assumed you have granted access to shared storage and your archive is stored at  /sdcard/Directory/termux-backup-tar/termux-backup.tar.gz  . By following these instructions all your Termux files will be overwritten with ones from back up.

#== Home directory ==#
##== Go to Termux base directory:
#$ cd /data/data/com.termux/files

##== Replace home directory with one from your backup:
#$rm -rf home
#$ tar -zxvf /sdcard/Directory/termux-backup-tar/termux-backup.tar.gz home

##== The home directory isn't runtime-critical, no additional steps like closing/re-opening Termux required.

#=== Sysroot (prefix) ===#

##== Go to Termux base directory:
#$ cd /data/data/com.termux/files

##== Copy busybox binary in the way shown here. You can't use any other archiver binary here as only busybox doesn't have dependencies which will gone in next step.
#$ pkg install busybox
#$ cp ./usr/bin/busybox ./tar

##== Erase sysroot. At this point, all packages will be deleted.
#$ rm -rf usr

##== Restore sysroot from backup:
#$ unset LD_PRELOAD
#$ ./tar -zxvf /sdcard/termux-backup.tar.gz usr

##== Now close Termux with the "exit" button from notification and open it again.
#$ exit
###########==    END     ## * * * * * * * * * ##
## * * * * * * * * * #########

  }
  RESTORETermux;
  BACKUPMENU
;;
  *)
  echo 'ERROR Select. Exit.....'
  sleep 5
  exit 1
 ;;
esac
