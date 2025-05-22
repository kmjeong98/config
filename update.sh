#!/bin/bash

CONFIG="$HOME/config"

cp ~/.zshrc "$CONFIG/zsh/.zshrc"
cp ~/.tmux.conf "$DOTFILES/tmux/.tmux.conf"
rsync -a --delete ~/.config/nvim/ "$DOTFILES/nvim/"

cd "$DOTFILES"
git add .
git commit -m "Update from $(hostname)"
git push

