#!/bin/bash
# Minibuild configuration and installation script

dir=".";

if [ $1 == config ]; then
	dir="$PWD/minibuild";
elif [ $1 == configexp ]; then
	dir="$PWD/minibuild";
	configexp=true
fi

echo
echo Minibuild Setup
echo ---------------
echo
echo Make sure this file and the whole repository of Minibuild is cloned / placed in "minibuild" folder in the root of your ROM source.
echo
if [ $1 == config ]; then
	echo Removing previous build.sh
	rm ../build.sh
else
if [ -L ../build.sh ]; then
	echo build.sh already exist in ROM source, stopping installation.
	echo Please delete or rename existing build.sh in your ROM source.
	echo
	exit
fi
fi
echo Configuring Minibuild...
sleep 2
clear
echo Configure Minibuild
echo -------------------
if [ $configexp == "true" ]; then
	echo Experimental mode
fi
echo
if [ $configexp == "true" ]; then
	read -p "Target device for compilation	  	: " DEVICE
fi
read -p "ROM prefix (du, slim, omni, aokp)     : " ROM
read -p "Build type (userdebug, user, eng)     : " BUILD_TYPE
read -p "Number of CPU cores used at compilation : " CORES
echo
read -p "Automatically run 'make clean' when starting a build [Y/n]? " clean
read -p "Clear CCACHE when starting a build [y/N]? " cleancache
read -p "Use CM / LineageOS (or Lineage-based) compatibility mode [y/N]? " cm
read -p "EXPERIMENTAL: Enable out-of-memory workaround for Jack compiler [y/N]? " nojack
echo
echo Installing configuration...
echo
if [ $configexp == "true" ]; then
	if [ ! -d $dir/$DEVICE ]; then
		mkdir $dir/$DEVICE
	fi
	echo $ROM > $dir/$DEVICE/rom
	echo $BUILD_TYPE > $dir/$DEVICE/build_type
	echo $CORES > $dir/config/cores
	echo $nojack > $dir/config/nojack
	echo $clean > $dir/config/clean
	echo $cleancache > $dir/config/cleancache
	echo $cm > $dir/$DEVICE/cm
else
	echo $ROM > $dir/rom
	echo $BUILD_TYPE > $dir/build_type
	echo $CORES > $dir/cores
	echo $nojack > $dir/nojack
	echo $clean > $dir/clean
	echo $cleancache > $dir/cleancache
	echo $cm > $dir/cm
fi
if [ $1 == config ]; then
	ln -s $dir/build.sh ../build.sh
elif [ $1 == config ]; then
	ln -s $dir/build.sh .../build.sh
else
	ln -s $PWD/build.sh ../build.sh
fi
sleep 2
echo Installation done!
echo