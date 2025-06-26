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

# Load zinit plugins
if [[ -f "$DOTFILES/zinit/plugins.zsh" ]]; then
  . "$DOTFILES/zinit/plugins.zsh"
fi

# Init
. "$DOTFILES/functions/functions.sh"
. "$DOTFILES/alias/alias.sh"


# Initiate Starship
eval "$(starship init zsh)"

# Setup JAVA environment variable
export "JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"


[ -f "$HOME/.fzf.zsh" ] && . "$HOME/.fzf.zsh"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"


fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit

PATH=~/.console-ninja/.bin:$PATH
TWILIO_AC_ZSH_SETUP_PATH=/Users/cogoo/.twilio-cli/autocomplete/zsh_setup && test -f $TWILIO_AC_ZSH_SETUP_PATH && source $TWILIO_AC_ZSH_SETUP_PATH # twilio autocomplete setup
source <(soroban completion --shell zsh)

if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
