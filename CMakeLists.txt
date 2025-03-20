cmake_minimum_required(VERSION 3.10)
project(LocalInstallDotfiles)

# HOME 디렉토리 변수 (환경 변수에서 읽어옴)
set(HOME_DIR $ENV{HOME})

# 현재 저장소(소스) 디렉토리: CMakeLists.txt가 위치한 곳
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# install_dotfiles 타겟
add_custom_target(install_dotfiles ALL
    # 시작 메시지
    COMMAND ${CMAKE_COMMAND} -E echo "=== Start: Local installation & dotfiles setup ==="

    # ------------------------------------------------------------------
    # 1. Neovim 소스 빌드 후 로컬 설치 (이미 nvim이 없을 경우에만)
    # ------------------------------------------------------------------
    COMMAND ${CMAKE_COMMAND} -E env sh -c "
      if ! command -v nvim >/dev/null 2>&1; then
        echo '[Neovim] Not found. Building from source...';
        git clone https://github.com/neovim/neovim.git \"${HOME_DIR}/neovim_src\";
        cd \"${HOME_DIR}/neovim_src\" && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=\"${HOME_DIR}/neovim_install\";
        make install;
        echo '[Neovim] Installed to ${HOME_DIR}/neovim_install.';
        echo '[Neovim] Ensure ${HOME_DIR}/neovim_install/bin is in your PATH.';
      else
        echo '[Neovim] Already found, skipping build.';
      fi
    "

    # ------------------------------------------------------------------
    # 2. tmux 소스 빌드 후 로컬 설치 (이미 tmux가 없을 경우에만)
    # ------------------------------------------------------------------
    COMMAND ${CMAKE_COMMAND} -E env sh -c "
      if ! command -v tmux >/dev/null 2>&1; then
        echo '[tmux] Not found. Building from source...';
        git clone https://github.com/tmux/tmux.git \"${HOME_DIR}/tmux_src\";
        cd \"${HOME_DIR}/tmux_src\" && sh autogen.sh && ./configure --prefix=\"${HOME_DIR}/.local\" && make && make install;
        echo '[tmux] Installed to ${HOME_DIR}/.local. Ensure ${HOME_DIR}/.local/bin is in your PATH.';
      else
        echo '[tmux] Already found, skipping build.';
      fi
    "

    # ------------------------------------------------------------------
    # 3. oh-my-zsh 설치 (이미 ~/.oh-my-zsh 디렉토리가 없으면)
    # ------------------------------------------------------------------
    COMMAND ${CMAKE_COMMAND} -E env sh -c "
      if [ ! -d \"${HOME_DIR}/.oh-my-zsh\" ]; then
        echo '[oh-my-zsh] Not found. Downloading install script...';
        wget -O /tmp/ohmyzsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh;
        echo '[oh-my-zsh] Inspect /tmp/ohmyzsh_install.sh if desired, now installing in unattended mode...';
        sh /tmp/ohmyzsh_install.sh --unattended;
        echo '[oh-my-zsh] Installed to ${HOME_DIR}/.oh-my-zsh.';
      else
        echo '[oh-my-zsh] Already installed, skipping.';
      fi
    "

    # ------------------------------------------------------------------
    # 4. dotfiles 심볼릭 링크 생성 (이 저장소에 이미 파일이 존재)
    # ------------------------------------------------------------------
    COMMAND ${CMAKE_COMMAND} -E echo "[dotfiles] Creating symbolic links..."
    # zshrc
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${SRC_DIR}/zshrc" "${HOME_DIR}/.zshrc"
    # tmux.conf
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${SRC_DIR}/tmux.conf" "${HOME_DIR}/.tmux.conf"
    # Neovim 설정
    COMMAND ${CMAKE_COMMAND} -E make_directory "${HOME_DIR}/.config/nvim"
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${SRC_DIR}/config/nvim/init.vim" "${HOME_DIR}/.config/nvim/init.vim"

    # ------------------------------------------------------------------
    # 5. vim-plug (Neovim) 설치
    # ------------------------------------------------------------------
    COMMAND ${CMAKE_COMMAND} -E env sh -c "
      echo '[Neovim] Installing vim-plug...';
      curl -fLo \"${HOME_DIR}/.local/share/nvim/site/autoload/plug.vim\" --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "

    # ------------------------------------------------------------------
    # 6. tmux 플러그인 매니저 (tpm) 설치
    # ------------------------------------------------------------------
    COMMAND ${CMAKE_COMMAND} -E env sh -c "
      if [ ! -d \"${HOME_DIR}/.tmux/plugins/tpm\" ]; then
        echo '[tmux] Installing tmux plugin manager (tpm)...';
        git clone https://github.com/tmux-plugins/tpm \"${HOME_DIR}/.tmux/plugins/tpm\";
      else
        echo '[tmux] tpm already installed, skipping.';
      fi
    "

    # ------------------------------------------------------------------
    # 완료 메시지
    # ------------------------------------------------------------------
    COMMAND ${CMAKE_COMMAND} -E echo "=== Installation complete! ==="
    COMMAND ${CMAKE_COMMAND} -E echo "1) Neovim에서 :PlugInstall 실행"
    COMMAND ${CMAKE_COMMAND} -E echo "2) tmux 세션 내에서 prefix + I (기본: Ctrl+b 후 대문자 I)"
    COMMAND ${CMAKE_COMMAND} -E echo "3) PATH에 \"${HOME_DIR}/neovim_install/bin\" 및 \"${HOME_DIR}/.local/bin\" 추가 필요할 수 있음."
    COMMAND ${CMAKE_COMMAND} -E echo "================================"
)
