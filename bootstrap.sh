#!/usr/bin/env bash

cd "$HOME/dotfiles" || exit

# Set DOTFILES environment variable
export DOTFILES="$HOME/dotfiles"

# Load state management
source ./state.sh

# Check for recovery mode or non-interactive mode
NON_INTERACTIVE=false
RECOVERY_MODE=false

if [ "$1" = "--recovery" ] || [ "$1" = "-r" ]; then
  RECOVERY_MODE=true
  echo "🔄 Running in recovery mode"
elif [ "$1" = "--yes" ] || [ "$1" = "-y" ]; then
  NON_INTERACTIVE=true
  echo "🤖 Running in non-interactive mode"
fi

# Initialize state and check for existing progress
init_state
next_step=$(get_next_step)

if [ "$next_step" != "complete" ] && [ "$(get_completed_steps)" -gt 0 ]; then
  echo ""
  show_progress
  echo ""
  
  if [ "$RECOVERY_MODE" = false ]; then
    read -ep "🔄 Previous bootstrap detected. Continue from where it left off? (y/n) " CONTINUE_ANSWER
    if [ "$CONTINUE_ANSWER" = "y" ]; then
      RECOVERY_MODE=true
    else
      read -ep "🗑️  Start fresh? This will reset progress. (y/n) " RESET_ANSWER
      if [ "$RESET_ANSWER" = "y" ]; then
        cleanup_state
        init_state
      else
        echo "❌ Bootstrap cancelled"
        exit 0
      fi
    fi
  fi
fi

# Check for version updates
if check_version_updates; then
  echo ""
  echo "📋 Version updates detected in versions.txt"
  show_version_diff
  echo ""
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

# Skip if in recovery mode - but only if git is available
if [ "$RECOVERY_MODE" = false ] && command -v git &>/dev/null; then
  ANSWER=$(ask_or_default "👌🏾  Get latest version? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    git pull origin master
  fi
elif [ "$RECOVERY_MODE" = false ]; then
  echo "⚠️  Git not available yet, skipping update..."
fi

ANSWER=$(ask_or_default "Install rosetta? (y/n)" "n")
if [ "$ANSWER" = "y" ]; then
  softwareupdate --install-rosetta
fi

#set default terminal to zsh
#chsh -s /bin/zsh

# Skip if recovery mode and this step is complete
if [ "$RECOVERY_MODE" = false ] || ! is_step_complete "bootstrap"; then
  ANSWER=$(ask_or_default "🏃🏽‍♂️  Run bootstrap? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    if [ "$NON_INTERACTIVE" = true ]; then
      ./bootstrap/install.sh --yes
    else
      ./bootstrap/install.sh
    fi
    
    if [ $? -eq 0 ]; then
      mark_step_complete "bootstrap"
    else
      echo "❌ Bootstrap failed. Run './bootstrap.sh --recovery' to continue from this step."
      exit 1
    fi
  fi
else
  echo "✅ Bootstrap already completed, skipping..."
fi

ANSWER=$(ask_or_default "🎙  Install Zinit Plugins? (y/n)" "y")
if [ "$ANSWER" = "y" ]; then
  # Zinit installs automatically when first loaded
  echo "✅ Zinit plugins will be installed on first shell load"
fi

# Skip if recovery mode and this step is complete
if [ "$RECOVERY_MODE" = false ] || ! is_step_complete "backup"; then
  ANSWER=$(ask_or_default "💾  Create backup? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    ./backup.sh
    
    if [ $? -eq 0 ]; then
      mark_step_complete "backup"
    else
      echo "❌ Backup failed. Run './bootstrap.sh --recovery' to continue from this step."
      exit 1
    fi
  fi
else
  echo "✅ Backup already completed, skipping..."
fi

# Skip if recovery mode and this step is complete
if [ "$RECOVERY_MODE" = false ] || ! is_step_complete "symlinks"; then
  ANSWER=$(ask_or_default "⛓  Register symlinks? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    ./symlinks/install.sh
    
    if [ $? -eq 0 ]; then
      mark_step_complete "symlinks"
    else
      echo "❌ Symlinks failed. Run './bootstrap.sh --recovery' to continue from this step."
      exit 1
    fi
  fi
else
  echo "✅ Symlinks already completed, skipping..."
fi

# Skip if recovery mode and this step is complete
if [ "$RECOVERY_MODE" = false ] || ! is_step_complete "macos_defaults"; then
  ANSWER=$(ask_or_default "🕶  Set Mac defaults? (y/n)" "y")
  if [ "$ANSWER" = "y" ]; then
    ./macos/install.sh
    
    if [ $? -eq 0 ]; then
      mark_step_complete "macos_defaults"
    else
      echo "❌ Mac defaults failed. Run './bootstrap.sh --recovery' to continue from this step."
      exit 1
    fi
  fi
else
  echo "✅ Mac defaults already completed, skipping..."
fi

# Final steps and cleanup
echo ""
echo "🎉 Bootstrap completed successfully!"

# Record last run time and save version state
record_last_run
save_version_state

# Show final status
echo ""
show_progress

# Clean up state files
echo ""
cleanup_state

echo ""
echo "✨ Setup complete! Please restart your terminal to apply all changes."
echo "📋 Run 'make help' to see available commands."