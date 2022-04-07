#!/usr/bin/env bash

cd "$HOME/dotfiles" || exit

read -ep "👌🏾  Get latest version? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  git pull origin master
fi

read -ep "Install rosetta? (y/n)" ANSWER
if [ "$ANSWER" = "y" ]; then
  softwareupdate --install-rosetta
fi

#set default terminal to zsh
#chsh -s /bin/zsh

read -ep "🏃🏽‍♂️  Run bootstap? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  ./bootstrap/install.sh
fi

read -ep "🎙  Install Antibody Plugins? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  ./antibody/install.sh
fi

read -ep "⛓  Register symlinks? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  ./symlinks/install.sh
fi

read -ep "🕶  Set Mac defaults? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  ./macos/install.sh
fi
