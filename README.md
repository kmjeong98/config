
# LocalInstallDotfiles

이 저장소는 **Neovim과 tmux**를 소스에서 빌드해 로컬에 설치하고,  
**oh-my-zsh**를 다운로드하여 설치(존재하지 않을 경우),  
이미 이 저장소에 있는 **dotfiles**(zshrc, tmux.conf, Neovim 설정 등)를 심볼릭 링크로 연결하는 과정을  
CMake 기반으로 자동화한 예시입니다.

## 주요 기능

1. **Neovim 빌드/설치**  
   - `nvim` 명령어가 없으면 `~/neovim_src`에 클론 후 빌드,  
     `~/neovim_install` 경로에 설치합니다.  
2. **tmux 빌드/설치**  
   - `tmux` 명령어가 없으면 `~/tmux_src`에 클론 후 빌드,  
     `~/.local` 경로에 설치합니다.  
3. **oh-my-zsh 설치**  
   - `~/.oh-my-zsh` 폴더가 없으면 install.sh를 wget으로 가져와 `--unattended` 설치합니다.  
4. **dotfiles 심볼릭 링크**  
   - (현재 저장소 내) `zshrc -> ~/.zshrc`  
   - `tmux.conf -> ~/.tmux.conf`  
   - `config/nvim/init.vim -> ~/.config/nvim/init.vim`  
5. **vim-plug, tmux plugin manager**  
   - vim-plug: Neovim용 plugin manager  
   - tpm: tmux plugin manager

## 사전 요구 사항

- **CMake** (3.10 이상)
- **Git**, **make**, **gcc**/**clang** 등 빌드 도구
- **Neovim 소스 빌드** 시 필요 라이브러리  
- **tmux 소스 빌드** 시 필요 라이브러리 (예: libevent, ncurses 등)

## 설치 및 실행 방법

1. **저장소 클론 (이미 이 프로젝트가 있는 경우 스킵)**  
   ```bash
   git clone https://github.com/kmjeong98/config.git
   cd config
   ```

2. **build.sh 실행**  
   ```bash
   chmod +x build.sh
   ./build.sh
   ```
   - CMake가 실행되어 `install_dotfiles` 타겟이 순차적으로 수행됩니다.  
   - Neovim과 tmux가 이미 설치되어 있으면 빌드를 스킵합니다.

3. **마무리 작업**  
   - **Neovim**: `:PlugInstall` 명령어로 플러그인 설치  
   - **tmux**: tmux 실행 후, prefix + I (기본: Ctrl+b 후 대문자 I)  
   - **PATH**: Neovim이 `~/neovim_install/bin`, tmux가 `~/.local/bin`에 설치되므로  
     필요한 경우 `~/.zshrc` 등에 다음을 추가하세요:
     ```bash
     export PATH="$HOME/neovim_install/bin:$HOME/.local/bin:$PATH"
     ```

## 참고사항

- **이미 설치된 Neovim, tmux**  
  - `nvim`, `tmux` 명령어가 인식된다면 소스 빌드를 건너뜁니다.  
- **oh-my-zsh 검증**  
  - 보안상 스크립트를 받아두고 직접 확인하는 것을 권장하지만,  
    여기서는 자동화 시나리오를 위해 바로 설치합니다.  
- **라이센스**  
  - 이 프로젝트는 MIT License를 사용합니다.  
  - Neovim, tmux, oh-my-zsh는 각자의 라이센스를 따릅니다.
