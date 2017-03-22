#!/bin/bash
# Minibuild, a tiny build script for everyone
# Written by F4uzan with the help of others
# Credits to Michael S Corigliano (Mike Criggs) (michael.s.corigliano@gmail.com) for "Fuck Jack" build script
# Licensed under GPLv2, see LICENSE for more information

if [ ! -d minibuild ]; then
	echo
	echo Minibuild configuration folder cannot be found!
	echo Please properly install Minibuild using the installation script and then try again
	echo
	exit
fi
ROM_PREFIX_FILE=minibuild/rom
BUILD_TYPE_FILE=minibuild/build_type
CORES_FILE=minibuild/cores
NOJACK_FILE=minibuild/nojack

if [ -e $ROM_PREFIX_FILE ]; then
	ROM_PREFIX=$(cat $ROM_PREFIX_FILE)
else
	ROM_PREFIX=""
fi

if [ -e $BUILD_TYPE_FILE ]; then
	BUILD_TYPE=$(cat $BUILD_TYPE_FILE)
else
	BUILD_TYPE=""
fi

if [ -e $CORES_FILE ]; then
	CORES=$(cat $CORES_FILE)
else
	CORES=4
fi

if [ -e $NOJACK_FILE ]; then
	NOJACK=$(cat $NOJACK_FILE)
else
	NOJACK=""
fi

if [ $1 == "help" ]; then
	echo
	echo Minibuild Build Script
	echo ----------------------
	echo
	echo Usage:
	echo bash build.sh '<COMMAND> <PARAMETERS> <DEVICE>'
	echo
	echo Available commands:
	echo
	echo 'build		: Compiles ROM'
	echo 'help		: Open up this help page'
	echo 'config		: Create a new configuration for the script'
	echo
	echo
	echo Available parameters:
	echo
	echo '-clean		: Make a clean build before continuing'
	echo '-clean-cache	: Clears ccache'
	echo '-cm		: Use "make bacon" instead of "make otapackage" for compiling'
	echo "-uconfig	: Load parameters from configuration file"
	echo
elif [ $1 == "build" ]; then
	# Check for parameters
	while test $# -gt 0
	do
    		case "$2" in
        		-clean) clean=y
            		;;
        		-clean-cache) cleancache=y
            		;;
				-cm) cm=y
					;;
				-uconfig) uconfig=y
					;;
    		esac
		DEVICE="$@"
	shift
	done

	# Actually build now
	source build/envsetup.sh
	lunch "$ROM_PREFIX"_$DEVICE-$BUILD_TYPE

	if [[ $uconfig == "y" ]]; then
		echo Using predefined configuration
		clean=$(cat minibuild/clean)
		cleancache=$(cat minibuild/cleancache)
		cm=$(cat minibuild/cm)
	fi

	if [[ $NOJACK == "y" ]]; then
		echo Enabling fixes for Jack compilation
		export USE_NINJA=false
		rm -rf ~/.jack*
		export ANDROID_JACK_VM_ARGS="-Xmx4g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
		./prebuilts/sdk/tools/jack-admin kill-server
		./prebuilts/sdk/tools/jack-admin start-server
	fi

	echo Using $CORES cores for compilation

	if [[ $clean == "y" ]]; then
		echo Running clean build
		make clean
	fi

	if [[ $cleancache == "y" ]]; then
		echo Clearing CCACHE
		ccache -C
	fi

	if [[ $cm == "y" ]]; then
		echo Using Lineage compatible mode
		make bacon
	else
		echo Using AOSP compatible mode
		make -j$CORES otapackage
	fi
elif [ $1 == "config" ]; then
	bash minibuild/install.sh config
else
	echo
	echo Command not found: $1
	echo Type "bash build.sh help" for the list of commands
	echo
fi
