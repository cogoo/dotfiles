#!/bin/sh
cd ~/.dotfiles

git pull origin master;

#set default terminal to zsh
#chsh -s /bin/zsh

./apps.sh
./vscode-extensions.sh
./symlinks.sh

cd ~
echo "Creating folder structure..."
[[ ! -d LocalHost ]] && mkdir -p LocalHost/GitHub
