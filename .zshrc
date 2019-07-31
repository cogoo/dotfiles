# Init antigen
source $HOME/.antigen.sh
antigen init $HOME/.antigenrc

# ZSH Settings
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

## User configuration ##

# Add NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source $HOME/.functions
source $HOME/.aliases


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'


# The next line updates PATH for the Google Cloud SDK.

if [ -f '/Users/colin.ogoo/LocalHost/Global/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/colin.ogoo/LocalHost/Global/google-cloud-sdk/path.zsh.inc'; fi

if [ -f '/Users/colin.ogoo/LocalHost/Global/flutter/path.zsh.inc' ]; then . '/Users/colin.ogoo/LocalHost/Global/flutter/path.zsh.inc'; fi
