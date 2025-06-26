#!/usr/bin/env bash

# Uninstall script - inverse of bootstrap
# Removes all changes made by the bootstrap process

cd "$HOME/dotfiles" || exit

echo "🗑️  Starting uninstall process..."

# Ask for confirmation
read -ep "⚠️  This will remove all installed packages and configurations. Continue? (y/n) " ANSWER
if [ "$ANSWER" != "y" ]; then
  echo "❌ Uninstall cancelled"
  exit 0
fi

# Ask for the administrator password upfront
sudo -v

uninstall_npm_packages() {
  echo "🗑️  Removing global NPM packages..."
  local NPM_GLOBALS="$DOTFILES/bootstrap/npm_globals"

  if [ -f "$NPM_GLOBALS" ]; then
    while IFS= read -r npm_pckg; do
      [[ -z "$npm_pckg" || "$npm_pckg" =~ ^[[:space:]]*# ]] && continue
      echo "🗑️  Removing NPM package: ${npm_pckg}"
      npm uninstall -g "${npm_pckg}" 2>/dev/null || true
    done <"$NPM_GLOBALS"
  fi
}

uninstall_apps() {
  echo "🗑️  Removing installed apps..."
  local CASKS_FILE="$DOTFILES/bootstrap/brew_casks"

  if [ -f "$CASKS_FILE" ]; then
    while IFS= read -r cask; do
      [[ -z "$cask" || "$cask" =~ ^[[:space:]]*# ]] && continue
      echo "🗑️  Removing app: ${cask}"
      brew uninstall --cask "${cask}" 2>/dev/null || true
    done <"$CASKS_FILE"
  fi
}

uninstall_packages() {
  echo "🗑️  Removing installed packages..."
  local PCKGS_FILE="$DOTFILES/bootstrap/brew_packages"

  if [ -f "$PCKGS_FILE" ]; then
    while IFS= read -r pckg; do
      [[ -z "$pckg" || "$pckg" =~ ^[[:space:]]*# ]] && continue
      echo "🗑️  Removing package: ${pckg}"
      brew uninstall "${pckg}" 2>/dev/null || true
    done <"$PCKGS_FILE"
  fi
}

uninstall_fonts() {
  echo "🗑️  Removing installed fonts..."
  local FONTS_FILE="$DOTFILES/bootstrap/brew_fonts"

  if [ -f "$FONTS_FILE" ]; then
    while IFS= read -r font; do
      [[ -z "$font" || "$font" =~ ^[[:space:]]*# ]] && continue
      echo "🗑️  Removing font: ${font}"
      brew uninstall --cask "${font}" 2>/dev/null || true
    done <"$FONTS_FILE"
  fi
}

remove_symlinks() {
  echo "🗑️  Removing symlinks..."
  
  # Remove common symlinks
  rm -f "$HOME/.zshrc"
  rm -f "$HOME/.vimrc"
  rm -f "$HOME/.gitconfig"
  
  # Remove any other symlinks that point to dotfiles
  find "$HOME" -maxdepth 1 -type l -exec sh -c 'readlink "$1" | grep -q dotfiles' _ {} \; -delete 2>/dev/null || true
}

uninstall_volta() {
  echo "🗑️  Removing Volta..."
  if [ -d "$HOME/.volta" ]; then
    rm -rf "$HOME/.volta"
  fi
  
  # Remove volta from PATH in shell configs
  sed -i.bak '/VOLTA_HOME/d' "$HOME/.zshrc" 2>/dev/null || true
  sed -i.bak '/volta\/bin/d' "$HOME/.zshrc" 2>/dev/null || true
}

uninstall_zinit() {
  echo "🗑️  Removing Zinit..."
  if [ -d "$HOME/.local/share/zinit" ]; then
    rm -rf "$HOME/.local/share/zinit"
  fi
  
  # Remove zinit cache
  rm -rf "$HOME/.cache/zinit" 2>/dev/null || true
}

remove_project_folders() {
  echo "🗑️  Removing project folders..."
  read -ep "Remove ~/GitHub folder? (y/n) " ANSWER
  if [ "$ANSWER" = "y" ]; then
    rm -rf "$HOME/GitHub"
  fi
}

uninstall_homebrew() {
  echo "🗑️  Removing Homebrew..."
  read -ep "Remove Homebrew completely? This will remove ALL brew packages. (y/n) " ANSWER
  if [ "$ANSWER" = "y" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
  fi
}

restore_shell_defaults() {
  echo "🗑️  Restoring shell defaults..."
  
  # Reset to default zsh if it was changed
  if [ "$SHELL" != "/bin/zsh" ]; then
    chsh -s /bin/zsh
  fi
  
  # Remove custom shell configurations
  if [ -f "$HOME/.zshrc.pre-dotfiles" ]; then
    mv "$HOME/.zshrc.pre-dotfiles" "$HOME/.zshrc"
  else
    rm -f "$HOME/.zshrc"
  fi
}

# Main uninstall sequence
read -ep "Remove NPM packages? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  uninstall_npm_packages
fi

read -ep "Remove Apps? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  uninstall_apps
fi

read -ep "Remove Packages? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  uninstall_packages
fi

read -ep "Remove Fonts? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  uninstall_fonts
fi

read -ep "Remove symlinks? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  remove_symlinks
fi

read -ep "Remove Volta? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  uninstall_volta
fi

read -ep "Remove Zinit? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  uninstall_zinit
fi

read -ep "Remove project folders? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  remove_project_folders
fi

read -ep "Restore shell defaults? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  restore_shell_defaults
fi

read -ep "Remove Homebrew completely? (y/n) " ANSWER
if [ "$ANSWER" = "y" ]; then
  uninstall_homebrew
fi

echo "🧹 Cleaning up..."
brew cleanup 2>/dev/null || true

printf "\\n🦁  Uninstall complete! Please restart your terminal. \\n"