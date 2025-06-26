#!/usr/bin/env bash

# Zinit plugins configuration
# Based on previous antibody bundles

# Load zinit
source ~/.local/share/zinit/zinit.git/zinit.zsh

# Plugins
zinit load djui/alias-tips
zinit load caarlos0/zsh-mkc
zinit load caarlos0/zsh-git-sync
zinit load zsh-users/zsh-syntax-highlighting
zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-completions
zinit load lukechilds/zsh-better-npm-completion

# Oh-my-zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::yarn
zinit snippet OMZP::z

# Load completions
autoload -U compinit && compinit