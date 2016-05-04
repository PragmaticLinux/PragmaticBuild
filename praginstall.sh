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



install_pragmaticLinux(){
	filesystem_setup
	cd $PRAGMATIC_SYSTEM_MOUNT
	tar -xf /PragmaticLinux*
	rm $PRAGMATIC_SYSTEM_MOUNT/etc/fstab
	genfstab /mnt >> /mnt/etc/fstab
	chroot_system
	configure_users
	setup_bootloader
	
	echo "Installation begins"
}

configure_system(){
	chroot ./ /bin/bash -c "mkinitcpio -p linux"
	
}



# DEVICE FIX  postfix BUG
setup_bootloader(){
	chroot ./ /bin/bash -c "grub-install $PRAGMATIC_SYSTEM_MOUNT"
	chroot ./ /bin/bash -c "grub-mkconfig -o /boot/grub/grub"
	
}

configure_users(){
	chroot ./ /bin/bash -c "passwd"
	echo "Create your username"
	read $username
	chroot ./ /bin/bash -c "useradd -m -g users -G wheel,storage,power -s /bin/bash  $username"
	
}

chroot_system(){
	mount -t proc proc proc/
	mount --rbind /sys sys/
	mount --rbind /dev dev/
	mount --rbind /run run/
	chroot ./
}

filesystem_setup(){
	mkfs.ext4 $PRAGMATIC_SYSTEM_PARTITION
	mkswap $SWAP_PARTITION
	mount $PRAGMATIC_SYSTEM_PARTITION
	swapon $SWAP_PARTITION
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
			PRAGMATIC_SYSTEM_PARTITION=PragmaticSystemPartition
			SWAP_PARTITION=SwapPartition
			install_pragmaticLinux
			break;;
        	[Nn]* ) set_partition;;
        	* ) echo "Please answer yes or no.";;
    	esac
done

