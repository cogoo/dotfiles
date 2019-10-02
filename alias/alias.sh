#!/bin/sh

# Aliases
alias restart="source ~/.zshrc"

# Mac
alias hide-desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias show-desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias afk="open -a /System/Library/CoreServices/ScreenSaverEngine.app"
alias restart-audio="killall coreaudiod"

# NPM
alias npm-globals="npm list -g --depth 0"
alias clone="npx degit"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias get-app="brew cask install"
alias nx-create="~/.dotfiles/scripts/nx.sh"

# Docker
alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias docker-kill-all='docker kill `docker ps -q`'
alias docker-rm-all='docker rm `docker ps -a -q`'
alias docker-clear='docker-kill-all;docker-rm-all'
alias docker-rmi-all='docker rmi -f `docker images -q`'

# Shortcuts
alias gitconfig="vim ~/.gitconfig"
alias zshconfig="vim ~/.zshrc"
alias vi="vim"
alias c="clear"
# alias ls="tree -C -ap -L 1 -I node_modules"
alias ls="exa"
alias tree="tree -C -ap -I node_modules"

# Vscode profile
alias code-shell="code --extensions-dir /Users/colin.ogoo/.dotfiles/vscode/profiles/shell/exts"
