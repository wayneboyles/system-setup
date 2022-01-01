#!/bin/bash

# ===================================================
# Imports
# ===================================================

. ../utils/common.sh
. ../utils/environment.sh

logInfo "Installing the MOTD packages..."

# install the required packages
apt-get install -y figlet neofetch lolcat > /dev/null 2>&1

# download the configuration
curl -fLo ~/.config/neofetch/config.conf --create-dirs --silent https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/resources/config.conf

