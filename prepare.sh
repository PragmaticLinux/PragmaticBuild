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

DISTRO=PragmaticLinuxDeveloper
TYPE=FULL
BACKUP_DIR="/root/pragmaticbuild/backup"
VERSION="v0.6"
COMPRESSION_FORMAT=".tar.gz"
CURRENT_SCRIPT_DIR=$(pwd)
echo "Current Directory script: "$CURRENT_SCRIPT_DIR
echo 'Distro: '$DISTRO
echo 'Verson Detail: '$VERSION' '$TYPE
echo 'Compression Format Type: '$COMPRESSION_FORMAT

read -p "Are you sure you want to continue with those specific ?" -n 1 -r
if[[ $REPLY =~^[Yy]$ ]] then

echo "Removing old backup"
rm -R ./backup/*


echo "Preparing the environment for the compile"
echo -en "[#                                                                                                   ] 1%\r"
rm -Rf $BACKUP_DIR
mkdir $BACKUP_DIR
echo -en "[##                                                                                                  ] 2%\r"

rm -R "/var/lib/pacman/local/*"
rm -R "/var/lib/pacman/sync/*"
rm -R "/var/cache/pacman/pkg/*"
rm -R "/var/log/*"
rm -R "/var/log/httpd/*"
rm -R "/var/log/Xorg.*"
rm -R "/var/log/VBox*"
rm -R "/var/log/pacman.log"


echo -en "[#####                                                                                               ] 5%\r"
rsync -aXX --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found/*","/backup/","/root/pragmaticbuild/","/var/log/httpd/*","/var/cache/pacman/pkg/*","/root/.bash_histroy","/root/.mysql_histroy","/root/tools/","/root/ToolsBack/"} /* $BACKUP_DIR

echo -en "[###########################################################################                         ] 65%\r"
cd ./backup
rm -R root/.*
cp -R etc/skel root/
tar -zcvpf $CURRENT_SCRIPT_DIR"/"$DISTRO-$TYPE-$VERSION$COMPRESSION_FORMAT .

echo -en "[####################################################################################################] 100%\r"


fi
