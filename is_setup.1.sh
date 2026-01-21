#!/bin/bash

# NOTE: THIS IS AN INTERNAL SCRIPT AND IT CAN ONLY RUN INSIDE THE APPIMAGE AS
# A COMMAND LINE ARGUMENT

set -eu

MAIN_BIN="/usr/bin/google-chrome-stable"

CONFIG_DIR="$HOME""/.config/google-chrome"

DESKTOP="program.desktop"
DESKTOP_EXEC=$(basename "$MAIN_BIN")
PATH_ICON="/usr/share/icons/google-chrome.png"
declare -a LBINARIES=(
	"$MAIN_BIN"
)

function additional_config_tasks() {
	# sed -i "s:HOME_DIRECTORY:$HOME:" "$CONFIG_DIR"/someconfigfile.cfg
	cat "$DESKTOP" | sed -e 's|google-chrome-stable|google-chrome-stable --no-sandbox|' -e 's|Name=Google Chrome|Name=Google Chrome (No Sandbox)|' > /usr/share/applications/google-chrome-no-sandbox.desktop
}
