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
alias localip="ipconfig getifaddr en0"

# Brew
alias get-app="brew cask install"
alias get="brew install"

# Docker
alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias docker-kill-all='docker kill `docker ps -q`'
alias docker-rm-all='docker rm `docker ps -a -q`'
alias docker-clear='docker-kill-all;docker-rm-all'
alias docker-rmi-all='docker rmi -f `docker images -q`'

# Tmux
alias tk="tkss"
alias tkk="tksv"
alias tls="tmux ls"

# Shortcuts
alias gitconfig="vim ~/.gitconfig"
alias zshconfig="vim ~/.zshrc"
alias vi="vim"
alias c="clear"
alias tree="tree -C -ap -I node_modules"
alias ports-in-use="lsof -PiTCP -sTCP:LISTEN"
# alias ls="tree -C -ap -L 1 -I node_modules"

# Rust tools
alias ls="exa"
alias cat="bat"
alias find="fd"
alias ps="procs"
alias du="dust"
alias grep="rg"
