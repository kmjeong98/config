# Terminal Coding Environment

## 🚀 Quick Install (복사-붙여넣기)

```bash
git clone https://github.com/kmjeong98/config.git ~/config && cd ~/config && chmod +x install.sh && ./install.sh && source ~/.zshrc
```

---

터미널 기반 개발 환경 설정 파일들입니다. Neovim, Tmux, Zsh를 사용하며, GitHub Copilot과 연동됩니다.

**sudo 권한 없이 설치 가능합니다!** (학교 서버 등 제한된 환경에서 사용 가능)

## ✨ 주요 기능

- **Neovim**: NERDTree, GitHub Copilot, 마우스 지원
- **Tmux**: 마우스 지원, 편리한 창 분할
- **Zsh**: Powerlevel10k 테마

## 📋 자동 설치되는 것들

install.sh가 자동으로 설치합니다 (sudo 불필요):

| 도구 | 설치 방법 |
|------|-----------|
| Neovim | AppImage (Linux) |
| Node.js | nvm (git clone) |
| Powerlevel10k | git clone |
| vim-plug | curl |

> [!NOTE]
> macOS에서는 `brew install neovim tmux`를 먼저 실행하세요.

> [!WARNING]
> Zsh와 Tmux는 빌드 의존성이 필요할 수 있어서, 시스템에 이미 설치되어 있어야 할 수 있습니다.

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
| `jk` | ESC (Insert 모드 종료) |

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
├── install.sh          # 설치 스크립트 (sudo 불필요)
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
# macOS
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font

# Linux (수동 설치)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
unzip Meslo.zip
fc-cache -fv
```
터미널 설정에서 해당 폰트를 선택하세요.

### Copilot이 작동하지 않을 때
1. Node.js 버전 확인: `node --version` (17 이상 필요)
2. Neovim에서 `:Copilot status` 실행
3. `:Copilot setup`으로 재인증

### Neovim AppImage가 실행되지 않을 때
FUSE가 없는 시스템에서는 install.sh가 자동으로 AppImage를 추출합니다.
수동으로 추출하려면:
```bash
chmod +x ~/.local/bin/nvim.appimage
~/.local/bin/nvim.appimage --appimage-extract
```
