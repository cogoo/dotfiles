#!/usr/bin/env bash

# Auto switch node version
load-nvmrc() {
  local node_version
  node_version="$(nvm version)"
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

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

update_antibody_plugins() {
  antibody bundle <"$DOTFILES/antibody/bundles" >"$HOME/.zsh_plugins.sh"
  antibody update
}

# find all node_modules folders and list the size
audit_node_modules() {
  printf '🏋🏽‍♂️  finding node_modules folders \n'
  npx npkill
}

fix_rvm() {
  brew reinstall ruby vim
}

add_missing_functions() {
  echo "🎗 Run only once"
  complete -C _fastlane_complete.rb fastlane
}

use_latest_xcode() {
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -runFirstLaunch
}

teardown() {
  echo "👋🏽  Prepaing to teardown"
  "$DOTFILES/teardown.sh"
}

fix_compdef_issues() {
  #This will perform chmod g-w for each file returned by compaudit to remove write access for group
  compaudit | xargs -I % chmod g-w "%"
  #This will perform chown to current user (Windows and Linux) for each file returned by compaudit
  compaudit | xargs -I % chown "$USER" "%"
  #Remove all dump files (which normally speed up initialization)
  rm ~/.zcompdump*
  #Regenerate completions file
  compinit
}

update_installed_programs() {
  echo "TODO: update brew packages"
}

update_all() {
  update_antibody_plugins
  update_installed_programs
}
