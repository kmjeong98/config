
```markdown
# Config Repository

이 저장소는 사용자 환경에 맞는 dotfiles (예: zshrc, tmux.conf, Neovim init.vim 등)를 관리하며,  
CMake 기반의 부트스트랩 스크립트를 통해 새로운 환경에서 **zsh, neovim, tmux** 및 관련 플러그인들을  
자동으로 설치하고 설정할 수 있도록 도와줍니다.

## 주요 기능

- **시스템 패키지 설치**  
  - macOS: Homebrew를 이용하여 zsh, neovim, tmux 설치  
  - Ubuntu/Debian: apt-get을 이용하여 zsh, neovim, tmux 설치

- **dotfiles 저장소 클론**  
  - 저장소를 로컬 `$HOME/config`에 클론합니다.

- **심볼릭 링크 생성**  
  - `$HOME/.zshrc`, `$HOME/.tmux.conf`  
  - Neovim 설정 파일 `$HOME/.config/nvim/init.vim` (저장소 내 경로: `config/nvim/init.vim`)

- **플러그인 관리자 설치**  
  - oh-my-zsh, vim-plug (Neovim용), tmux 플러그인 매니저(tpm) 자동 설치

- **CMake 기반 자동화**  
  - CMake만 실행하면 위의 모든 작업을 자동으로 수행합니다.

## 설치 방법

### 1. 저장소 클론

먼저, 저장소를 로컬에 클론합니다.

```bash
git clone https://github.com/kmjeong98/config.git ~/config
cd ~/config
```

### 2. CMake 빌드 및 설치 타겟 실행

1. **빌드 디렉토리 생성 및 이동**

   ```bash
   mkdir build && cd build
   ```

2. **CMake를 통한 프로젝트 구성**

   ```bash
   cmake ..
   ```

3. **설치 타겟 실행 (모든 설치 및 설정 자동화)**

   ```bash
   cmake --build . --target install_dotfiles
   ```

   위 명령어를 실행하면 다음 작업들이 순서대로 수행됩니다.
   - 시스템 패키지 (zsh, neovim, tmux) 설치
   - 저장소가 로컬에 존재하지 않을 경우 클론
   - 설정 파일에 대한 심볼릭 링크 생성
   - oh-my-zsh, vim-plug, tmux 플러그인 매니저(tpm) 설치

## 주의 사항

- **패키지 관리자**: 이 스크립트는 macOS의 Homebrew와 Ubuntu/Debian의 apt-get을 지원합니다.  
  다른 시스템을 사용하는 경우, 스크립트 내 명령어를 수정해야 할 수 있습니다.
- **심볼릭 링크**: 기존 설정 파일이 있다면 강제로 덮어쓰므로, 중요한 설정은 미리 백업해 주세요.
- **플러그인 설치 후 추가 작업**:  
  - Neovim에서는 vim-plug 설치 후, `:PlugInstall` 명령어를 실행해야 합니다.  
  - tmux에서는 tmux 세션 내에서 `prefix + I`를 눌러 추가 플러그인 설치를 진행하세요.
- **권한 문제**: 일부 명령은 `sudo` 권한을 요구할 수 있으니, 필요한 경우 비밀번호 입력에 대비해 주세요.

## 구성 파일 설명

- **zshrc**: zsh 셸 설정 파일
- **tmux.conf**: tmux 설정 파일
- **config/nvim/init.vim**: Neovim 설정 파일
- **CMakeLists.txt**: 모든 설치 및 설정 작업을 자동화하는 CMake 스크립트

## 라이센스

이 저장소는 MIT 라이센스를 따릅니다. 자세한 내용은 LICENSE 파일을 참조하세요.
```
