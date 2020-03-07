#!/bin/sh

EXTENSIONS_FILE="$HOME/.dotfiles/vscode/extensions"
SETTINGS_FILE="$HOME/.dotfiles/vscode/settings.json"
KEYBINDINGS_FILE="$HOME/.dotfiles/vscode/keybindings.json"
SNIPPETS_DIR="$HOME/.dotfiles/vscode/snippets"

if [ -f "$EXTENSIONS_FILE" ]; then
	echo "🎙  Installing VS code extensions \\n"
	while IFS= read -r extension
	do
	code --install-extension "$extension"
	done < "$EXTENSIONS_FILE"
fi

if [ -f "$SETTINGS_FILE" ]; then
	echo "🎙  Copying VS code settings  \\n"
	cp "$SETTINGS_FILE" "$HOME/Library/Application Support/Code/User/settings.json"
fi

if [ -f "$KEYBINDINGS_FILE" ]; then
	echo "🎙  Copying VS code keybindings  \\n"
	cp "$KEYBINDINGS_FILE" "$HOME/Library/Application Support/Code/User/keybindings.json"
fi

if [ -d "$SNIPPETS_DIR" ]; then
	echo "🎙  Copying VS code snippets  \\n"
	cp -R "$SNIPPETS_DIR" "$HOME/Library/Application Support/Code/User"
fi
