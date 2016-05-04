#!/bin/bash
# Title		: pragmatic-dev.sh
# Description	: Install Frameworks for web devepolment platform
# Author	: Alban Mulaki <amulaki@pragmaticlinux.org> or <alban.mulaki@gmail.com>
# Date		: 14 April 2016
# Usage		: sh pragmatic-dev.sh or pragmatic-dev
# Copyright	: Alban Mulaki & PragmaticLinux
# Website	: www.pragmaticlinux.org
# Author Website: www.pragmaticlinux.org/AlbanMulaki
#
# @pragmaticLinux
#========================================================================================

echo " _____                                 _   _        _      _                  "
echo "|  __ \                               | | (_)      | |    (_)                 "
echo "| |__) | __ __ _  __ _ _ __ ___   __ _| |_ _  ___  | |     _ _ __  _   ___  __"
echo "|  ___/ '__/ _\` |/ _\` | '_ \` _ \ / _\` | __| |/ __| | |    | | '_ \| | | \ \/ /"
echo "| |   | | | (_| | (_| | | | | | | (_| | |_| | (__  | |____| | | | | |_| |>  < "
echo "|_|   |_|  \__,_|\__, |_| |_| |_|\__,_|\__|_|\___| |______|_|_| |_|\__,_/_/\_\\"
echo "                  __/ |                                                       "
echo "                 |___/                                                        "

install_pragmaticLinux(){
	echo "Installation begins"
}


set_partition(){
	echo "Select which partition do you want to install PragmaticLinux System by writing (example: \" /dev/sda1 \")"
	read PragmaticSystemPartition
	echo "Select which partition do you want to make as SWAP Partition (example: \" /dev/sda2 \")"
	read SwapPartition
	echo ""
	echo "  ______________________________________________   "
	echo " /                                               "
	echo "/  $PragmaticSystemPartition  - Pragmatic System  "
	echo "\  $SwapPartition  - Swap Partition     "
	echo " \______________________________________________ "
	echo "                                                   "
}


cfdisk
lsblk
echo "-------------------------------"
set_partition
confirm_partition=false
while [ "$confirm_partition" = false ]; do
	read -p "Do you wish to install Pragmatic Linux as you see partition (Yy,Nn)?" yn
    	case $yn in
     		[Yy]* ) confirm_partition=""
			install_pragmaticLinux break;;
        	[Nn]* ) set_partition;;
        	* ) echo "Please answer yes or no.";;
    	esac
done

#arch-chroot ./work/airootfs /bin/bash -c uname -a
