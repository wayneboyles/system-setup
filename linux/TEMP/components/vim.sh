#!/bin/bash

logInfo "Configuring the vim editor..."

curl -fLo ~/.vim/autoload/plug.vim --create-dirs --silent https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.vimrc --silent https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/resources/.vimrc

vim -E -s -u ~/.vimrc +PlugInstall +qall