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


PRAGMATIC_SYSTEM_MOUNT="/mnt"
PRAGMATIC_SYSTEM_PARTITION=""
SWAP_PARTITION=""
DEVICE_ADDRESS=""
PROGRESS_COLOR="\e[32m \e[1m"
RESET_STYLE="\e[0m\e[39m"


install_pragmaticLinux(){
	echo -ne "{ $PROGRESS_COLOR #------------------------------------------------ $RESET_STYLE} (\e[36m2%$RESET_STYLE)\n"
	filesystem_setup
	echo -ne "{ $PROGRESS_COLOR ###---------------------------------------------- $RESET_STYLE} (\e[36m6%$RESET_STYLE)\n"
	cd $PRAGMATIC_SYSTEM_MOUNT
	tar -xf /PragmaticLinux*
	echo -ne "{ $PROGRESS_COLOR ###################################-------------- $RESET_STYLE} (\e[36m70%$RESET_STYLE)\n"
	rm $PRAGMATIC_SYSTEM_MOUNT/etc/fstab
	echo -ne "{ $PROGRESS_COLOR ######################################----------- $RESET_STYLE} (\e[36m76%$RESET_STYLE)\n"
	chroot_system
	configure_system
	echo -ne "{ $PROGRESS_COLOR #########################################-------- $RESET_STYLE} (\e[36m82%$RESET_STYLE)\n"
	configure_users
	echo -ne "{ $PROGRESS_COLOR #############################################---- $RESET_STYLE} (\e[36m90%$RESET_STYLE)\n"
	setup_bootloader
	echo -ne "{ $PROGRESS_COLOR ###############################################-- $RESET_STYLE} (\e[36m96%$RESET_STYLE)\n"
	echo -ne "{ $PROGRESS_COLOR ################################################# $RESET_STYLE} (\e[36m100%$RESET_STYLE)\n"
	echo "$PROGRESS_COLOR Installation completed system is going to reboot"
	reboot
}

configure_system(){
	chroot ./ /bin/bash -c "mkinitcpio -p linux"

}

setup_bootloader(){
	chroot ./ /bin/bash -c "grub-install /dev/$DEVICE_ADDRESS"
	chroot ./ /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"	
}

configure_users(){
	echo -e "\n\n\n\n ================================================== \n\n Set root password"
	chroot ./ /bin/bash -c "passwd"
	printf "Create your username:"; read username
	chroot ./ /bin/bash -c "useradd -m -g users -G wheel,storage,power -s /bin/bash  $username"
	chroot ./ /bin/bash -c "passwd $username"
	
}

chroot_system(){
	mount -t proc proc proc/
	mount --rbind /sys sys/
	mount --rbind /dev dev/
	mount --rbind /run run/
	chroot ./ /bin/bash -c "swapon $SWAP_PARTITION"
	chroot ./ /bin/bash -c "rm /etc/fstab"
	chroot ./ /bin/bash -c "genfstab -U -p / | grep \"swap\|ext4\"  >> /etc/fstab"
}

filesystem_setup(){
	mkfs.ext4 $PRAGMATIC_SYSTEM_PARTITION
	mkswap $SWAP_PARTITION
	mount $PRAGMATIC_SYSTEM_PARTITION $PRAGMATIC_SYSTEM_MOUNT
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
			PRAGMATIC_SYSTEM_PARTITION=$PragmaticSystemPartition
			SWAP_PARTITION=$SwapPartition
			temp=${PRAGMATIC_SYSTEM_PARTITION:5}
			DEVICE_ADDRESS="${temp//[[:digit:]]/}"
			install_pragmaticLinux
			break;;
        	[Nn]* ) set_partition;;
        	* ) echo "Please answer yes or no.";;
    	esac
done

