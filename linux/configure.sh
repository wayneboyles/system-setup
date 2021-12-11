#!/bin/bash

# ===================================================
# Colors
# ===================================================

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# ===================================================
# Variables
# ===================================================

SCRIPT_DIR="$(pwd)"

OS_DISTRO=''
OS_VERSION=''
OS_CODENAME=''

INFO_LOG="$SCRIPT_DIR/configure.log"
DEBUG_LOG="$SCRIPT_DIR/configure.debug.log"

# List of packages to install by default
# TODO: support multiple distribution package names
COMMON_PKGS=(vim-nox wget curl tree git net-tools chrony)

# ===================================================
# Functions
# ===================================================

function logInfo() {
  local NOW=$(date +%T)
  echo -e "${WHITE}$NOW [${CYAN}INFO${WHITE} ] $1${NC}"
}

function logWarning() {
  local NOW=$(date +%T)
  echo -e "${WHITE}$NOW [${YELLOW}WARN${WHITE} ] $1${NC}"
}

function logError() {
  local NOW=$(date +%T)
  echo -e "${WHITE}$NOW [${RED}ERROR${WHITE}] $1${NC}"
}

function printHeader() {
    clear
    echo -e "${ORANGE}=======================================${NC}"
    echo -e "${GREEN}Linux Setup Script${NC}"
    echo -e "${WHITE}A simple script to help automate common${NC}"
    echo -e "${WHITE}system setup tasks${NC}"
    echo -e "${ORANGE}=======================================${NC}"
    echo ''
}

function updateSystem() {
    logInfo "Performing system update (this may take a few minutes)..."
    # TODO: support multiple package managers
    apt-get update -y > /dev/null 2>&1
    apt-get clean all > /dev/null 2>&1
}

function installPackage() {
    logInfo "Installing $1..."
    # TODO: support multiple package managers
    apt-get install -y $1 > /dev/null 2>&1
}

function installPackages() {
    logInfo "Installing $*..."
    # TODO: support multiple package managers
    apt-get install -y $* > /dev/null 2>&1
}

function installPowerlineFonts() {
  logInfo "Cloning powerline fonts..."
  if [[ -d /tmp/fonts ]]
  then
    logWarning "Target directory (/tmp/fonts/) exists. Contents will be removed..."
    rm -rf /tmp/fonts
  fi
  cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1 -q > /dev/null 2>&1

  logInfo "Installing powerline fonts..."
  /tmp/fonts/install.sh > /dev/null 2>&1
  rm -rf /tmp/fonts
}

function installVimPlug() {
  logInfo "Installing vim-plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs --silent https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function installVimConfig() {
  # install custom vim settings
  logInfo "Installing customized vim settings to ~/.vimrc ..."
  curl -fLo ~/.vimrc --silent https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/.vimrc

  # install the vim plugins
  logInfo "Installing vim plugins for first use..."
  vim -E -s -u ~/.vimrc +PlugInstall +qall
}

function installZsh() {
  logInfo "Installing the ZSH shell..."
  apt-get install -y zsh > /dev/null 2>&1

  logInfo "Changing the default shell to zsh for the current user..."
  local CURRENT_USER=$(whoami)
  chsh -s /usr/bin/zsh $CURRENT_USER

  logInfo "Installing oh-my-zsh..."
  
  if [[ -f install.sh ]]
  then
    rm -f install.sh
  fi

  wget -q https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
  chmod o+x install.sh
  ./install.sh > /dev/null 2>&1
  rm -f install.sh

  logInfo "Downloading customized .zshrc file..."
  wget -q https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/.zshrc
  mv .zshrc ~/.zshrc
}

# ===================================================
# Initialization
# ===================================================

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  
  # get the distribution
  DISTRIB=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
  
  # version number
  OS_VERSION=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release)

  # codename
  OS_CODENAME=$(awk -F= '/^VERSION_CODENAME/{print $2}' /etc/os-release)
  
  if [[ ${DISTRIB} == *Ubuntu* ]]
  then
    if uname -a | grep -q '^Linux.*Microsoft'
    then
      OS_DISTRO="Ubuntu (WSL)"
    else
      OS_DISTRO="Ubuntu"
    fi
  elif [[ ${DISTRIB} == *Debian* ]]
  then
    OS_DISTRO="Debian"
  else
    OS_DISTRO='Unsupported'
  fi
else
    OS_DISTRO='Unsupported'
fi

if [[ $OS_DISTRO == 'Unsupported' ]]
then
    logError "Unsupported Distribution"
    exit 1
fi

# ===================================================
# Execution
# ===================================================

printHeader

# run a system update
#updateSystem

# install common packages
#installPackages ${COMMON_PKGS[@]}

# install fonts
#installPowerlineFonts

# install vim-plug and custom .vimrc
#installVimPlug
#installVimConfig

echo ''
while true; do
  read -p "$(echo -e $WHITE"Install the zsh shell? (Yes/No): "$NC)" yn
  case $yn in
    [Yy]* ) installZsh; break;;
    [Nn]* ) break;;
  esac
done

# enable chrony
systemctl enable chrony > /dev/null 2>&1
systemctl restart chrony > /dev/null 2>&1

# done
echo "Done"