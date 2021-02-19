#!/usr/bin/env bash
SNIPPETS_DIR="$HOME/.dotfiles/vscode/snippets"

if [ -d "$SNIPPETS_DIR" ]; then
  printf "🎙  Copying VS code snippets  \n"
  cp -R "$SNIPPETS_DIR" "$HOME/Library/Application Support/Code/User"
fi
