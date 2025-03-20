cmake_minimum_required(VERSION 3.10)
project(LocalInstallDotfiles)

set(HOME_DIR $ENV{HOME})
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_target(install_dotfiles ALL
    # 1) 시작 메시지 (이 안의 '&' 문자는 이스케이프 또는 큰따옴표로 감싸는 것을 권장)
    COMMAND ${CMAKE_COMMAND} -E echo "=== Start: Local installation & dotfiles setup ==="

    # 2) Neovim 빌드 (이미 nvim이 없을 경우에 한해)
    #    여러 줄에 걸쳐 쉘 명령을 작성해야 하는 경우, 각 줄 끝에 '\'로 이스케이프 처리
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if ! command -v nvim >/dev/null 2>&1; then \
      echo '[Neovim] Not found. Building from source...'; \
      git clone https://github.com/neovim/neovim.git \"${HOME_DIR}/neovim_src\"; \
      cd \"${HOME_DIR}/neovim_src\" && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=\"${HOME_DIR}/neovim_install\"; \
      make install; \
      echo '[Neovim] Installed to ${HOME_DIR}/neovim_install. Make sure it is in your PATH.'; \
    else \
      echo '[Neovim] Already found, skipping build.'; \
    fi"

    # 3) tmux 빌드 (이미 tmux가 없을 경우에 한해)
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if ! command -v tmux >/dev/null 2>&1; then \
      echo '[tmux] Not found. Building from source...'; \
      git clone https://github.com/tmux/tmux.git \"${HOME_DIR}/tmux_src\"; \
      cd \"${HOME_DIR}/tmux_src\" && sh autogen.sh && ./configure --prefix=\"${HOME_DIR}/.local\" && make && make install; \
      echo '[tmux] Installed to ${HOME_DIR}/.local/bin. Make sure it is in your PATH.'; \
    else \
      echo '[tmux] Already found, skipping build.'; \
    fi"

    # 4) oh-my-zsh 설치
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if [ ! -d \"${HOME_DIR}/.oh-my-zsh\" ]; then \
      echo '[oh-my-zsh] Not found. Downloading install script...'; \
      wget -O /tmp/ohmyzsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh; \
      sh /tmp/ohmyzsh_install.sh --unattended; \
    else \
      echo '[oh-my-zsh] Already installed, skipping.'; \
    fi"

    # 5) dotfiles 심볼릭 링크 (현재 저장소 내부에 zshrc, tmux.conf, init.vim이 있다고 가정)
    COMMAND ${CMAKE_COMMAND} -E echo "[dotfiles] Creating symbolic links..."
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${SRC_DIR}/zshrc" "${HOME_DIR}/.zshrc"
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${SRC_DIR}/tmux.conf" "${HOME_DIR}/.tmux.conf"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${HOME_DIR}/.config/nvim"
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${SRC_DIR}/config/nvim/init.vim" "${HOME_DIR}/.config/nvim/init.vim"

    # 6) vim-plug 설치
    COMMAND ${CMAKE_COMMAND} -E env sh -c "curl -fLo \"${HOME_DIR}/.local/share/nvim/site/autoload/plug.vim\" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

    # 7) tmux 플러그인 매니저 (tpm) 설치
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if [ ! -d \"${HOME_DIR}/.tmux/plugins/tpm\" ]; then \
      git clone https://github.com/tmux-plugins/tpm \"${HOME_DIR}/.tmux/plugins/tpm\"; \
    else \
      echo '[tmux] tpm already installed, skipping.'; \
    fi"

    # 완료 메시지
    COMMAND ${CMAKE_COMMAND} -E echo "=== Installation complete! ==="
    COMMAND ${CMAKE_COMMAND} -E echo "Neovim: :PlugInstall, tmux: prefix + I (Ctrl+b -> Shift+I)"
)
