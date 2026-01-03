#!/bin/sh

set -eu

ARCH="$(uname -m)"
VERSION="v$(sed -n 1p version.txt)"

UBID="$1"
UBID_SHORT="${UBID:0:8}"

NAME="GoogleChrome"
APPIMAGE_STEM="$NAME"_"$VERSION"_"$UBID_SHORT"_anylinux_"$ARCH"
export ARCH VERSION
export OUTPATH=./dist
#export ADD_HOOKS="self-updater.bg.hook"
#export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="/opt/google/chrome/product_logo_256.png"
export OUTNAME="$APPIMAGE_STEM".AppImage
export DESKTOP="/usr/share/applications/google-chrome.desktop"

export DEPLOY_LOCALE=1
export DEPLOY_OPENGL=0
export DEPLOY_VULKAN=0
export DEPLOY_GEGL=0
export DEPLOY_PULSE=1
export DEPLOY_PIPEWIRE=0
export DEPLOY_GTK=0
export DEPLOY_QT=0
export DEPLOY_SDL=0
export DEPLOY_GLYCIN=0

mkdir -p AppDir/bin

cp -va /opt/google/chrome/* AppDir/bin/

cat "$DESKTOP" | sed -e 's|google-chrome-stable|google-chrome-stable --no-sandbox|' -e 's|Name=Google Chrome|Name=Google Chrome (No Sandbox)|' > AppDir/google-chrome-no-sandbox.desktop

# Deploy dependencies

./quick-sharun.sh ./AppDir/bin/*

# Additional changes can be done in between here

# Copy the config
#if [ -d _config ]
#then
#	mkdir -p AppDir/_config
#	cp -va _config/* AppDir/_config/
#fi

# Copy details
mkdir -v AppDir/_details
echo "$UBID" > AppDir/_details/commit.txt
echo "$(date)" > AppDir/_details/date.txt
rpm -qa > AppDir/_details/packages.txt
cp -v latest_version.txt > AppDir/_details/
fastfetch|sed -e 's/Local IP.*//' -e 's/Locale.*//' -e 's/Battery.*//' -e 's/Disk.*//' -e 's/Swap.*//' > AppDir/_details/system.txt

# Copy Internal scripts
# mkdir -vp AppDir/bin

cp -v is_details AppDir/bin/details
cp -v is_setup.1.sh AppDir/bin/setup
cat is_setup.2.sh >> AppDir/bin/setup

chmod +x AppDir/bin/details
chmod +x AppDir/bin/setup

# Turn AppDir into AppImage
./quick-sharun.sh --make-appimage
