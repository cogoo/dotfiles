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

install_volta() {
  echo "😎 Installing Volta..."
  curl https://get.volta.sh | bash

}

setup_node() {
  # add setup for volta
  true
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

setup_project_folders() {
  GITHUB_DIR="$HOME/GitHub"

  echo "Creating folder structure..."

  if ! [ -d "$GITHUB_DIR" ]; then
    mkdir -p "$GITHUB_DIR"
  fi
}

install_flutter() {
  # update install flutter script
  true
}

read -ep "Install homebrew? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_homebrew
fi

read -ep "Update homebrew? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  update_homebrew
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

read -ep "Install Volta? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_volta
fi

read -ep "Set-up Node? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  setup_node
fi

read -ep "Install NPM packages? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  install_npm_packages
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
