#!/data/data/com.termux/files/usr/bin/sh

##===========================================
## Java в termux

##===========================================
InstallPKG() {
apt update && apt upgrade
  IPKG=git;
	PKG=$IPKG;
	GIT='which git 2> /dev/null'

	if test "-$GIT-" = "--"
	then
		echo "You must install $PKG"
while true; do
read -e -p "install $PKG TO YOU Device (y/n)? " rsn
	case $rsn in
		[Yy]* ) apt install $PKG -y;;
		[Nn]* ) break;
	esac
done
	else
	   echo "$PKG is installed";

	fi

};

##===========================================

LoadJDK() {
	print_status() {
		printf "[*] ${1}...\n"
	}

	set_arch() {
		case "$(uname -m)" in
			aarch64|armv8l)
				ARCH=aarch64
				;;
			armv7l|arm)
				ARCH=arm
				;;
			*)
				printf "[!] arch not supported yet\n"
				exit 1
				;;
		esac
	}

	get_tar() {
		wget -c https://github.com/numbnet/java/releases/download/v8/jdk8_${ARCH}.tar.gz -O jdk8_$ARCH.tar.gz
		tar -xf jdk8_$ARCH.tar.gz -C $PREFIX/share 
		chmod +x $PREFIX/share/bin/*
		mv $PREFIX/share/bin/* $PREFIX/bin
	}

	cleanup() {
		rm -f jdk8_${ARCH}.tar.gz
		rm -rf $PREFIX/share/bin
	}

	print_status "getting system info"
	set_arch
	print_status "getting tar file and setting all things"
	get_tar
	print_status "cleaning up"
}


##===========================================
## Start install
InstallPKG;
git clone https://github.com/numbnet/java.git;
cp $HOME/java/openjdk/java $PREFIX/bin;
chmod +x $HOME/java/openjdk/bin/java;
chmod +x $PREFIX/bin/java;

## sh installjava;
LoadJDK;
