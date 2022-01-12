#!/bin/bash

# ===================================================
# Imports
# ===================================================

logInfo "Installing the MOTD packages..."

sed -i 's|session    optional   pam_motd.so\+|#session    optional   pam_motd.so|g' /etc/pam.d/login
sed -i 's|session    optional   pam_motd.so\+|#session    optional   pam_motd.so|g' /etc/pam.d/sshd

# install the required packages
apt-get install -y figlet neofetch lolcat > /dev/null 2>&1

# download the configuration
curl -fLo ~/.config/neofetch/config.conf --create-dirs --silent https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/resources/config.conf