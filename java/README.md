## Java for termux ( Only for Android < Oreo )

```
##===========================================
## Java в termux

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
## Start install
InstallPKG;
git clone https://github.com/numbnet/java.git;
# cp $HOME/java/openjdk/java $PREFIX/bin;
chmod +x $HOME/java/openjdk/bin/java;
sh installjava;
```

2. Now you can execute java
