#!/usr/bin/env bash

# List files when switching directory
chpwd() {
  clear && exa -la
}

update_zinit_plugins() {
  zinit update --all
  zinit compile --all
}

# find all node_modules folders and list the size
audit_node_modules() {
  printf '🏋🏽‍♂️  finding node_modules folders \n'
  npx npkill
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
  echo "🔄 Updating installed programs..."
  
  # Update Homebrew
  if command -v brew &>/dev/null; then
    echo "🍺 Updating Homebrew..."
    brew update
    brew upgrade
    brew cleanup
  fi
  
  # Update Node.js packages
  if command -v npm &>/dev/null; then
    echo "📦 Updating global NPM packages..."
    npm update -g
  fi
  
  # Update Volta
  if command -v volta &>/dev/null; then
    echo "⚡ Updating Volta..."
    volta install node@lts
    volta install npm@latest
  fi
  
  # Update Rust
  if command -v rustup &>/dev/null; then
    echo "🦀 Updating Rust..."
    rustup update
  fi
  
  echo "✅ Update complete"
}

update_all() {
  update_zinit_plugins
  update_installed_programs
}
