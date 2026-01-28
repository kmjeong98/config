#!/bin/bash
# ============================================================
# Terminal Environment Installation Script
# ============================================================
# This script installs all dependencies and creates symbolic
# links from the config repo to your home directory.
# If sudo is available, it will be used for system packages.
# ============================================================

set -e

# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"

# ============================================================
# Detect sudo availability
# ============================================================
SUDO=""
HAS_SUDO=false
if sudo -n true 2>/dev/null; then
    HAS_SUDO=true
    SUDO="sudo"
    echo "🔐 sudo 권한 감지됨 - 시스템 패키지로 설치합니다."
elif sudo -v 2>/dev/null; then
    HAS_SUDO=true
    SUDO="sudo"
    echo "🔐 sudo 권한 감지됨 - 시스템 패키지로 설치합니다."
else
    echo "🔓 sudo 권한 없음 - 사용자 디렉토리에 설치합니다."
fi
echo ""

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
        if command -v brew &> /dev/null; then
            echo "   Installing Neovim via Homebrew..."
            brew install neovim
            echo "   ✓ Neovim installed via Homebrew"
        else
            echo "   ⚠️  Homebrew not found. Please install it first: https://brew.sh"
        fi
    elif [ "$HAS_SUDO" = true ]; then
        echo "   Installing Neovim via apt..."
        $SUDO apt update && $SUDO apt install -y neovim
        echo "   ✓ Neovim installed via apt"
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
        if command -v brew &> /dev/null; then
            echo "   Installing Tmux via Homebrew..."
            brew install tmux
            echo "   ✓ Tmux installed via Homebrew"
        else
            echo "   ⚠️  Homebrew not found. Please install it first: https://brew.sh"
        fi
    elif [ "$HAS_SUDO" = true ]; then
        echo "   Installing Tmux via apt..."
        $SUDO apt update && $SUDO apt install -y tmux
        echo "   ✓ Tmux installed via apt"
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

ZSH_AVAILABLE=false
if command -v zsh &> /dev/null; then
    echo "   ✓ Zsh already available"
    ZSH_AVAILABLE=true
else
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS usually has zsh pre-installed, but if not:
        if command -v brew &> /dev/null; then
            echo "   Installing Zsh via Homebrew..."
            brew install zsh
            echo "   ✓ Zsh installed via Homebrew"
            ZSH_AVAILABLE=true
        else
            echo "   ⚠️  Homebrew not found. Please install it first: https://brew.sh"
        fi
    elif [ "$HAS_SUDO" = true ]; then
        echo "   Installing Zsh via apt..."
        $SUDO apt update && $SUDO apt install -y zsh
        echo "   ✓ Zsh installed via apt"
        ZSH_AVAILABLE=true
    else
        echo "   ⚠️  Zsh not found. It usually requires sudo to install."
        echo "      Skipping Zsh-specific configuration."
        echo "      Your shell will remain as: $SHELL"
    fi
fi

# ============================================================
# Create symbolic links for Zsh (only if Zsh is available)
# ============================================================
if [ "$ZSH_AVAILABLE" = true ]; then
    echo "📦 Setting up Zsh configuration..."

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
    echo "📦 Setting up Powerlevel10k..."

    if [ ! -d "$HOME/.p10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.p10k"
        echo "   ✓ Powerlevel10k installed"
    else
        echo "   ✓ Powerlevel10k already installed"
    fi
else
    echo "📦 Skipping Zsh configuration (Zsh not installed)..."
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
# Done
# ============================================================
echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
if [ "$ZSH_AVAILABLE" = true ]; then
    echo "   1. Restart your terminal or run:"
    echo "      source ~/.zshrc"
else
    echo "   1. To use the full configuration, install Zsh first:"
    echo "      sudo apt install zsh   # Then re-run this script"
    echo "   Or just restart your terminal to use Neovim and Tmux."
fi
echo ""
echo "   2. For GitHub Copilot, run in Neovim:"
echo "      :Copilot setup"
echo ""
echo "🔧 Installed locations:"
echo "   - Neovim:      $LOCAL_BIN/nvim"
echo "   - Node.js:     via nvm (~/.nvm)"
echo "   - Powerlevel10k: ~/.p10k"
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
