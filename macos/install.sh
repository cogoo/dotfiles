#!/bin/sh

echo "👀 Setting mac preferences"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Launch Services                                                             #
###############################################################################

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

###############################################################################
# Energy saving                                                               #
###############################################################################

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Disable screen saver
defaults write com.apple.screensaver idleTime 0

# Sleep the display after 60 minutes
sudo pmset -a displaysleep 60

###############################################################################
# ITerm                                                                       #
###############################################################################

# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.dotfiles/iterm"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Set dock orientation
defaults write com.apple.dock orientation right

# Set dock tilesize
defaults write com.apple.dock tilesize 24

# Install Xcode cli
xcode-select --install

# Enable xcode cli tools
sudo xcode-select --switch /Library/Developer/CommandLineTools

################################################################################
# Bluetooth Settings                                                           #
################################################################################
sudo defaults write bluetoothaudiod "Enable AAC codec" -bool true
