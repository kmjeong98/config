# Terminal Coding Environment

## Quick Install (copy-paste)

```bash
git clone https://github.com/kmjeong98/config.git ~/config && cd ~/config && chmod +x install.sh && ./install.sh && exec zsh
```

## Quick Update (copy-paste)

```bash
cd ~/config && git pull && source ~/.zshrc
```

---

Terminal-based development environment configuration files. Uses Neovim, Tmux, and Zsh with GitHub Copilot integration.

**Can be installed without sudo privileges!** (Usable in restricted environments like university servers)

## Features

- **Neovim**: NERDTree, GitHub Copilot, mouse support
- **Tmux**: Mouse support, convenient pane splitting
- **Zsh**: Powerlevel10k theme

## Auto-installed Components

install.sh automatically installs the following (no sudo required):

| Tool | Install Method |
|------|---------------|
| Neovim | AppImage (Linux) |
| Node.js | nvm (git clone) |
| Powerlevel10k | git clone |
| vim-plug | curl |

> [!NOTE]
> On macOS, run `brew install neovim tmux` first.

> [!WARNING]
> Zsh and Tmux may require build dependencies and might need to be pre-installed on the system.

## How to Update

Configuration files are connected via symbolic links, so just run git pull:

```bash
cd ~/config
git pull
```

To apply Tmux settings immediately:
```bash
tmux source-file ~/.tmux.conf
# Or inside tmux: Ctrl+a r
```

## Keyboard Shortcuts

### Neovim

| Shortcut | Action |
|----------|--------|
| `Ctrl+n` | Toggle NERDTree (file explorer) |
| `Space+w` | Save |
| `Space+q` | Quit |
| `Space+nf` | Find current file in NERDTree |
| `Ctrl+h/j/k/l` | Navigate windows |
| `Tab` | Accept Copilot suggestion |
| `jk` | ESC (exit Insert mode) |

### NERDTree (inside file explorer)

| Shortcut | Action |
|----------|--------|
| `Enter` | Open file / Toggle folder |
| `o` | Open file / Toggle folder |
| `s` | Open file in vertical split |
| `i` | Open file in horizontal split |
| `t` | Open file in new tab |
| `m` | Open menu (create/delete/move files) |
| `R` | Refresh root directory |
| `r` | Refresh current directory |
| `I` | Toggle hidden files |
| `q` | Close NERDTree |

### Tmux

| Shortcut | Action |
|----------|--------|
| `Ctrl+a \|` | Vertical split |
| `Ctrl+a -` | Horizontal split |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a r` | Reload config |
| `Alt+1~5` | Quick window switch |

### Zsh Aliases

| Alias | Command |
|-------|---------|
| `ll` | `ls -alF` |
| `vim` | `nvim` |
| `gs` | `git status` |
| `ta <name>` | `tmux attach -t <name>` |
| `tn <name>` | `tmux new -s <name>` |

## GitHub Copilot Setup

Run the following command in Neovim to set up Copilot:

```vim
:Copilot setup
```

Follow the GitHub authentication flow in your browser.

## Structure

```
config/
├── install.sh          # Install script (no sudo required)
├── README.md           # This file
├── nvim/
│   └── init.vim        # Neovim configuration
├── tmux/
│   └── .tmux.conf      # Tmux configuration
└── zsh/
    ├── .zshrc          # Zsh configuration
    └── .p10k.zsh       # Powerlevel10k theme
```

## Troubleshooting

### Powerlevel10k fonts look broken
Install a Nerd Font:
```bash
# macOS
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font

# Linux (manual install)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
unzip Meslo.zip
fc-cache -fv
```
Select the font in your terminal settings.

### Copilot not working
1. Check Node.js version: `node --version` (17 or higher required)
2. Run `:Copilot status` in Neovim
3. Re-authenticate with `:Copilot setup`

### Neovim AppImage not running
On systems without FUSE, install.sh automatically extracts the AppImage.
To extract manually:
```bash
chmod +x ~/.local/bin/nvim.appimage
~/.local/bin/nvim.appimage --appimage-extract
```
