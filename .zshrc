# Init antigen
source $HOME/.antigen.zsh
antigen init $HOME/.antigenrc

# ZSH Settings
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

## User configuration ##

# Add NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source $HOME/.functions.zsh
source $HOME/.aliases.zsh

