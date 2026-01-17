#!/bin/bash
# ============================================================
# Terminal Environment Installation Script
# ============================================================
# This script creates symbolic links from the config repo to
# your home directory. This way, you can update settings by
# simply running 'git pull'.
# ============================================================

set -e

# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing terminal environment configuration..."
echo "   Config directory: $CONFIG_DIR"
echo ""

# ============================================================
# Create symbolic links for Zsh
# ============================================================
echo "📦 Setting up Zsh..."

# Backup existing files
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "   Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
if [ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
    echo "   Backing up existing .p10k.zsh to .p10k.zsh.backup"
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup"
fi

# Create symbolic links
ln -sf "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
echo "   ✓ Zsh configuration linked"

# ============================================================
# Install Powerlevel10k
# ============================================================
if [ ! -d "$HOME/.p10k" ]; then
    echo "📦 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.p10k"
    echo "   ✓ Powerlevel10k installed"
else
    echo "   ✓ Powerlevel10k already installed"
fi

# ============================================================
# Create symbolic links for Tmux
# ============================================================
echo "📦 Setting up Tmux..."

if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    echo "   Backing up existing .tmux.conf to .tmux.conf.backup"
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
fi

ln -sf "$CONFIG_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
echo "   ✓ Tmux configuration linked"

# ============================================================
# Create symbolic links for Neovim
# ============================================================
echo "📦 Setting up Neovim..."

mkdir -p "$HOME/.config"

if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    echo "   Backing up existing nvim config to nvim.backup"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
fi

ln -sf "$CONFIG_DIR/nvim" "$HOME/.config/nvim"
echo "   ✓ Neovim configuration linked"

# ============================================================
# Install vim-plug
# ============================================================
PLUG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
    echo "📦 Installing vim-plug..."
    curl -fLo "$PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "   ✓ vim-plug installed"
else
    echo "   ✓ vim-plug already installed"
fi

# ============================================================
# Install Neovim plugins
# ============================================================
echo "📦 Installing Neovim plugins..."
nvim --headless +PlugInstall +qall 2>/dev/null || true
echo "   ✓ Neovim plugins installed"

# ============================================================
# Done
# ============================================================
echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. For GitHub Copilot, run in Neovim: :Copilot setup"
echo "   3. Make sure Node.js 17+ is installed for Copilot"
echo ""
echo "🎹 Quick reference:"
echo "   Neovim:"
echo "     - <Ctrl+n>     Toggle file explorer (NERDTree)"
echo "     - <Space+w>    Save file"
echo "     - <Space+q>    Quit"
echo "   Tmux:"
echo "     - <Ctrl+a |>   Split vertically"
echo "     - <Ctrl+a ->   Split horizontally"
echo "     - <Ctrl+a r>   Reload config"
echo ""
