#!/bin/bash
# build.sh: 
#   - Neovim, tmux, lsd를 소스/도구(chain)로 설치해 ~/.local/bin에 배치
#   - oh-my-zsh 및 powerlevel10k, dotfiles 심볼릭 링크( zshrc -> ~/.zshrc ) 설정
#   - ~/.zshrc 대신 ~/.zshrc.local에 PATH, 사용자 설정을 추가하여 심볼릭 링크 깨짐 방지
#   - vim-plug, tmux plugin manager(tpm) 설치

set -e  # 오류 발생 시 즉시 중단

# -------------------------
# 0) 환경 변수 및 경로 설정
# -------------------------
HOME_DIR="$HOME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"   # build.sh가 위치한 디렉토리
LOCAL_BIN="$HOME_DIR/.local/bin"              # 최종적으로 binary가 들어갈 위치

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
  # CMAKE_INSTALL_PREFIX를 ~/.local로 설정 -> nvim이 ~/.local/bin 에 설치
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
# 3) lsd 설치 (Rust toolchain 필요)
# -----------------------------
if ! command -v lsd >/dev/null 2>&1; then
  echo "[lsd] Not found. Installing via cargo..."
  if command -v cargo >/dev/null 2>&1; then
    cargo install lsd --root "$HOME_DIR/.local"
    echo "[lsd] Installed to $HOME_DIR/.local. Binaries are in $LOCAL_BIN."
  else
    echo "[lsd] Cargo not found. Please install Rust toolchain and try again."
    exit 1
  fi
else
  echo "[lsd] Already installed, skipping."
fi

# -----------------------------
# 4) oh-my-zsh 설치 (없을 경우)
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
# 5) powerlevel10k 설치
# -----------------------------
if [ ! -d "$HOME_DIR/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  echo "[powerlevel10k] Not found. Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$HOME_DIR/.oh-my-zsh/custom/themes/powerlevel10k"
else
  echo "[powerlevel10k] Already installed, skipping."
fi

# -----------------------------
# 6) dotfiles 심볼릭 링크: zshrc, tmux.conf, Neovim 설정
# -----------------------------
echo "[dotfiles] Creating symbolic links..."
# zshrc -> ~/.zshrc
ln -sf "$SCRIPT_DIR/zshrc" "$HOME_DIR/.zshrc"
# tmux.conf -> ~/.tmux.conf
ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME_DIR/.tmux.conf"
# Neovim init.vim -> ~/.config/nvim/init.vim
mkdir -p "$HOME_DIR/.config/nvim"
ln -sf "$SCRIPT_DIR/config/nvim/init.vim" "$HOME_DIR/.config/nvim/init.vim"

# -----------------------------
# 7) ~/.zshrc.local 파일 관리
#    => ~/.zshrc는 저장소 파일(심볼릭 링크) 이므로,
#       사용자 PATH 같은 로컬 설정은 zshrc.local에 따로 추가
# -----------------------------
LOCAL_ZSHRC="$HOME_DIR/.zshrc.local"
# zshrc가 ~/.zshrc.local을 로드하도록 확인 (이미 있으면 스킵)
if ! grep -q 'source ~/.zshrc.local' "$SCRIPT_DIR/zshrc"; then
  echo "source ~/.zshrc.local" >> "$SCRIPT_DIR/zshrc"
  echo "[dotfiles] Added 'source ~/.zshrc.local' to repository zshrc."
fi

# ~/.zshrc.local 없으면 생성
if [ ! -f "$LOCAL_ZSHRC" ]; then
  echo '# Put your local overrides or PATH exports here' > "$LOCAL_ZSHRC"
fi

# ~/.local/bin을 PATH에 추가
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$LOCAL_ZSHRC"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$LOCAL_ZSHRC"
  echo "[dotfiles] Added ~/.local/bin to PATH in ~/.zshrc.local"
fi

# powerlevel10k 테마 설정 (이미 ~/.zshrc 자체에서 설정 가능하지만, 
# 여기서는 zshrc.local로도 추가 가능)
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$LOCAL_ZSHRC" \
   && ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$SCRIPT_DIR/zshrc"; then
  echo 'export ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$LOCAL_ZSHRC"
  echo "[dotfiles] Added powerlevel10k theme config to ~/.zshrc.local"
fi

# -----------------------------
# 8) vim-plug (Neovim)
# -----------------------------
echo "[Neovim] Installing vim-plug..."
curl -fLo "$HOME_DIR/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# -----------------------------
# 9) tmux plugin manager (tpm)
# -----------------------------
if [ ! -d "$HOME_DIR/.tmux/plugins/tpm" ]; then
  echo "[tmux] Installing tmux plugin manager (tpm)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME_DIR/.tmux/plugins/tpm"
else
  echo "[tmux] tpm already installed, skipping."
fi

# -----------------------------
# 완료 안내
# -----------------------------
cat <<EOF

==========================================
Installation & setup complete!

[Neovim] 
 - 실행 후 :PlugInstall 명령어로 플러그인 설치

[tmux]
 - tmux 실행 후 prefix + I (기본: Ctrl+b, 대문자 I)로 플러그인 설치

[lsd]
 - lsd는 ~/.local/bin에 설치되었습니다. (Rust toolchain 이용)

[oh-my-zsh & powerlevel10k]
 - oh-my-zsh 및 powerlevel10k 테마가 설치됨
 - 저장소의 zshrc(심볼릭 링크)에서 ~/.zshrc.local을 source
 - ~/.zshrc.local에 PATH, 테마 설정이 추가됨

새 쉘을 열거나 "source ~/.zshrc" 명령으로 설정을 적용할 수 있습니다.

즐거운 개발 되시길 바랍니다!
==========================================
EOF
