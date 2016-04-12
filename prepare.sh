#!/bin/bash
#Author: Alban Mulaki
#@2016

echo " _____                                 _   _        _      _                  "
echo "|  __ \                               | | (_)      | |    (_)                 "
echo "| |__) | __ __ _  __ _ _ __ ___   __ _| |_ _  ___  | |     _ _ __  _   ___  __"
echo "|  ___/ '__/ _\` |/ _\` | '_ \` _ \ / _\` | __| |/ __| | |    | | '_ \| | | \ \/ /"
echo "| |   | | | (_| | (_| | | | | | | (_| | |_| | (__  | |____| | | | | |_| |>  < "
echo "|_|   |_|  \__,_|\__, |_| |_| |_|\__,_|\__|_|\___| |______|_|_| |_|\__,_/_/\_\\"
echo "                  __/ |                                                       "
echo "                 |___/                                                        "

DISTRO=PragmaticLinuxDeveloper
TYPE=FULL
BACKUP_DIR="/backup"
VERSION="v0.6"
COMPRESSION_FORMAT=".tar.gz"

echo 'Distro: $DISTRO'
echo 'Verson Detail: $VERSION $TYPE'
echo 'Compression Format Type: $COMPRESSION_FORMAT'

read -p "Are you sure you want to continue with those specific ?" -n 1 -r
if[[ $REPLY =~^[Yy]$ ]] then

echo "Preparing the environment for the compile"
#echo -en "[####################################################################################################] 1%\r"
echo -en "[#                                                                                                   ] 1%\r"
rm -Rf $BACKUP_DIR
mkdir $BACKUP_DIR
echo -en "[##                                                                                                  ] 2%\r"

find "/mnt/var/lib/pacman" -maxdepth 1 -type f -delete
find "/mnt/var/lib/pacman/sync" -maxdepth 1 -type f -delete
find "/mnt/var/cache/pacman/pkg" -maxdepth 1 -type f -delete
find "/mnt/var/log" -maxdepth 1 -type f -delete

echo -en "[#####                                                                                               ] 5%\r"
rsync -aXXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found/*","/backup/*","/root/PragmaticBuild/*","/var/log/httpd/*","/var/cache/pacman/pkg/*","/root/.bash_histroy","/root/.mysql_histroy"} /* $BACKUP_DIR/

echo -en "[###########################################################################                         ] 65%\r"
tar --xattrs -czpf /root/PragmaticBuild/$DISTRO-$TYPE-$VERSION-$COMPRESSION_FORMAT $BACKUP_DIR/*

echo -en "[####################################################################################################] 100%\r"


fi
