#!/bin/bash
# ============================================================
# Terminal Environment Installation Script (No sudo required)
# ============================================================
# This script installs all dependencies from source/git and
# creates symbolic links from the config repo to your home
# directory. Works on restricted servers without sudo access.
# ============================================================

set -e

# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"

echo "🚀 Installing terminal environment configuration..."
echo "   Config directory: $CONFIG_DIR"
echo ""

# Create local bin directory
mkdir -p "$LOCAL_BIN"

# ============================================================
# Install Neovim (AppImage for Linux, brew check for macOS)
# ============================================================
echo "📦 Setting up Neovim..."

if command -v nvim &> /dev/null; then
    echo "   ✓ Neovim already installed"
else
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "   ⚠️  macOS detected. Please install Neovim via: brew install neovim"
    else
        echo "   Downloading Neovim AppImage..."
        NVIM_APPIMAGE="$LOCAL_BIN/nvim.appimage"
        curl -fLo "$NVIM_APPIMAGE" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
        chmod u+x "$NVIM_APPIMAGE"
        
        # Try to extract AppImage (works on most systems)
        if "$NVIM_APPIMAGE" --version &> /dev/null; then
            ln -sf "$NVIM_APPIMAGE" "$LOCAL_BIN/nvim"
            echo "   ✓ Neovim installed via AppImage"
        else
            # If AppImage doesn't work, extract it
            echo "   Extracting AppImage (FUSE not available)..."
            cd "$HOME/.local"
            "$NVIM_APPIMAGE" --appimage-extract &> /dev/null || true
            mv squashfs-root nvim-extracted 2>/dev/null || true
            ln -sf "$HOME/.local/nvim-extracted/usr/bin/nvim" "$LOCAL_BIN/nvim"
            rm -f "$NVIM_APPIMAGE"
            cd "$CONFIG_DIR"
            echo "   ✓ Neovim installed (extracted)"
        fi
    fi
fi

# ============================================================
# Install Tmux from source
# ============================================================
echo "📦 Setting up Tmux..."

if command -v tmux &> /dev/null; then
    echo "   ✓ Tmux already installed"
else
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "   ⚠️  macOS detected. Please install Tmux via: brew install tmux"
    else
        echo "   Building Tmux from source..."
        TMUX_SRC="$HOME/.local/src/tmux"
        mkdir -p "$HOME/.local/src"
        
        if [ ! -d "$TMUX_SRC" ]; then
            git clone --depth=1 https://github.com/tmux/tmux.git "$TMUX_SRC"
        fi
        
        cd "$TMUX_SRC"
        if [ -f "configure" ] || sh autogen.sh 2>/dev/null; then
            ./configure --prefix="$HOME/.local" && make && make install
            echo "   ✓ Tmux installed from source"
        else
            echo "   ⚠️  Could not build Tmux (missing build dependencies)"
            echo "      Try: apt install automake libevent-dev ncurses-dev"
        fi
        cd "$CONFIG_DIR"
    fi
fi

# ============================================================
# Install Node.js via nvm (no sudo required)
# ============================================================
echo "📦 Setting up Node.js..."

export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "   ✓ nvm already installed"
    \. "$NVM_DIR/nvm.sh"
else
    echo "   Installing nvm..."
    git clone --depth=1 https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    \. "$NVM_DIR/nvm.sh"
    echo "   ✓ nvm installed"
fi

# Install Node.js LTS if not available
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | cut -d. -f1 | tr -d 'v')
    if [ "$NODE_VERSION" -ge 17 ]; then
        echo "   ✓ Node.js $(node --version) already installed"
    else
        echo "   Installing Node.js LTS..."
        nvm install --lts
        nvm use --lts
        echo "   ✓ Node.js $(node --version) installed"
    fi
else
    echo "   Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    echo "   ✓ Node.js $(node --version) installed"
fi

# ============================================================
# Install Zsh (check if available)
# ============================================================
echo "📦 Checking Zsh..."

if command -v zsh &> /dev/null; then
    echo "   ✓ Zsh already available"
else
    echo "   ⚠️  Zsh not found. It usually requires sudo to install."
    echo "      Your shell will remain as: $SHELL"
fi

# ============================================================
# Create symbolic links for Bash (for login persistence)
# ============================================================
echo "📦 Setting up Bash profile (for login persistence)..."

