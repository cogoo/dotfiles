#!/usr/bin/env bash

#set -ex

echo "🚀 Starting bootstrap"

# Load state management
source "$DOTFILES/state.sh" || source "./state.sh"

# Check for non-interactive mode
NON_INTERACTIVE=false
if [ "$1" = "--yes" ] || [ "$1" = "-y" ]; then
  NON_INTERACTIVE=true
  echo "🤖 Running in non-interactive mode"
fi

ask_or_default() {
  local prompt="$1"
  local default="$2"
  
  if [ "$NON_INTERACTIVE" = true ]; then
    echo "$prompt (auto: $default)"
    echo "$default"
  else
    read -ep "$prompt " ANSWER
    echo "${ANSWER:-$default}"
  fi
}

# Ask for the administrator password upfront
sudo -v

install_homebrew() {
  if test "$(which brew)"; then
    echo "✅ Homebrew already installed, skipping..."
    return 0
  fi

  echo "😎 Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

update_homebrew() {
  brew update
}

install_volta() {
  if [ -d "$HOME/.volta" ]; then
    echo "✅ Volta already installed, skipping..."
    return 0
  fi
  
  echo "😎 Installing Volta..."
  curl https://get.volta.sh | bash
}

get_version() {
  local tool="$1"
  local versions_file="$DOTFILES/versions.txt"
  
  if [ -f "$versions_file" ]; then
    grep "^${tool}=" "$versions_file" | cut -d'=' -f2 | head -1
  else
    echo "latest"
  fi
}

setup_node() {
  echo "🚀 Setting up Node.js with Volta..."
  
  local node_version=$(get_version "node")
  local npm_version=$(get_version "npm")
  
  # Install specified Node.js version
  volta install "node@${node_version}"
  
  # Set npm version
  volta install "npm@${npm_version}"
  
  echo "✅ Node.js setup complete (Node: ${node_version}, npm: ${npm_version})"
}

cleanup_homebrew() {
  echo "🛀🏽 Cleaning up..."
  brew cleanup
}

install_packages() {
  local PCKGS_FILE="$DOTFILES/bootstrap/brew_packages"

  if [ -f "$PCKGS_FILE" ]; then
    echo "📦 Checking packages..."
    local packages_to_install=()
    
    while IFS= read -r pckg; do
      [[ -z "$pckg" || "$pckg" =~ ^[[:space:]]*# ]] && continue
      
      if ! brew list "$pckg" &>/dev/null; then
        packages_to_install+=("$pckg")
      fi
    done <"$PCKGS_FILE"
    
    if [ ${#packages_to_install[@]} -eq 0 ]; then
      echo "✅ All packages already installed, skipping..."
    else
      echo "📦 Installing ${#packages_to_install[@]} packages..."
      for pckg in "${packages_to_install[@]}"; do
        echo "📦 Installing: ${pckg}"
        brew install "${pckg}"
      done
    fi
  fi
}

install_apps() {
  brew tap homebrew/cask-versions &>/dev/null || true
  local CASKS_FILE="$DOTFILES/bootstrap/brew_casks"

  if [ -f "$CASKS_FILE" ]; then
    echo "📱 Checking apps..."
    local apps_to_install=()
    
    while IFS= read -r cask; do
      [[ -z "$cask" || "$cask" =~ ^[[:space:]]*# ]] && continue
      
      if ! brew list --cask "$cask" &>/dev/null; then
        apps_to_install+=("$cask")
      fi
    done <"$CASKS_FILE"
    
    if [ ${#apps_to_install[@]} -eq 0 ]; then
      echo "✅ All apps already installed, skipping..."
    else
      echo "📱 Installing ${#apps_to_install[@]} apps..."
      for cask in "${apps_to_install[@]}"; do
        echo "📦 Installing ${cask}"
        brew install --cask "${cask}"
      done
    fi
  fi
}

install_fonts() {
  brew tap homebrew/cask-fonts &>/dev/null || true
  local FONTS_FILE="$DOTFILES/bootstrap/brew_fonts"

  if [ -f "$FONTS_FILE" ]; then
    echo "🔤 Checking fonts..."
    local fonts_to_install=()
    
    while IFS= read -r font; do
      [[ -z "$font" || "$font" =~ ^[[:space:]]*# ]] && continue
      
      if ! brew list --cask "$font" &>/dev/null; then
        fonts_to_install+=("$font")
      fi
    done <"$FONTS_FILE"
    
    if [ ${#fonts_to_install[@]} -eq 0 ]; then
      echo "✅ All fonts already installed, skipping..."
    else
      echo "🔤 Installing ${#fonts_to_install[@]} fonts..."
      for font in "${fonts_to_install[@]}"; do
        echo "📦 Installing ${font}"
        brew install --cask "${font}"
      done
    fi
  fi
}

install_npm_packages() {
  if ! command -v npm &>/dev/null; then
    echo "⚠️  npm not found, skipping npm packages..."
    return 0
  fi
  
  echo "📦 Checking global NPM packages..."
  local NPM_GLOBALS="$DOTFILES/bootstrap/npm_globals"

  if [ -f "$NPM_GLOBALS" ]; then
    local packages_to_install=()
    
    while IFS= read -r npm_pckg; do
      # Skip empty lines and comments
      [[ -z "$npm_pckg" || "$npm_pckg" =~ ^[[:space:]]*# ]] && continue
      
      if ! npm list -g "$npm_pckg" &>/dev/null; then
        packages_to_install+=("$npm_pckg")
      fi
    done <"$NPM_GLOBALS"
    
    if [ ${#packages_to_install[@]} -eq 0 ]; then
      echo "✅ All NPM packages already installed, skipping..."
    else
      echo "📦 Installing ${#packages_to_install[@]} NPM packages..."
      for npm_pckg in "${packages_to_install[@]}"; do
        echo "📦 Installing NPM package: ${npm_pckg}"
        npm i -gf "${npm_pckg}"
      done
    fi
  fi
}

install_zinit() {
  if [ -d "$HOME/.local/share/zinit" ]; then
    echo "✅ Zinit already installed, skipping..."
    return 0
  fi
  
  echo "📦 Installing Zinit..."
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
}

setup_project_folders() {
  GITHUB_DIR="$HOME/GitHub"

  if [ -d "$GITHUB_DIR" ]; then
    echo "✅ Project folders already exist, skipping..."
    return 0
  fi
  
  echo "📁 Creating folder structure..."
  mkdir -p "$GITHUB_DIR"
}

install_flutter() {
  # update install flutter script
  true
}

if ! is_step_complete "homebrew"; then
  ANSWER=$(ask_or_default "Install homebrew? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    install_homebrew && mark_step_complete "homebrew"
  fi
else
  echo "✅ Homebrew step already completed, skipping..."
fi

if ! is_step_complete "homebrew_update"; then
  ANSWER=$(ask_or_default "Update homebrew? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    update_homebrew && mark_step_complete "homebrew_update"
  fi
else
  echo "✅ Homebrew update step already completed, skipping..."
fi

if ! is_step_complete "packages"; then
  ANSWER=$(ask_or_default "Install Packages? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    install_packages && mark_step_complete "packages"
  fi
else
  echo "✅ Packages step already completed, skipping..."
fi

if ! is_step_complete "apps"; then
  ANSWER=$(ask_or_default "Install Apps? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    install_apps && mark_step_complete "apps"
  fi
else
  echo "✅ Apps step already completed, skipping..."
fi

if ! is_step_complete "fonts"; then
  ANSWER=$(ask_or_default "Install Fonts? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    install_fonts && mark_step_complete "fonts"
  fi
else
  echo "✅ Fonts step already completed, skipping..."
fi

if ! is_step_complete "volta"; then
  ANSWER=$(ask_or_default "Install Volta? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    install_volta && mark_step_complete "volta"
  fi
else
  echo "✅ Volta step already completed, skipping..."
fi

if ! is_step_complete "node_setup"; then
  ANSWER=$(ask_or_default "Set-up Node? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    setup_node && mark_step_complete "node_setup"
  fi
else
  echo "✅ Node setup step already completed, skipping..."
fi

if ! is_step_complete "npm_packages"; then
  ANSWER=$(ask_or_default "Install NPM packages? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    install_npm_packages && mark_step_complete "npm_packages"
  fi
else
  echo "✅ NPM packages step already completed, skipping..."
fi

if ! is_step_complete "zinit"; then
  ANSWER=$(ask_or_default "Install Zinit? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    install_zinit && mark_step_complete "zinit"
  fi
else
  echo "✅ Zinit step already completed, skipping..."
fi

if ! is_step_complete "project_folders"; then
  ANSWER=$(ask_or_default "Setup project folders? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    setup_project_folders && mark_step_complete "project_folders"
  fi
else
  echo "✅ Project folders step already completed, skipping..."
fi

if ! is_step_complete "flutter"; then
  ANSWER=$(ask_or_default "Install Flutter? (y/n)" "n")
  if [ "$ANSWER" = "y" ]; then
    install_flutter && mark_step_complete "flutter"
  fi
else
  echo "✅ Flutter step already completed, skipping..."
fi

#cleanup_homebrew

printf "\\n🦁  Bootstrapping complete \\n"
