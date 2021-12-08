#!/bin/bash

# List of packages to install by default
# TODO: support multiple distribution package names
COMMON_PKGS=("vim-nox" "wget" "curl" "tree" "git" "net-tools" "chrony")

function updateSystem() {
    # TODO: support multiple package managers
    apt-get update -y
    apt-get clean all
}

function installPackage() {
    # TODO: support multiple package managers
    apt-get install -y $1
}

function installPackages() {
    # TODO: support multiple package managers
    apt-get install -y $*
}

# store the current directory
SCRIPT_DIR=$(pwd)

# run a system update
updateSystem

# install common packages
installPackages $COMMON_PKGS[@]

# install fonts
cd /tmp
git clone https://github.com/powerline/fonts.git --depth=1
cd /tmp/fonts
./install.sh
cd /tmp
rm -rf /tmp/fonts

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install custom vim settings
curl -fLo ~/.vimrc https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/.vimrc

# install the vim plugins
vim -E -s -u ~/.vimrc +PlugInstall +qall

# enable chrony
systemctl enable chrony
systemctl restart chrony

# done
echo "Done"