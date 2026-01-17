# Terminal Coding Environment

터미널 기반 개발 환경 설정 파일들입니다. Neovim, Tmux, Zsh를 사용하며, GitHub Copilot과 연동됩니다.

## ✨ 주요 기능

- **Neovim**: NERDTree, GitHub Copilot, 마우스 지원
- **Tmux**: 마우스 지원, 편리한 창 분할
- **Zsh**: Powerlevel10k 테마

## 📋 요구사항

설치 전 다음 도구들이 필요합니다:

| 도구 | 용도 | 설치 방법 |
|------|------|-----------|
| `git` | 버전 관리 | 기본 설치 |
| `nvim` | 에디터 | `brew install neovim` |
| `tmux` | 터미널 멀티플렉서 | `brew install tmux` |
| `zsh` | 쉘 | 기본 설치 (macOS) |
| `curl` | 다운로드 | 기본 설치 |
| `node` (17+) | GitHub Copilot | `brew install node` |

## 🚀 설치 방법

```bash
# 1. 저장소 클론
git clone https://github.com/YOUR_USERNAME/config.git ~/config

# 2. 설치 스크립트 실행
cd ~/config
chmod +x install.sh
./install.sh

# 3. 터미널 재시작 또는
source ~/.zshrc
```

## 🔄 업데이트 방법

설정 파일들이 심볼릭 링크로 연결되어 있으므로, git pull만 하면 됩니다:

```bash
cd ~/config
git pull
```

Tmux 설정을 즉시 적용하려면:
```bash
tmux source-file ~/.tmux.conf
# 또는 tmux 내에서: Ctrl+a r
```

## ⌨️ 단축키

### Neovim

| 단축키 | 기능 |
|--------|------|
| `Ctrl+n` | NERDTree 토글 (파일 탐색기) |
| `Space+w` | 저장 |
| `Space+q` | 종료 |
| `Space+nf` | 현재 파일을 NERDTree에서 찾기 |
| `Ctrl+h/j/k/l` | 창 이동 |
| `Tab` | Copilot 제안 수락 |

### Tmux

| 단축키 | 기능 |
|--------|------|
| `Ctrl+a \|` | 세로 분할 |
| `Ctrl+a -` | 가로 분할 |
| `Ctrl+a h/j/k/l` | 창 이동 |
| `Ctrl+a r` | 설정 다시 로드 |
| `Alt+1~5` | 윈도우 빠른 전환 |

### Zsh Aliases

| Alias | 명령어 |
|-------|--------|
| `ll` | `ls -alF` |
| `vim` | `nvim` |
| `gs` | `git status` |
| `ta <name>` | `tmux attach -t <name>` |
| `tn <name>` | `tmux new -s <name>` |

## 🤖 GitHub Copilot 설정

Neovim에서 다음 명령어를 실행하여 Copilot을 설정합니다:

```vim
:Copilot setup
```

브라우저에서 GitHub 인증을 진행하면 됩니다.

## 📁 구조

```
config/
├── install.sh          # 설치 스크립트
├── README.md           # 이 파일
├── nvim/
│   └── init.vim        # Neovim 설정
├── tmux/
│   └── .tmux.conf      # Tmux 설정
└── zsh/
    ├── .zshrc          # Zsh 설정
    └── .p10k.zsh       # Powerlevel10k 테마
```

## ⚠️ 문제 해결

### Powerlevel10k 폰트가 깨져 보일 때
Nerd Font를 설치하세요:
```bash
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
```
터미널 설정에서 해당 폰트를 선택하세요.

### Copilot이 작동하지 않을 때
1. Node.js 버전 확인: `node --version` (17 이상 필요)
2. Neovim에서 `:Copilot status` 실행
3. `:Copilot setup`으로 재인증
