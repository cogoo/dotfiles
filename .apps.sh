#!/bin/sh

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update 

#Packages

PACAKAGES=(
	git
	npm
	nvm
	tmux
	tree
	vim
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

#Apps

echo "Installing cask"
brew install caskroom/cask/brew-cask

CASKS=(
	station
	visual-studio-code
	firefox-developer-edition
	google-chrome
	iterm2
	insomnia
	docker
	virtual-box
	dash
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

#Fonts

echo "Installing fonts..."
brew tap caskroom/fonts

FONTS=(
	font-fira-code
)

brew cask install ${FONTS[@]}

#Node

echo "Installing Global NPM packages..."
NPM_GLOBALS=(
	@angular-cli
	@angular-devkit/schematics-cli
	@nestjs/cli
	@nrwl/schematics
	commitizen
	git-cz
	np
	yarn
)

npm i -g ${NPM_GLOBALS[@]}


echo "Creating folder structure..."
[[ ! -d LocalHost ]] && mkdir -p LocalHost/GitHub

echo "Bootstrapping complete"
