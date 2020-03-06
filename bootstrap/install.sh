#!/bin/sh

#set -ex

echo "🚀 Starting bootstrap"

# Ask for the administrator password upfront
sudo -v

PACKAGES=(
	git
	tmux
	tree
	vim
	pyenv
	pyenv-virtualenv
	npx
	starship
	exa
	tmuxinator
	fastlane
)

CASKS=(
	visual-studio-code
	firefox-developer-edition
	iterm2
	insomnia
	google-cloud-sdk
	obinslab-starter
	docker
	virtualbox
	dash
	alfred
	java
	google-chrome
)

FONTS=(
	font-fira-code
)

NPM_GLOBALS=(
	@angular/cli
	@angular-devkit/schematics-cli
	@nestjs/cli
	@nrwl/schematics
	commitizen
	git-cz
	np
	yarn
)

GEMS=(
	rest-client
)

install_homebrew() {
	if test $(which brew); then
		echo "😊 Homebrew installed..."
		return 0
	fi

	echo "😎 Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

update_homebrew() {
	brew update
}

#TODO: refactor to check if ~/.nvm folder exists
install_nvm() {
	echo "😎 Installing NVM..."
	export NVM_DIR="$HOME/.nvm" && (
		git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
		cd "$NVM_DIR"
		git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
	) && \. "$NVM_DIR/nvm.sh"
}

setup_node() {
	echo "😎 Setting up Node w/ NVM ..."
	if [ -z "$NVM_DIR" ]; then
		# NVM_DIR is undefined, so it's not been initialised
		NVM_DIR="$HOME/.nvm"
	fi

	. "$NVM_DIR/nvm.sh"

	nvm install lts/dubnium
	nvm alias default lts/dubnium
}

install_rvm() {
	echo "😎 Installing RVM..."
	ruby -e "$(curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles)"
}

cleanup_homebrew() {
	echo "🛀🏽 Cleaning up..."
	brew cleanup
}

install_packages() {
	echo "📦 Installing packages..."
	for pkg in ${PACKAGES[@]}; do
		# skip exisiting packages
		command -v "${pkg}" &>/dev/null && continue

		echo "📦 Installing: ${pkg}"
		brew install ${pkg}
	done
}

install_apps() {
	brew tap homebrew/cask-versions

	#TODO: check if app already exists
	for app in ${CASKS[@]}; do
		echo "📦 Installing ${app}"
		brew cask install ${app}
	done
}

install_fonts() {
	echo "📦 Installing fonts..."
	brew tap homebrew/cask-fonts
	brew cask install ${FONTS[@]}
}

install_npm_packages() {
	echo "📦 Installing Global NPM packages..."
	# check if package exists
	for pkg in ${NPM_GLOBALS[@]}; do
		npm i -g ${pkg}
	done
}

install_antibody() {
	brew tap | grep -q 'getantibody/tap' || brew tap getantibody/tap
	brew install antibody
}

install_tmuxinator() {
	# Req: >= ruby@2.4.6
	echo "📦 Installing TMUXinator..."
	gem install tmuxinator
}

setup_project_folders() {
	cd ~
	echo "Creating folder structure..."
	[[ ! -d LocalHost ]] && mkdir -p LocalHost/GitHub
	[[ ! -d LocalHost ]] && mkdir -p LocalHost/Global
}

install_flutter(){
	cd "$HOME/LocalHost/Global"
	git clone https://github.com/flutter/flutter.git

	# Install cocoapods
	gem install cocoapods
}

install_homebrew
update_homebrew
install_rvm
install_packages
install_apps
install_fonts
install_nvm
setup_node
install_npm_packages
install_tmuxinator
install_antibody
setup_project_folders
install_flutter
#cleanup_homebrew

echo "Bootstrapping complete"
