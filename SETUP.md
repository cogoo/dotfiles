# 🚀 Fresh Mac Setup Guide

This guide walks you through setting up your dotfiles on a brand new Mac.

## 📋 Prerequisites

**Required for brand new Mac:**
- macOS (any recent version)
- Internet connection
- Administrator access

**That's it!** The bootstrap handles all other dependencies.

## 🏃‍♂️ Quick Start

### 1. Clone the Repository
```bash
# Clone to your home directory
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**If Git is not installed:** Use the GitHub download ZIP option and extract to `~/dotfiles`

### 2. Run the Setup
```bash
# Interactive setup (recommended for first time)
make install

# Or non-interactive setup
make install-auto
```

## 🔧 What Happens During Setup

### Automatic Dependencies
The bootstrap automatically installs:
1. **Xcode Command Line Tools** (includes Git, make, etc.)
2. **Homebrew** (package manager)
3. **All development tools** (Node.js, Rust, etc.)

### Manual Steps Required
- **Xcode Tools**: You'll see a popup to install - click "Install" and wait
- **Admin Password**: Required for system modifications
- **App Installations**: Some apps may require additional permissions

## 🔄 Recovery & Resume

If the setup fails at any point:

```bash
# Resume from where it failed
make install-recovery

# Check current progress
make status

# Start completely fresh
rm -rf ~/.dotfiles-state
make install
```

## 📊 Available Commands

```bash
make help              # Show all available commands
make install          # Interactive installation
make install-auto     # Non-interactive installation
make install-recovery # Resume from failure
make status           # Show progress and last run info
make backup           # Backup existing configurations
make restore          # Restore from backup
make update           # Update all installed programs
make uninstall        # Complete removal
```

## ⚠️ Troubleshooting

### "Command not found: make"
Xcode Command Line Tools not installed yet. Use:
```bash
./bootstrap.sh
```

### "Permission denied"
Make scripts executable:
```bash
chmod +x bootstrap.sh bootstrap/install.sh
```

### "DOTFILES variable not set"
The scripts should set this automatically. If not:
```bash
export DOTFILES="$HOME/dotfiles"
```

### Fresh Start
If something goes wrong, you can always start over:
```bash
# Remove all state and start fresh
rm -rf ~/.dotfiles-state ~/.dotfiles-backup-*
make uninstall  # If you want to remove everything
make install    # Fresh installation
```

## 🎯 First Time Setup Checklist

- [ ] Clone repository to `~/dotfiles`
- [ ] Run `make install` 
- [ ] Click "Install" when Xcode tools popup appears
- [ ] Enter admin password when prompted
- [ ] Wait for all steps to complete
- [ ] Restart terminal
- [ ] Verify setup with `make status`

## 📱 Platform Notes

### Apple Silicon Macs (M1/M2/M3)
- Homebrew installs to `/opt/homebrew`
- Rosetta 2 installation is optional (for Intel app compatibility)

### Intel Macs
- Homebrew installs to `/usr/local`
- No Rosetta needed

The bootstrap automatically detects your architecture and handles both correctly.

## 🆘 Getting Help

If you encounter issues:
1. Check `make status` for current progress
2. Look for error messages in the terminal output
3. Try `make install-recovery` to resume
4. For complete reset: `rm -rf ~/.dotfiles-state && make install`

Your dotfiles are now set up with full recovery capabilities! 🎉