# Set dotfiles path
export DOTFILES="$HOME/.dotfiles"

# Set manual global installs
if [ -d "$HOME/LocalHost/Global" ]; then
  export GLOBAL_INSTALLS_PATH ="$HOME/LocalHost/Global"
fi

# ZSH Settings
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
DISABLE_AUTO_UPDATE=true

# Add default editor
export EDITOR='vim'

# Add NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$GLOBAL_INSTALLS_PATH/google-cloud-sdk/path.zsh.inc' ]; then . '$GLOBAL_INSTALLS_PATH/google-cloud-sdk/path.zsh.inc'; fi

# The next line updates PATH for Flutter.
if [ -f '$GLOBAL_INSTALLS_PATH/flutter/path.zsh.inc' ]; then . '$GLOBAL_INSTALLS_PATH/flutter/path.zsh.inc'; fi

# Antibody oh-my-zsh fix
ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

# Init antibody plugins
. $HOME/.zsh_plugins.sh

# Init
. $DOTFILES/functions/functions.sh
. $DOTFILES/alias/alias.sh