# Backup existing files
if [ -f "$HOME/.bash_profile" ] && [ ! -L "$HOME/.bash_profile" ]; then
    echo "   Backing up existing .bash_profile to .bash_profile.backup"
    mv "$HOME/.bash_profile" "$HOME/.bash_profile.backup"
fi
if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
    echo "   Backing up existing .bashrc to .bashrc.backup"
    mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
fi
if [ -f "$HOME/.profile" ] && [ ! -L "$HOME/.profile" ]; then
    echo "   Backing up existing .profile to .profile.backup"
    mv "$HOME/.profile" "$HOME/.profile.backup"
fi

# Create symbolic links
ln -sf "$CONFIG_DIR/bash/.bash_profile" "$HOME/.bash_profile"
ln -sf "$CONFIG_DIR/bash/.bashrc" "$HOME/.bashrc"
ln -sf "$CONFIG_DIR/bash/.profile" "$HOME/.profile"
echo "   ✓ Bash profile linked (ensures settings persist on login)"

# ============================================================
# Create symbolic links for Zsh
# ============================================================
echo "📦 Setting up Zsh configuration..."

# Backup existing files
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "   Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
if [ -f "$HOME/.zprofile" ] && [ ! -L "$HOME/.zprofile" ]; then
    echo "   Backing up existing .zprofile to .zprofile.backup"
    mv "$HOME/.zprofile" "$HOME/.zprofile.backup"
fi
if [ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
    echo "   Backing up existing .p10k.zsh to .p10k.zsh.backup"
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup"
fi

# Create symbolic links
ln -sf "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$CONFIG_DIR/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
echo "   ✓ Zsh configuration linked"

# ============================================================
# Install Powerlevel10k
# ============================================================
echo "📦 Setting up Powerlevel10k..."

if [ ! -d "$HOME/.p10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.p10k"
    echo "   ✓ Powerlevel10k installed"
else
    echo "   ✓ Powerlevel10k already installed"
fi

# ============================================================
# Create symbolic links for Tmux
# ============================================================
echo "📦 Setting up Tmux configuration..."

if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    echo "   Backing up existing .tmux.conf to .tmux.conf.backup"
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
fi

ln -sf "$CONFIG_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
echo "   ✓ Tmux configuration linked"

# ============================================================
# Create symbolic links for Neovim
# ============================================================
echo "📦 Setting up Neovim configuration..."

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
echo "📦 Setting up vim-plug..."

PLUG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
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

# Source nvm to ensure nvim can find node
export PATH="$LOCAL_BIN:$PATH"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
fi

if command -v nvim &> /dev/null; then
    nvim --headless +PlugInstall +qall 2>/dev/null || true
    echo "   ✓ Neovim plugins installed"
else
    echo "   ⚠️  Neovim not found, skipping plugin installation"
fi

# ============================================================
# Update PATH in .zshrc if needed
# ============================================================
echo "📦 Ensuring PATH configuration..."

# The .zshrc already includes $HOME/.local/bin in PATH
echo "   ✓ PATH configuration ready"

# ============================================================
# Check and suggest default shell change
# ============================================================
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "zsh" ] && command -v zsh &> /dev/null; then
    echo ""
    echo "💡 Optional: Change default shell to Zsh for best experience"
    echo "   Your current shell: $SHELL"
    echo "   To change to Zsh permanently, run:"
    echo "      chsh -s \$(which zsh)"
    echo ""
    echo "   Note: Your settings will still work on next login thanks to"
    echo "         .bash_profile, but Zsh provides the best experience!"
fi

# ============================================================
# Done
# ============================================================
echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Log out and log back in, OR restart your terminal, OR run:"
echo "      source ~/.profile"
echo "      (or 'source ~/.zshrc' if already using zsh)"
echo ""
echo "   2. For GitHub Copilot, run in Neovim:"
echo "      :Copilot setup"
echo ""
echo "🔧 Installed locations:"
echo "   - Neovim:      $LOCAL_BIN/nvim"
echo "   - Node.js:     via nvm (~/.nvm)"
echo "   - Powerlevel10k: ~/.p10k"
echo ""
echo "🔒 Settings persistence:"
echo "   ✓ .profile and .bash_profile configured - settings will persist after logout!"
echo "   ✓ .zprofile configured for zsh login shells"
echo "   ✓ Auto-switches to Zsh if available"
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
