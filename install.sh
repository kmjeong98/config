#!/bin/bash
set -e

CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy Zsh config
cp "$CONFIG/zsh/.zshrc" "$HOME/.zshrc"

# Copy Tmux config
cp "$CONFIG/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Copy Neovim config
mkdir -p "$HOME/.config/nvim"
cp -r "$CONFIG/nvim/"* "$HOME/.config/nvim/"

# Remove the config directory itself
cd ~
rm -rf "$CONFIG"

