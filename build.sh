#!/bin/bash
# build.sh: Script to build & install Neovim/tmux to ~/.local/bin,
#           install oh-my-zsh, link dotfiles, and set default shell to zsh.

set -e  # Exit on error

# 0) ENVIRONMENT & PATHS
HOME_DIR="$HOME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_BIN="$HOME_DIR/.local/bin"

echo "============================================"
echo "=== Start local installation & setup...  ==="
echo "============================================"

# -----------------------------
# 1) Neovim build & install
# -----------------------------
if ! command -v nvim >/dev/null 2>&1; then
  echo "[Neovim] Not found. Cloning & building from source..."
  NEOVIM_SRC="$HOME_DIR/neovim_src"
  if [ ! -d "$NEOVIM_SRC" ]; then
    git clone https://github.com/neovim/neovim.git "$NEOVIM_SRC"
  fi
  cd "$NEOVIM_SRC"
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$HOME_DIR/.local"
  make install
  echo "[Neovim] Installed to $HOME_DIR/.local/bin (nvim)."
  # Remove source dir
  cd "$SCRIPT_DIR"
  rm -rf "$NEOVIM_SRC"
else
  echo "[Neovim] Already installed, skipping build."
fi

# -----------------------------
# 2) tmux build & install
# -----------------------------
if ! command -v tmux >/dev/null 2>&1; then
  echo "[tmux] Not found. Cloning & building from source..."
  TMUX_SRC="$HOME_DIR/tmux_src"
  if [ ! -d "$TMUX_SRC" ]; then
    git clone https://github.com/tmux/tmux.git "$TMUX_SRC"
  fi
  cd "$TMUX_SRC"
  sh autogen.sh
  ./configure --prefix="$HOME_DIR/.local"
  make
  make install
  echo "[tmux] Installed to $HOME_DIR/.local/bin (tmux)."
  # Remove source dir
  cd "$SCRIPT_DIR"
  rm -rf "$TMUX_SRC"
else
  echo "[tmux] Already installed, skipping build."
fi

# -----------------------------
# 3) oh-my-zsh install (if missing)
# -----------------------------
if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
  echo "[oh-my-zsh] Not found. Downloading & installing..."
  wget -O /tmp/ohmyzsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sh /tmp/ohmyzsh_install.sh --unattended
  rm /tmp/ohmyzsh_install.sh
else
  echo "[oh-my-zsh] Already installed, skipping."
fi

# -----------------------------
# 4) Dotfiles: symbolic links
# -----------------------------
echo "[dotfiles] Creating symbolic links..."

# zshrc -> ~/.zshrc
ln -sf "$SCRIPT_DIR/zshrc" "$HOME_DIR/.zshrc"

# tmux.conf -> ~/.tmux.conf
ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME_DIR/.tmux.conf"

# Neovim init.vim -> ~/.config/nvim/init.vim
mkdir -p "$HOME_DIR/.config/nvim"
ln -sf "$SCRIPT_DIR/config/nvim/init.vim" "$HOME_DIR/.config/nvim/init.vim"

# ~/.local/bin PATH addition (if not present in .zshrc)
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME_DIR/.zshrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.zshrc"
  echo "[dotfiles] Added 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to ~/.zshrc"
fi

# -----------------------------
# 5) vim-plug (Neovim) install
# -----------------------------
echo "[Neovim] Installing vim-plug..."
curl -fLo "$HOME_DIR/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# -----------------------------
# 6) tmux plugin manager (tpm)
# -----------------------------
if [ ! -d "$HOME_DIR/.tmux/plugins/tpm" ]; then
  echo "[tmux] Installing tmux plugin manager (tpm)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME_DIR/.tmux/plugins/tpm"
else
  echo "[tmux] tpm already installed, skipping."
fi

# -----------------------------
# 7) Set default shell to zsh
# -----------------------------
CURRENT_SHELL="$(basename "$SHELL")"
ZSH_PATH="$(which zsh || true)"  # in case zsh is not found
if [ -n "$ZSH_PATH" ] && [ "$CURRENT_SHELL" != "zsh" ]; then
  echo "[shell] Changing default shell to zsh..."
  # chsh가 sudo 권한 또는 비밀번호를 요구할 수 있습니다.
  chsh -s "$ZSH_PATH"
else
  echo "[shell] Default shell is already zsh or zsh not found. Skipping."
fi

# -----------------------------
# Installation complete
# -----------------------------
cat <<EOF

==========================================
Installation & setup complete!

1) Neovim: 
   - Launch nvim and run :PlugInstall to install plugins.
2) tmux:
   - Launch tmux, then press prefix + I (Ctrl+b, SHIFT+I) to install plugins.
3) Shell:
   - If asked, re-login or open a new terminal to use zsh as default shell.
4) PATH:
   - ~/.local/bin is appended to ~/.zshrc; run "source ~/.zshrc" or restart shell.
EOF
