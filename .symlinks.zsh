#!/usr/bin/env bash

echo "🔗 Create Symbolic Links ... \n"

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing

FILES_TO_SYMLINK=(`find . -type f -maxdepth 1 -name ".*" -not -name .DS_Store -not -name .git -not -name .osx | sed -e 's|//|/|' | sed -e 's|./.|.|'`)

for i in ${FILES_TO_SYMLINK[@]}
do
  echo "📦 Creating symbolic link for: ${i}"
  # Create Symbolic link for aliases
  ln -s ~/.dotfiles/${i} ~/${i}
done
