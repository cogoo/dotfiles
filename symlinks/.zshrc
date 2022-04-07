#!/usr/bin/env bash

# Set dotfiles path
export DOTFILES="$HOME/dotfiles"

# ZSH Settings
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
DISABLE_AUTO_UPDATE=true
ZSH_DISABLE_COMPFIX=true

# Add default editor
export EDITOR='vim'

# Set manual global installs
if [ -d "$HOME/Global" ]; then
  export GLOBAL_INSTALLS_PATH="$HOME/Global"
fi

# Set brew cask install root
export CASKROOM="/usr/local/Caskroom"

# Antibody oh-my-zsh fix
ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

# Init antibody plugins
. "$HOME/.zsh_plugins.sh"

# Init
. "$DOTFILES/functions/functions.sh"
. "$DOTFILES/alias/alias.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Initiate Starship
eval "$(starship init zsh)"

# Setup JAVA environment variable
export "JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# Setup devserverapp.py
if [ -f "$CASKROOM/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then
  . "$CASKROOM/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi

[ -f "$HOME/.fzf.zsh" ] && . "$HOME/.fzf.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
