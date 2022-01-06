#!/bin/bash

# ===================================================
# Imports
# ===================================================

. shared/common.sh
. shared/environment.sh

# ===================================================
# Variables
# ===================================================

SCRIPT_DIR="$(pwd)"


# ===================================================
# Functions
# ===================================================

function printHeader() {
    #clear
    echo -e "${ORANGE}=======================================${NC}"
    echo -e "${GREEN}Linux Setup Script${NC}"
    echo -e "${LIGHTGRAY}A simple script to help automate common${NC}"
    echo -e "${LIGHTGRAY}system setup tasks${NC}"
    echo -e "${ORANGE}=======================================${NC}"
    echo ''
    echo -e "${LIGHTGRAY}Please note, the configurations here are based on my personal preference"
    echo -e "${LIGHTGRAY}and may not suite your requirements.  Please review the config.yml file"
    echo -e "${LIGHTGRAY}for all possible configuration values.${NC}"
    echo ''
}

# # ===================================================
# # Execution
# # ===================================================

cache_uname
get_os
get_distro

get_args "$@"

printHeader

if [[ $distro == *'Unknown'* ]]
then
    logError "Unsupported Distribution"
    exit 1
fi

# did we pass in the --config parameter?
if [[ -z "$YAML_FILE" ]]; then
  YAML_FILE=./config.yml
fi

echo -e "${LIGHTGRAY}OS:          ${GREEN}$DISTRO${NC}"
echo -e "${LIGHTGRAY}OS Version:  ${GREEN}$DISTRO_VERSION${NC}"
echo -e "${LIGHTGRAY}Codename:    ${GREEN}$DISTRO_CODENAME${NC}"
echo -e "${LIGHTGRAY}Config File: ${GREEN}$YAML_FILE${NC}"
echo ''

while true; do
  read -p "$(echo -e $ORANGE"Continue? $WHITE(Yes/No): "$NC)" yn
  case $yn in
    [Yy]* ) echo ''; break;;
    [Nn]* ) echo ''; exit 0; break;;
  esac
done

# does the configuration file exist
if [[ -f "$YAML_FILE" ]]; then
  eval $(parse_yaml $YAML_FILE)
else
  logError "Unable to find config file '$YAML_FILE'.  Unable to continue."
  exit 1
fi

# Configure SSH
. components/ssh.sh

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

# Finish
shutdown -r now