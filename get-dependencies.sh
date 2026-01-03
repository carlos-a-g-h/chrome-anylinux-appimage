#!/bin/sh

set -eux

ARCH=$(uname -m)

URL_RPM="$(sed -n 1p latest_version.txt)"
URL_GPG="$(sed -n 2p latest_version.txt)"
URL_SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

echo "Downloading scripts..."
echo "----------------------"

dnf update -y

dnf in -y wget xorg-x11-server-Xvfb patchelf binutils zstd fastfetch zsync strace

FILE_RPM=$(basename "${URL_RPM:7}")
if ! [ -f $FILE_RPM ]
then
	wget "$URL_RPM" -O "$FILE_RPM"
fi

FILE_GPG=$(basename "${URL_GPG:7}")
if ! [ -f $FILE_GPG ]
then
	wget "$URL_GPG" -O "$FILE_GPG"
fi

FILE_SHARUN=$(basename "${URL_SHARUN:7}")
if ! [ -f $FILE_SHARUN ]
then
	wget "$URL_SHARUN" -O "$FILE_SHARUN"
	chmod +x "$FILE_SHARUN"
fi

echo "Installing package..."
echo "---------------------"

rpm --import "$FILE_GPG"

rpm -K "$FILE_RPM"

dnf in -y $(realpath -e "$FILE_RPM")
