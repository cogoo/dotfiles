# Init antigen
. $HOME/.antigen.sh
antigen init $HOME/.antigenrc

# ZSH Settings
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

## User configuration ##

# Add default editor
export EDITOR='vim'

# Add NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

. $HOME/.functions
. $HOME/.aliases
# . $HOME/.tmuxinator.zsh


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/colin.ogoo/LocalHost/Global/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/colin.ogoo/LocalHost/Global/google-cloud-sdk/path.zsh.inc'; fi
# The next line updates PATH for Flutter.
if [ -f '/Users/colin.ogoo/LocalHost/Global/flutter/path.zsh.inc' ]; then . '/Users/colin.ogoo/LocalHost/Global/flutter/path.zsh.inc'; fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/ruby/bin:$PATH"