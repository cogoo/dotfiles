# # Set personal aliases, overriding those provided by oh-my-zsh libs,
# # plugins, and themes. Aliases can be placed here, though oh-my-zsh
# # users are encouraged to define aliases within the ZSH_CUSTOM folder.
# # For a full list of active aliases, run `alias`.
# #
# Aliases
alias bynd="~/LocalHost/Bynd"
alias c="clear"
alias gitconfig="vim ~/.gitconfig"
alias github="~/LocalHost/GitHub"
alias npm-globals="npm list -g --depth 0"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias restart="source ~/.zshrc"
alias restart-audio="killall coreaudiod"
alias zshconfig="vim ~/.zshrc"
alias clone="npx degit"
alias vi="vim"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"


