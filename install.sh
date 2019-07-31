#!/bin/sh
git pull origin master;

# function doIt() {
# 	rsync --exclude ".git/" \
# 		--exclude ".DS_Store" \
# 		--exclude ".osx" \
# 		--exclude "install.sh" \
# 		--exclude ".aliases.zsh" \
# 		--exclude "README.md" \
# 		--exclude "LICENSE" \
# 		-avh --no-perms . ~;
# 	source ~/.zshrc;
# }

# doIt;
# unset doIt;

source .symlinks.zsh
source .apps.sh
