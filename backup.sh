#!/usr/bin/env bash

# Backup existing configurations before installing dotfiles

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "📦 Creating backup at: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

backup_file() {
  local file_path="$1"
  local backup_name="$2"
  
  if [ -f "$file_path" ] || [ -L "$file_path" ]; then
    echo "💾 Backing up: $file_path"
    cp -L "$file_path" "$BACKUP_DIR/$backup_name" 2>/dev/null || true
  fi
}

backup_directory() {
  local dir_path="$1"
  local backup_name="$2"
  
  if [ -d "$dir_path" ]; then
    echo "💾 Backing up directory: $dir_path"
    cp -r "$dir_path" "$BACKUP_DIR/$backup_name" 2>/dev/null || true
  fi
}

# Backup shell configurations
backup_file "$HOME/.zshrc" "zshrc"
backup_file "$HOME/.bashrc" "bashrc"
backup_file "$HOME/.bash_profile" "bash_profile"
backup_file "$HOME/.profile" "profile"

# Backup development configurations
backup_file "$HOME/.vimrc" "vimrc"
backup_file "$HOME/.gitconfig" "gitconfig"
backup_file "$HOME/.gitignore_global" "gitignore_global"

# Backup SSH configurations (if they exist)
backup_directory "$HOME/.ssh" "ssh"

# Backup existing package manager configurations
backup_file "$HOME/.npmrc" "npmrc"
backup_file "$HOME/.yarnrc" "yarnrc"

# Create restore script
cat > "$BACKUP_DIR/restore.sh" << EOF
#!/usr/bin/env bash

# Restore script for dotfiles backup created on $(date)

echo "🔄 Restoring configurations from backup..."

BACKUP_DIR="\$(dirname "\$0")"

restore_file() {
  local backup_name="\$1"
  local target_path="\$2"
  
  if [ -f "\$BACKUP_DIR/\$backup_name" ]; then
    echo "🔄 Restoring: \$target_path"
    cp "\$BACKUP_DIR/\$backup_name" "\$target_path"
  fi
}

restore_directory() {
  local backup_name="\$1"
  local target_path="\$2"
  
  if [ -d "\$BACKUP_DIR/\$backup_name" ]; then
    echo "🔄 Restoring directory: \$target_path"
    rm -rf "\$target_path" 2>/dev/null || true
    cp -r "\$BACKUP_DIR/\$backup_name" "\$target_path"
  fi
}

# Restore files
restore_file "zshrc" "\$HOME/.zshrc"
restore_file "bashrc" "\$HOME/.bashrc"
restore_file "bash_profile" "\$HOME/.bash_profile"
restore_file "profile" "\$HOME/.profile"
restore_file "vimrc" "\$HOME/.vimrc"
restore_file "gitconfig" "\$HOME/.gitconfig"
restore_file "gitignore_global" "\$HOME/.gitignore_global"
restore_file "npmrc" "\$HOME/.npmrc"
restore_file "yarnrc" "\$HOME/.yarnrc"

# Restore directories
restore_directory "ssh" "\$HOME/.ssh"

echo "✅ Restore complete! Please restart your terminal."
EOF

chmod +x "$BACKUP_DIR/restore.sh"

# Log backup location
echo "$BACKUP_DIR" > "$HOME/.dotfiles-last-backup"

echo "✅ Backup complete!"
echo "📍 Backup location: $BACKUP_DIR"
echo "🔄 To restore: $BACKUP_DIR/restore.sh"