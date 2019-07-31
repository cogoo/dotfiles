#!/bin/sh
git pull origin master;

#set default terminal to zsh
chsh -s /bin/zsh

cd ~

source .apps.sh
source .symlinks.zsh
