#!/usr/bin/env bash

#set -ex

echo "🚀 Starting bootstrap"

# Ask for the administrator password upfront
sudo -v

install_homebrew() {
  if test "$(which brew)"; then
    echo "😊 Homebrew installed..."
    return 0
  fi

  echo "😎 Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

update_homebrew() {
  brew update
}

install_nvm() {
  echo "😎 Installing NVM..."
  export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
  ) && \. "$NVM_DIR/nvm.sh"
}

setup_node() {
  echo "😎 Setting up Node w/ NVM ..."
  if [ -z "$NVM_DIR" ]; then
    # NVM_DIR is undefined, so it's not been initialised
    NVM_DIR="$HOME/.nvm"
  fi

  . "$NVM_DIR/nvm.sh"

  nvm install lts/dubnium
  nvm alias default lts/dubnium
}

install_rvm() {
  echo "😎 Installing RVM..."
  ruby -e "$(curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles)"
}

cleanup_homebrew() {
  echo "🛀🏽 Cleaning up..."
  brew cleanup
}

install_packages() {
  local PCKGS_FILE="$DOTFILES/bootstrap/brew_packages"

  if [ -f "$PCKGS_FILE" ]; then
    echo "📦 Installing packages..."
    while IFS= read -r pckg; do
      command -v "${pckg}" &>/dev/null && continue

      echo "📦 Installing: ${pckg}"
      brew install "${pckg}"
    done <"$PCKGS_FILE"
  fi
}

install_apps() {
  brew tap homebrew/cask-versions
  local CASKS_FILE="$DOTFILES/bootstrap/brew_casks"

  if [ -f "$CASKS_FILE" ]; then
    while IFS= read -r cask; do
      #TODO: check if app already exists
      echo "📦 Installing ${cask}"
      brew install --cask "${cask}"
    done <"$CASKS_FILE"
  fi
}

install_fonts() {
  echo "📦 Installing fonts..."
  brew tap homebrew/cask-fonts
  local FONTS_FILE="$DOTFILES/bootstrap/brew_fonts"

  if [ -f "$FONTS_FILE" ]; then
    while IFS= read -r font; do
      echo "📦 Installing ${font}"
      brew install --cask "${font}"
    done <"$FONTS_FILE"
  fi
}

install_npm_packages() {
  echo "📦 Installing Global NPM packages..."
  local NPM_GLOBALS="$DOTFILES/bootstrap/npm_globals"

  if [ -f "$NPM_GLOBALS" ]; then
    # check if package exists
    while IFS= read -r npm_pckg; do
      npm i -gf "${npm_pckg}"
    done <"$NPM_GLOBALS"

    # Set-up NVM globals
    cp "$NPM_GLOBALS" "$NVM_DIR/default-packages"
  fi
}

install_antibody() {
  brew tap | grep -q 'getantibody/tap' || brew tap getantibody/tap
  brew install antibody
}

install_tmuxinator() {
  # Req: >= ruby@2.4.6
  echo "📦 Installing TMUXinator..."
  gem install tmuxinator
}

setup_project_folders() {
  GITHUB_DIR="$HOME/LocalHost/GitHub"
  GLOBAL_DIR="$HOME/LocalHost/Global"

  echo "Creating folder structure..."

  if ! [ -d "$GITHUB_DIR" ]; then
    mkdir -p "$GITHUB_DIR"
  fi

  if ! [ -d "$GLOBAL_DIR" ]; then
    mkdir -p "$GLOBAL_DIR"
  fi
}

install_flutter() {
  cd "$GLOBAL_DIR" || exit
  git clone https://github.com/flutter/flutter.git

  # Install cocoapods
  gem install cocoapods
}

read -ep "Install homebrew? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_homebrew
fi

read -ep "Update homebrew? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  update_homebrew
fi

read -ep "Install RVM? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_rvm
fi

read -ep "Install Packages? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_packages
fi

read -ep "Install Apps? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_apps
fi

read -ep "Install Fonts? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_fonts
fi

read -ep "Install NVM? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_nvm
fi

read -ep "Set-up Node? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  setup_node
fi

read -ep "Install NPM packages? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_npm_packages
fi

read -ep "Install Tmuxinator? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_tmuxinator
fi

read -ep "Install Antibody? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_antibody
fi

read -ep "Setup project folders? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  setup_project_folders
fi

read -ep "Install Flutter? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_flutter
fi

#cleanup_homebrew

printf "\\n🦁  Bootstrapping complete \\n"
