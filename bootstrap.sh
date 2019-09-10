#!/bin/sh
cd ~/.dotfiles

git pull origin master;

#set default terminal to zsh
#chsh -s /bin/zsh

./bootstrap/install.sh
./vscode/install.sh
./antibody/install.sh
./symlinks/symlinks.sh