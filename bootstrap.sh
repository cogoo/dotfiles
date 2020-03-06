#!/bin/sh
cd ~/.dotfiles

git pull origin master;

#set default terminal to zsh
#chsh -s /bin/zsh

read -ep "Run bootstap? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
	./bootstrap/install.sh
fi

read -ep "Install IDE settings? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
	./vscode/install.sh
fi

read -ep "Install Antibody Plugins? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
	./antibody/install.sh
fi

read -ep "Register symlinks? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
	./symlinks/symlinks.sh
fi
