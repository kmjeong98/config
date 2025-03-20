# Config Repository

이 저장소는 사용자의 dotfiles(zshrc, tmux.conf, Neovim init.vim 등)를 관리하며,  
CMake 기반의 부트스트랩 스크립트를 통해 새로운 환경에서 **zsh, neovim, tmux** 및 관련 플러그인들을  
자동으로 설치하고 설정할 수 있도록 구성되어 있습니다.

## 주요 기능

- **시스템 패키지 설치**  
  - macOS: Homebrew를 통해 zsh, neovim, tmux 설치  
  - Ubuntu/Debian: apt-get을 통해 zsh, neovim, tmux 설치

- **dotfiles 클론 및 심볼릭 링크 생성**  
  - `$HOME/.zshrc`, `$HOME/.tmux.conf`  
  - Neovim 설정 파일: `$HOME/.config/nvim/init.vim` (저장소 내 경로: `config/nvim/init.vim`)

- **플러그인 관리자 설치**  
  - oh-my-zsh, vim-plug (Neovim용), tmux 플러그인 매니저(tpm) 자동 설치

- **CMake 기반 자동화**  
  - CMakeLists.txt 파일에 모든 설치 및 설정 작업을 정의  
  - **build.sh** 스크립트를 통해 CMake를 실행하면, 모든 과정이 자동으로 진행됩니다.

## 설치 방법

1. **저장소 클론**

   먼저, 저장소를 로컬에 클론합니다.

   ```bash
   git clone https://github.com/kmjeong98/config.git ~/config
   cd ~/config
   ```

2. **build.sh 스크립트 실행**

   스크립트에 실행 권한을 부여한 후 실행합니다.

   ```bash
   chmod +x build.sh
   ./build.sh
   ```

   위 명령어를 실행하면 CMake가 빌드 디렉토리를 생성하고,  
   `install_dotfiles` 타겟을 실행하여 다음 작업들을 순서대로 수행합니다.
   - 시스템 패키지(zsh, neovim, tmux) 설치
   - dotfiles 클론 (만약 로컬에 없을 경우)
   - 설정 파일에 대한 심볼릭 링크 생성
   - oh-my-zsh, vim-plug, tmux 플러그인 매니저(tpm) 설치

3. **추가 작업**

   - **Neovim**: Neovim을 실행한 후 `:PlugInstall` 명령어를 실행하여 플러그인을 설치합니다.
   - **tmux**: tmux 세션 내에서 `prefix + I` (기본: Ctrl+b 후 대문자 I)를 눌러 추가 플러그인을 설치합니다.

## 주의 사항

- **패키지 관리자**: 이 스크립트는 macOS의 Homebrew와 Ubuntu/Debian의 apt-get을 지원합니다.  
  다른 시스템에서는 스크립트 내 명령어를 수정해야 할 수 있습니다.
- **심볼릭 링크**: 기존 설정 파일이 있을 경우 강제로 덮어쓰게 되므로, 중요한 파일은 미리 백업하세요.
- **권한 문제**: 일부 명령은 `sudo` 권한을 요구할 수 있으므로, 필요 시 비밀번호 입력에 대비해주세요.

## 구성 파일 설명

- **zshrc**: zsh 셸 설정 파일
- **tmux.conf**: tmux 설정 파일
- **config/nvim/init.vim**: Neovim 설정 파일
- **CMakeLists.txt**: 모든 설치 및 설정 작업을 자동화하는 CMake 스크립트
- **build.sh**: CMake를 실행하여 위 작업들을 자동으로 수행하는 스크립트

## 라이센스

이 저장소는 MIT 라이센스를 따릅니다. 자세한 내용은 LICENSE 파일을 참조하세요.
