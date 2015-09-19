#!/bin/bash

#
<<<<<<< HEAD
# Insatll pragmatic Linux script



BOOT_MOUNT=""
HOSTNAME="pragmatic"
TIME_ZONE="Europe/Skopje"

#DEFAULT EDITOR 
select_editor(){
	echo "Setting up default editor nano"
	export EDITOR="nano"
	return true
}

#SELECT DEVICE
function select_device(){
    gparted
	devices=$(lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd')
	device_list=(${devices// /})
	echo "List of partititon available: "
	echo "========================================="
	lsblk
	echo "========================================="
	echo "Select which device do you want to install: "
	read sel_dev
	BOOT_MOUNT=$sel_dev
	mount $sel_dev /mnt
}

function internet_connection(){
	systemctl start dhcpcd.service
}



#INSTALL BASE SYSTEM 
function install_base_system(){
	rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/installer","/installer/*"} /* /mnt/
	genfstab -p /mnt >> /mnt/etc/fstab
	arch-chroot /mnt /bin/bash -c "echo $HOSTNAME > /etc/hostname"
	arch-chroot /mnt /bin/bash -c "echo $HOSTNAME > /etc/hostname"
	arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime"
	arch-chroot /mnt /bin/bash -c "locale-gen"
	arch-chroot /mnt /bin/bash -c "echo LANG=en_US.UTF-8 > /etc/locale.conf"
	arch-chroot /mnt /bin/bash -c "mkinitcpio -p linux"
	arch-chroot /mnt /bin/bash -c "grub-install --recheck ${BOOT_MOUNT::-1}"
	arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
}
function configure_system(){
	arch-chroot /mnt /bin/bash -c "hwclock --systohc --utc"
}
function update(){
	reflector >> /etc/pacman.d/mirrorlist
	arch-chroot /mnt /bin/bash -c "pacman -Syyu"
	arch-chroot /mnt /bin/bash -c "pacman-key --populate"
	
}

function cleanup(){
	find "/mnt/var/lib/pacman" -maxdepth 1 -type f -delete
	find "/mnt/var/lib/pacman/sync" -maxdepth 1 -type f -delete
	find "/mnt/var/cache/pacman/pkg" -maxdepth 1 -type f -delete
	find "/mnt/var/log" -maxdepth 1 -type f -delete
	find "/mnt/var/tmp" -maxdepth 1 -type f -deletefind "${work_dir}" \( -name "*.pacnew" -o -name "*.pacsave" -o -name "*.pacorig" \) -delete
    _msg_info "Clean up Done!"
}

select_device
internet_connection
install_base_system
configure_system
update
cleanup

>>>>>>> a31642133d4db264a6f682be699def959ef2f839
