#!/usr/bin/env bash

delete_project_folders() {
  LOCALHOST_DIR="$HOME/LocalHost"

  echo "Deleting LocalHost folder..."

  if [ -d "$GITHUB_DIR" ]; then
    rm -rf "$LOCALHOST_DIR"
  fi
}

uninstall_packages() {
  local PCKGS_FILE="$DOTFILES/bootstrap/brew_packages"

  if [ -f "$PCKGS_FILE" ]; then
    echo "📦 Installing packages..."
    while IFS= read -r pckg; do
      echo "📦 Uninstalling: ${pckg}"
      brew uninstall "${pckg}"
    done <"$PCKGS_FILE"
  fi
}

uninstall_apps() {
  local CASKS_FILE="$DOTFILES/bootstrap/brew_casks"

  if [ -f "$CASKS_FILE" ]; then
    while IFS= read -r cask; do
      echo "📦 Uninstalling ${cask}"
      brew uninstall --cask "${cask}"
    done <"$CASKS_FILE"
  fi
}

uninstall_fonts() {
  echo "📦 Installing fonts..."
  local FONTS_FILE="$DOTFILES/bootstrap/brew_fonts"

  if [ -f "$FONTS_FILE" ]; then
    while IFS= read -r font; do
      echo "📦 Uninstalling ${font}"
      brew uninstall --cask "${font}"
    done <"$FONTS_FILE"
  fi
}

uninstall_npm_packages() {
  echo "📦 Uninstalling Global NPM packages..."
  local NPM_GLOBALS="$DOTFILES/bootstrap/npm_globals"

  if [ -f "$NPM_GLOBALS" ]; then
    # check if package exists
    while IFS= read -r npm_pckg; do
      npm uninstall -gf "${npm_pckg}"
    done <"$NPM_GLOBALS"
  fi
}

uninstall_antibody() {
  brew uninstall antibody
}

uninstall_tmuxinator() {
  # Req: >= ruby@2.4.6
  echo "📦 Uninstalling TMUXinator..."
  gem uninstall tmuxinator
}

read -ep "Teardown? (y/n) " ANSWER
if [ "$ANSWER" = "Y" ]; then
  echo "Tearing down"

  delete_project_folders
  # reverse installds from bootstrap.sh
  uninstall_packages
  uninstall_apps
  uninstall_fonts
  uninstall_npm_packages
  uninstall_antibody
  uninstall_tmuxinator
  # Delete downloads
  # Delete documents
fi
