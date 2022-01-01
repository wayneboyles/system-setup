#!/bin/bash

# ===================================================
# Imports
# ===================================================

. utils/common.sh
. utils/environment.sh

# ===================================================
# Variables
# ===================================================

SCRIPT_DIR="$(pwd)"

# ===================================================
# Functions
# ===================================================

function printHeader() {
    clear
    echo -e "${ORANGE}=======================================${NC}"
    echo -e "${GREEN}Linux Setup Script${NC}"
    echo -e "${WHITE}A simple script to help automate common${NC}"
    echo -e "${WHITE}system setup tasks${NC}"
    echo -e "${ORANGE}=======================================${NC}"
    echo ''
    echo -e "${WHITE}Please note, the configurations here are based on my personal preference"
    echo -e "${WHITE}and may not suite your requirements.  Please review the config.yml file"
    echo -e "${WHITE}for all possible configuration values.${NC}"
    echo ''
}

# # ===================================================
# # Execution
# # ===================================================

cache_uname
get_os
get_distro

printHeader

if [[ $distro == *'Unknown'* ]]
then
    logError "Unsupported Distribution"
    exit 1
fi

echo -e "${WHITE}OS:          ${GREEN}$DISTRIB${NC}"
echo -e "${WHITE}OS Version:  ${GREEN}$OS_VERSION${NC}"
echo -e "${WHITE}Codename:    ${GREEN}$OS_CODENAME${NC}"
echo ''

while true; do
  read -p "$(echo -e $ORANGE"Continue? $WHITE(Yes/No): "$NC)" yn
  case $yn in
    [Yy]* ) echo ''; break;;
    [Nn]* ) echo ''; exit 0; break;;
  esac
done

# TODO: Check if config file exists
eval $(parse_yaml config.yml)

# Set the timezone
. components/timezone.sh

# Configure NTP servers
. components/ntp.sh

# Install System Updates
. components/updates.sh

# Install Packages
. components/packages.sh

# Install System Fonts
. components/fonts.sh

# Configure VIM
. components/vim.sh