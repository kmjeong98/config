#!/bin/bash

CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp ~/.zshrc "$CONFIG/zsh/.zshrc"
cp ~/.tmux.conf "$CONFIG/tmux/.tmux.conf"
rsync -a --delete ~/.config/nvim/ "$CONFIG/nvim/"

cd "$CONFIG"
git add .
git commit -m "Update from $(hostname)"
git push
