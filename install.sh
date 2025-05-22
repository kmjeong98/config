#!/bin/bash
set -e

CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy Zsh and p10k config
cp "$CONFIG/zsh/.zshrc" "$HOME/.zshrc"
cp "$CONFIG/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Copy Tmux config
cp "$CONFIG/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Copy Neovim config
mkdir -p "$HOME/.config/nvim"
cp -r "$CONFIG/nvim/"* "$HOME/.config/nvim/"

# Install powerlevel10k into ~/.p10k
if [ ! -d "$HOME/.p10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.p10k"
fi

# Remove the config directory itself
cd ~
rm -rf "$CONFIG"

