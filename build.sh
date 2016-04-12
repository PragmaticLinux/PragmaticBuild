#!/bin/bash
# Author: Alban Mulaki

set -e -u

DISTRO=PragmaticLinux
TYPE=FULL
BACKUP_DIR="/backup"
VERSION="v0.6"
COMPRESSION_FORMAT=".tar.gz"

arch=$(uname -m)
iso_name=$DISTRO-$VERSION-${arch}
iso_label="$DISTRO-$VERSION-${arch}"
iso_version=$(date +%Y.%m.%d)
install_dir=arch
work_dir=work
out_dir=output


# run make_* function everytime the compiler exectue.
run_once() {
    $1
    touch ${work_dir}/build.${1}_${arch}
}

# Base installation (airootfs)
make_basefs() {
    mkarchiso -v -w "${work_dir}" -D "${install_dir}" init
}

# Copy mkinitcpio archiso hooks and build initramfs (airootfs)
make_setup_mkinitcpio() {
    mkdir -p ${work_dir}/airootfs/etc/initcpio/hooks
    mkdir -p ${work_dir}/airootfs/etc/initcpio/install
    cp /usr/lib/initcpio/hooks/archiso ${work_dir}/airootfs/etc/initcpio/hooks
    cp /usr/lib/initcpio/install/archiso ${work_dir}/airootfs/etc/initcpio/install
    cp ./mkinitcpio.conf ${work_dir}/airootfs/etc/mkinitcpio-archiso.conf
    mkarchiso -v -w "${work_dir}" -D "${install_dir}" -r 'mkinitcpio -c /etc/mkinitcpio-archiso.conf -k /boot/vmlinuz-linux -g /boot/archiso.img' run
}

# Prepare ${install_dir}/boot/
make_boot() {
    mkdir -p ${work_dir}/iso/${install_dir}/boot/${arch}
    cp ${work_dir}/airootfs/boot/archiso.img ${work_dir}/iso/${install_dir}/boot/${arch}/archiso.img
    cp ${work_dir}/airootfs/boot/vmlinuz-linux ${work_dir}/iso/${install_dir}/boot/${arch}/vmlinuz
}

# Prepare /${install_dir}/boot/syslinux
make_syslinux() {
    mkdir -p ${work_dir}/iso/${install_dir}/boot/syslinux
    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g;
         s|%ARCH%|${arch}|g" ./syslinux/syslinux.cfg > ${work_dir}/iso/${install_dir}/boot/syslinux/syslinux.cfg
    cp ${work_dir}/airootfs/usr/lib/syslinux/bios/ldlinux.c32 ${work_dir}/iso/${install_dir}/boot/syslinux/
    cp ${work_dir}/airootfs/usr/lib/syslinux/bios/menu.c32 ${work_dir}/iso/${install_dir}/boot/syslinux/
    cp ${work_dir}/airootfs/usr/lib/syslinux/bios/libutil.c32 ${work_dir}/iso/${install_dir}/boot/syslinux/
}


# Prepare /isolinux
make_isolinux() {
    mkdir -p ${work_dir}/iso/isolinux
    sed "s|%INSTALL_DIR%|${install_dir}|g" ./isolinux/isolinux.cfg > ${work_dir}/iso/isolinux/isolinux.cfg
    cp ${work_dir}/airootfs/usr/lib/syslinux/bios/isolinux.bin ${work_dir}/iso/isolinux/
    cp ${work_dir}/airootfs/usr/lib/syslinux/bios/isohdpfx.bin ${work_dir}/iso/isolinux/
    cp ${work_dir}/airootfs/usr/lib/syslinux/bios/ldlinux.c32 ${work_dir}/iso/isolinux/
}

# Build airootfs filesystem image
make_prepare() {
    mkarchiso -v -w "${work_dir}" -D "${install_dir}" prepare
}

# Build ISO
make_iso() {
    mkarchiso -v -w "${work_dir}" -D "${install_dir}" -L "${iso_label}" -o "/srv/http" iso "$iso_label.iso"
}

#run_once make_basefs
#run_once make_setup_mkinitcpio
#run_once make_boot

#Rebuild Bootloader
run_once make_syslinux	
run_once make_isolinux

#run_once make_prepare

#Rebuild Bootloader
run_once make_iso
