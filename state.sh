#!/usr/bin/env bash

# Bootstrap state management
# Tracks progress and enables recovery from failed steps

STATE_DIR="$HOME/.dotfiles-state"
STATE_FILE="$STATE_DIR/bootstrap.state"
LAST_RUN_FILE="$STATE_DIR/last-run.txt"
VERSION_STATE_FILE="$STATE_DIR/versions.state"

# Bootstrap steps in order
BOOTSTRAP_STEPS=(
  "xcode_tools"
  "homebrew"
  "homebrew_update"
  "packages"
  "apps"
  "fonts"
  "volta"
  "node_setup"
  "npm_packages"
  "zinit"
  "project_folders"
  "flutter"
  "symlinks"
  "macos_defaults"
)

init_state() {
  mkdir -p "$STATE_DIR"
  if [ ! -f "$STATE_FILE" ]; then
    echo "# Bootstrap state file - tracks completed steps" > "$STATE_FILE"
    echo "# Format: step_name=timestamp" >> "$STATE_FILE"
  fi
}

mark_step_complete() {
  local step="$1"
  local timestamp=$(date +%Y%m%d-%H%M%S)
  
  init_state
  
  # Remove existing entry for this step
  grep -v "^${step}=" "$STATE_FILE" > "$STATE_FILE.tmp" 2>/dev/null || true
  mv "$STATE_FILE.tmp" "$STATE_FILE"
  
  # Add completed step
  echo "${step}=${timestamp}" >> "$STATE_FILE"
  echo "✅ Marked step '${step}' as complete"
}

is_step_complete() {
  local step="$1"
  
  if [ ! -f "$STATE_FILE" ]; then
    return 1
  fi
  
  grep -q "^${step}=" "$STATE_FILE"
}

get_next_step() {
  init_state
  
  for step in "${BOOTSTRAP_STEPS[@]}"; do
    if ! is_step_complete "$step"; then
      echo "$step"
      return 0
    fi
  done
  
  # All steps complete
  echo "complete"
}

get_completed_steps() {
  if [ ! -f "$STATE_FILE" ]; then
    echo "0"
    return
  fi
  
  grep -c "^[^#].*=" "$STATE_FILE" 2>/dev/null || echo "0"
}

show_progress() {
  local completed=$(get_completed_steps)
  local total=${#BOOTSTRAP_STEPS[@]}
  local next_step=$(get_next_step)
  
  echo "📊 Bootstrap Progress: $completed/$total steps complete"
  
  if [ "$next_step" = "complete" ]; then
    echo "🎉 All steps completed!"
  else
    echo "⏭️  Next step: $next_step"
  fi
  
  if [ "$completed" -gt 0 ]; then
    echo "✅ Completed steps:"
    while IFS='=' read -r step timestamp; do
      [[ "$step" =~ ^[[:space:]]*# ]] && continue
      [[ -z "$step" ]] && continue
      echo "   - $step ($(date -j -f '%Y%m%d-%H%M%S' "$timestamp" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "$timestamp"))"
    done < "$STATE_FILE"
  fi
}

cleanup_state() {
  echo "🧹 Cleaning up bootstrap state..."
  rm -rf "$STATE_DIR"
}

record_last_run() {
  init_state
  echo "$(date '+%Y-%m-%d %H:%M:%S')" > "$LAST_RUN_FILE"
}

get_last_run() {
  if [ -f "$LAST_RUN_FILE" ]; then
    cat "$LAST_RUN_FILE"
  else
    echo "Never run"
  fi
}

save_version_state() {
  init_state
  local versions_file="$DOTFILES/versions.txt"
  
  if [ -f "$versions_file" ]; then
    cp "$versions_file" "$VERSION_STATE_FILE"
  fi
}

check_version_updates() {
  local versions_file="$DOTFILES/versions.txt"
  
  if [ ! -f "$VERSION_STATE_FILE" ] || [ ! -f "$versions_file" ]; then
    return 1  # No previous state or current versions file
  fi
  
  # Compare current versions.txt with saved state
  if ! diff -q "$versions_file" "$VERSION_STATE_FILE" >/dev/null 2>&1; then
    return 0  # Files differ - updates available
  fi
  
  return 1  # No updates
}

show_version_diff() {
  local versions_file="$DOTFILES/versions.txt"
  
  if [ -f "$VERSION_STATE_FILE" ] && [ -f "$versions_file" ]; then
    echo "📋 Version changes detected:"
    diff "$VERSION_STATE_FILE" "$versions_file" | grep '^[<>]' | while read line; do
      if [[ "$line" =~ ^\< ]]; then
        echo "   - ${line#< }"
      elif [[ "$line" =~ ^\> ]]; then
        echo "   + ${line#> }"
      fi
    done
  fi
}