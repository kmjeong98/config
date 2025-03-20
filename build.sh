#!/bin/bash
# build.sh: Neovim, tmux를 소스 빌드해 ~/.local/bin에 설치하고,
#           oh-my-zsh를 설치하고, dotfiles에 대한 심볼릭 링크를 만드는 스크립트.
#           CMake 없이 단일 스크립트로 동작합니다.

set -e  # 스크립트 중 오류 발생 시 즉시 중단

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
  # 소스 디렉토리: ~/neovim_src
  NEOVIM_SRC="$HOME_DIR/neovim_src"
  if [ ! -d "$NEOVIM_SRC" ]; then
    git clone https://github.com/neovim/neovim.git "$NEOVIM_SRC"
  fi
  cd "$NEOVIM_SRC"
  # -- CMAKE_INSTALL_PREFIX를 ~/.local 로 설정해 ~/.local/bin에 nvim이 설치되도록
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$HOME_DIR/.local"
  make install
  echo "[Neovim] Installed to $HOME_DIR/.local. Binaries are in $LOCAL_BIN."
  # 소스 디렉토리 제거
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
  # 소스 디렉토리: ~/tmux_src
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
  # 소스 디렉토리 제거
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
# 4) dotfiles 심볼릭 링크
# -----------------------------
echo "[dotfiles] Creating symbolic links..."
# zshrc -> ~/.zshrc
ln -sf "$SCRIPT_DIR/zshrc" "$HOME_DIR/.zshrc"

# tmux.conf -> ~/.tmux.conf
ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME_DIR/.tmux.conf"

# Neovim 설정 -> ~/.config/nvim/init.vim
mkdir -p "$HOME_DIR/.config/nvim"
ln -sf "$SCRIPT_DIR/config/nvim/init.vim" "$HOME_DIR/.config/nvim/init.vim"

# ~/.local/bin 경로를 zshrc에 등록 (이미 비슷한 문구가 없다면 추가)
# 단순히 zshrc 맨 끝에 한 줄 추가
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME_DIR/.zshrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.zshrc"
  echo "[dotfiles] Added PATH export to ~/.zshrc"
else
  echo "[dotfiles] PATH export for ~/.local/bin already present, skipping."
fi

# -----------------------------
# 5) vim-plug (Neovim) 설치
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
 - 이미 ~/.zshrc에 ~/.local/bin 경로를 추가했습니다.
   새 쉘을 열거나 "source ~/.zshrc" 명령어로 적용 가능합니다.

즐거운 개발 되시길 바랍니다!
==========================================
EOF
