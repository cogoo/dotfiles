# Set dotfiles path
export DOTFILES="$HOME/.dotfiles"

# ZSH Settings
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
DISABLE_AUTO_UPDATE=true

# Add default editor
export EDITOR='vim'

# Add NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Set manual global installs
if [ -d "$HOME/LocalHost/Global" ]; then
  export GLOBAL_INSTALLS_PATH="$HOME/LocalHost/Global"
fi

# Set brew cask install root
export CASKROOM="/usr/local/Caskroom"


# The next line updates PATH for Flutter.
if [ -f "$GLOBAL_INSTALLS_PATH/flutter/path.zsh.inc" ]; then
	. "$GLOBAL_INSTALLS_PATH/flutter/path.zsh.inc";
fi

# Antibody oh-my-zsh fix
ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

# Init antibody plugins
. "$HOME/.zsh_plugins.sh"

# Init
. "$DOTFILES/functions/functions.sh"
. "$DOTFILES/alias/alias.sh"

if [ -f "$HOME/.fastlane/completions/completion.sh" ]; then
	. "$HOME/.fastlane/completions/completion.sh"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Initiate Starship
eval "$(starship init zsh)"

# Initialize PYENV
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Add flutter to path
export PATH="$PATH:$GLOBAL_INSTALLS_PATH/flutter/bin"

# Setup JAVA environment variable
export "JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# Setup devserverapp.py
if [ -f "$CASKROOM/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then
	. "$CASKROOM/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc";
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
