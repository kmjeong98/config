#!/bin/bash
set -e

CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Update Zsh and powerlevel10k config
cp "$HOME/.zshrc" "$CONFIG/zsh/.zshrc"
cp "$HOME/.p10k.zsh" "$CONFIG/zsh/.p10k.zsh"

# Update Tmux config
cp "$HOME/.tmux.conf" "$CONFIG/tmux/.tmux.conf"

# Update Neovim config
mkdir -p "$CONFIG/nvim"
rsync -a --delete "$HOME/.config/nvim/" "$CONFIG/nvim/"

# Git commit and push
cd "$CONFIG"
git add .
git commit -m "Update from $(hostname)"
git push

