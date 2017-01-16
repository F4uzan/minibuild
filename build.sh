#!/bin/bash
# Minibuild, a tiny build script for everyone
# Written by F4uzan with the help of others
# Credits to Michael S Corigliano (Mike Criggs) (michael.s.corigliano@gmail.com) for "Fuck Jack" build script
# Licensed under GPLv2, see LICENSE for more information
#
# Usage:
# bash build.sh <COMMAND> <PARAMETERS> <DEVICE>
#
# Available commands:
#
# build		: Compiles ROM
# help		: Open up this help page
#
#
#
# Available parameters:
#
# -clean	: Make a clean build before continuing
# -clean-cache	: Clears ccache
# -cm		: Use "make bacon" instead of "make otapackage" for compiling
# -lastconfig	: Use last known configuration (device model, etc) and parameters

ROM = $(cat minibuild/rom)
BUILD_TYPE = $(cat minibuild/build_type)
NOJACK= $(cat minibuild/nojack)

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
	echo 'config		: Open or create a new configuration for the script'
	echo
	echo
	echo Available parameters:
	echo
	echo '-clean		: Make a clean build before continuing'
	echo '-clean-cache	: Clears ccache'
	echo '-cm		: Use "make bacon" instead of "make otapackage" for compiling'
	echo "-uconfig		: Load parameters from configuration file"
	echo
else
	# Check for parameters
	while test $# -gt 0
	do
    		case "$2" in
        		-clean) clean=true
            		;;
        		-clean-cache) cleancache=true
            		;;
			-cm) cm=true
			;;
			-uconfig) uconfig=true
			;;
    		esac
		DEVICE="$@"
	shift
	done

	# Actually build now
	source build/envsetup.sh
	echo lunch $ROM_$DEVICE-$BUILD_TYPE

	if [ $uconfig == true ]; then
		clean=$(cat minibuild/clean)
		cleancache=$(cat minibuild/cleancache)
		cm=$(cat minibuild/cm)
	fi

	if [ $NOJACK == true ]; then
		export USE_NINJA=false
		rm -rf ~/.jack*
		export ANDROID_JACK_VM_ARGS="-Xmx4g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
		./prebuilts/sdk/tools/jack-admin kill-server
		./prebuilts/sdk/tools/jack-admin start-server
	fi

	if [ $clean == true ]; then
		make clean
	fi

	if [ $cleancache == true ]; then
		ccache -C
	fi

	if [ $cm == true ]; then
		make bacon
	else
		make -j4 otapackage
	fi
fi