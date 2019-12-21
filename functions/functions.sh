#!/bin/sh

# Auto switch node version
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" != "N/A" ] && [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

# Add load-nvmrc function to change directory
add-zsh-hook chpwd load-nvmrc

# List files when switching directory
chpwd() {
  clear && exa -la
}

# Helpers for Nx library
og-nx-add() {
  if [ "$#" = 3 ]; then
    echo "📦  Creating $1 $2"
    ng g @nrwl/$1:$2 $3
  else
    echo "🚫  This command requires 3 parameters"
  fi
}

update_antibody_plugins() {
  antibody bundle < ~/.dotfiles/antibody/bundles.txt >~/.zsh_plugins.sh
  antibody update
}

update_vscode_extensions() {
	code --list-extensions >$DOTFILES/vscode/extensions.txt
}

# create custom vscode profile
create_vscode_profile () {
	if [ "$1" ]; then
		 # body
		 directory="$HOME/.dotfiles/vscode/profiles/$1"
		 if [ -d "$directory" ]; then
			 echo "😅 Profile already exists"

			 return
		 fi

		 echo "📦 Creating profile $1"
		 mkdir -p "$HOME/.dotfiles/vscode/profiles/$1/exts"

		 echo "🔗 Creating alias for profile"
		 echo "\n#Vscode profile \nalias code-$1=\"code --extensions-dir $HOME/.dotfiles/vscode/profiles/$1/exts\"" >> "$HOME/.dotfiles/alias/alias.sh"

		 echo "🛀🏽 Alias code-$1 created"
	else
		 # body
		 echo "😅 Please specify a name"
		 return
	fi
}

# find all node_modules folders and list the size
audit_node_modules() {
	echo '🏋🏽‍♂️  finding node_modules folders \n'
	npx npkill
}

use_latest_xcode() {
	sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
 	sudo xcodebuild -runFirstLaunch
}
