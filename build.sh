#!/bin/bash
# build.sh: Neovim, tmux를 소스 빌드해 ~/.local/bin에 설치하고,
#           oh-my-zsh 및 powerlevel10k, dotfiles 심볼릭 링크, vim-plug, tpm 설치를 수행합니다.
#
# 참고: 이 스크립트는 현재 저장소에 있는 dotfiles(zshrc, tmux.conf, config/nvim/init.vim)를 사용합니다.

set -e  # 오류 발생 시 즉시 중단

# -------------------------
# 0) 환경 변수 및 경로 설정
# -------------------------
HOME_DIR="$HOME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"  # build.sh가 위치한 디렉토리
LOCAL_BIN="$HOME_DIR/.local/bin"             # 최종적으로 binary가 들어갈 위치

echo "============================================"
echo "=== Start local installation & setup...  ==="
echo "============================================"

# -----------------------------
# 1) Neovim 소스 빌드 및 설치
# -----------------------------
if ! command -v nvim >/dev/null 2>&1; then
  echo "[Neovim] Not found. Cloning & building from source..."
  NEOVIM_SRC="$HOME_DIR/neovim_src"
  if [ ! -d "$NEOVIM_SRC" ]; then
    git clone https://github.com/neovim/neovim.git "$NEOVIM_SRC"
  fi
  cd "$NEOVIM_SRC"
  # CMAKE_INSTALL_PREFIX를 ~/.local 로 설정하여 binary는 ~/.local/bin에 설치됨
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$HOME_DIR/.local"
  make install
  echo "[Neovim] Installed to $HOME_DIR/.local. Binaries are in $LOCAL_BIN."
  cd "$SCRIPT_DIR"
  rm -rf "$NEOVIM_SRC"
else
  echo "[Neovim] Already installed, skipping build."
fi

# -----------------------------
# 2) tmux 소스 빌드 및 설치
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
  echo "[tmux] Installed to $HOME_DIR/.local. Binaries are in $LOCAL_BIN."
  cd "$SCRIPT_DIR"
  rm -rf "$TMUX_SRC"
else
  echo "[tmux] Already installed, skipping build."
fi

# -----------------------------
# 3) oh-my-zsh 설치 (없을 경우)
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
# 4) powerlevel10k 설치 (oh-my-zsh 기반 테마)
# -----------------------------
if [ ! -d "$HOME_DIR/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  echo "[powerlevel10k] Not found. Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME_DIR/.oh-my-zsh/custom/themes/powerlevel10k"
else
  echo "[powerlevel10k] Already installed, skipping."
fi

# zshrc에 powerlevel10k 테마 설정 추가 (이미 설정되어 있지 않다면)
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$HOME_DIR/.zshrc"; then
  echo 'export ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME_DIR/.zshrc"
  echo "[dotfiles] Added powerlevel10k theme configuration to ~/.zshrc"
else
  echo "[dotfiles] powerlevel10k theme already configured in ~/.zshrc, skipping."
fi

# -----------------------------
# 5) dotfiles 심볼릭 링크 생성
# -----------------------------
echo "[dotfiles] Creating symbolic links..."
# zshrc -> ~/.zshrc
ln -sf "$SCRIPT_DIR/zshrc" "$HOME_DIR/.zshrc"
# tmux.conf -> ~/.tmux.conf
ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME_DIR/.tmux.conf"
# Neovim 설정 -> ~/.config/nvim/init.vim
mkdir -p "$HOME_DIR/.config/nvim"
ln -sf "$SCRIPT_DIR/config/nvim/init.vim" "$HOME_DIR/.config/nvim/init.vim"

# ~/.local/bin 경로를 ~/.zshrc에 등록 (이미 없으면 추가)
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME_DIR/.zshrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.zshrc"
  echo "[dotfiles] Added ~/.local/bin to PATH in ~/.zshrc"
else
  echo "[dotfiles] ~/.local/bin already in PATH, skipping."
fi

# -----------------------------
# 6) vim-plug (Neovim) 설치
# -----------------------------
echo "[Neovim] Installing vim-plug..."
curl -fLo "$HOME_DIR/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# -----------------------------
# 7) tmux plugin manager (tpm) 설치
# -----------------------------
if [ ! -d "$HOME_DIR/.tmux/plugins/tpm" ]; then
  echo "[tmux] Installing tmux plugin manager (tpm)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME_DIR/.tmux/plugins/tpm"
else
  echo "[tmux] tpm already installed, skipping."
fi

# -----------------------------
# 설치 완료 안내
# -----------------------------
cat <<EOF

==========================================
Installation & setup complete!

[Neovim] 
 - 실행 후 :PlugInstall 명령어로 플러그인 설치

[tmux]
 - tmux 실행 후 prefix + I (기본: Ctrl+b, 대문자 I)로 플러그인 설치

[PATH 설정]
 - ~/.local/bin 경로를 ~/.zshrc에 추가하였습니다.
   새 쉘을 열거나 "source ~/.zshrc"로 적용 가능합니다.

[oh-my-zsh & powerlevel10k]
 - oh-my-zsh 및 powerlevel10k 테마가 설치되었으며,
   ~/.zshrc에 테마 설정이 추가되었습니다.

즐거운 개발 되시길 바랍니다!
==========================================
EOF
