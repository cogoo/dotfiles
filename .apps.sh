#!/bin/sh

#set -ex 
echo "🚀 Starting bootstrap"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update 

#Packages

PACKAGES=(
	git
	npm
	nvm
	tmux
	tree
	vim
)

echo "📦 Installing packages..."
for pkg in ${PACKAGES[@]}; do
  	echo "📦 Installing: ${pkg}"
	brew install ${pkg}
done

echo "🛀🏽 Cleaning up..."
brew cleanup

#Apps
brew tap homebrew/cask-versions

CASKS=(
	station
	visual-studio-code
	firefox-developer-edition
	iterm2
	insomnia
	google-chrome
	docker
	virtualbox
	dash
)


for app in ${CASKS[@]}; do
	echo "📦 Installing ${app}"
	brew cask install ${app}
done

#Fonts

echo "📦 Installing fonts..."
brew tap caskroom/fonts

FONTS=(
	font-fira-code
)

brew cask install ${FONTS[@]}

#Node

NPM_GLOBALS=(
	@angular/cli
	@angular-devkit/schematics-cli
	@nestjs/cli
	@nrwl/schematics
	commitizen
	nvm
	git-cz
	np
	yarn
)

echo "📦 Installing Global NPM packages..."
for pkg in ${NPM_GLOBALS[@]}
	do npm i -g ${pkg}
done


echo "Creating folder structure..."
[[ ! -d LocalHost ]] && mkdir -p LocalHost/GitHub

echo "Bootstrapping complete"
