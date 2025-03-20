cmake_minimum_required(VERSION 3.10)
project(BootstrapDotfiles)

# Set HOME directory variable from environment variable
set(HOME_DIR $ENV{HOME})

# Define custom target to perform installation steps
add_custom_target(install_dotfiles ALL
    # Print start message
    COMMAND ${CMAKE_COMMAND} -E echo "Starting dotfiles installation..."
    
    # 1. 시스템 패키지 설치 (macOS: Homebrew, Ubuntu/Debian: apt-get)
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if command -v brew >/dev/null 2>&1; then \
        echo 'Using Homebrew'; brew update && brew install zsh neovim tmux; \
    elif command -v apt-get >/dev/null 2>&1; then \
        echo 'Using apt-get'; sudo apt-get update && sudo apt-get install -y zsh neovim tmux; \
    else echo 'No supported package manager found. Please install packages manually.'; fi"
    
    # 2. dotfiles 저장소 클론 (이미 존재하지 않을 경우)
    COMMAND ${CMAKE_COMMAND} -E echo "Cloning dotfiles repository..."
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if [ ! -d \"${HOME_DIR}/config\" ]; then \
        git clone https://github.com/kmjeong98/config.git \"${HOME_DIR}/config\"; fi"
    
    # 3. 심볼릭 링크 생성
    COMMAND ${CMAKE_COMMAND} -E echo "Creating symbolic links..."
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${HOME_DIR}/config/zshrc" "${HOME_DIR}/.zshrc"
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${HOME_DIR}/config/tmux.conf" "${HOME_DIR}/.tmux.conf"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${HOME_DIR}/.config/nvim"
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${HOME_DIR}/config/config/nvim/init.vim" "${HOME_DIR}/.config/nvim/init.vim"
    
    # 4. oh-my-zsh 설치
    COMMAND ${CMAKE_COMMAND} -E echo "Installing oh-my-zsh..."
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if [ ! -d \"${HOME_DIR}/.oh-my-zsh\" ]; then \
        sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" --unattended; fi"
    
    # 5. vim-plug (Neovim용) 설치
    COMMAND ${CMAKE_COMMAND} -E echo "Installing vim-plug for Neovim..."
    COMMAND ${CMAKE_COMMAND} -E env sh -c "curl -fLo \"${HOME_DIR}/.local/share/nvim/site/autoload/plug.vim\" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    
    # 6. tmux 플러그인 매니저 (tpm) 설치
    COMMAND ${CMAKE_COMMAND} -E echo "Installing tmux plugin manager (tpm)..."
    COMMAND ${CMAKE_COMMAND} -E env sh -c "if [ ! -d \"${HOME_DIR}/.tmux/plugins/tpm\" ]; then \
        git clone https://github.com/tmux-plugins/tpm \"${HOME_DIR}/.tmux/plugins/tpm\"; fi"
    
    # Print completion message
    COMMAND ${CMAKE_COMMAND} -E echo "Installation complete! For Neovim, run :PlugInstall and in tmux press prefix + I to install plugins."
    
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

