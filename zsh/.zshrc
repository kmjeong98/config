# ============================================================
# Zsh Configuration
# ============================================================

# ============================================================
# Powerlevel10k Instant Prompt
# ============================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# Powerlevel10k Theme
# ============================================================
# Load Powerlevel10k theme
if [[ -d "$HOME/.p10k" ]]; then
  source "$HOME/.p10k/powerlevel10k.zsh-theme"
fi

# Load p10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ============================================================
# History Settings
# ============================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ============================================================
# Key Bindings
# ============================================================
bindkey -e  # Emacs key bindings
bindkey '^[[A' up-line-or-search     # Up arrow for history search
bindkey '^[[B' down-line-or-search   # Down arrow for history search

# ============================================================
# Completion
# ============================================================
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ============================================================
# Aliases
# ============================================================

# List aliases (OS-aware)
if [[ "$(uname)" == "Darwin" ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Editor
alias vim='nvim'
alias vi='nvim'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -n 10'
alias gd='git diff'

# Tmux aliases
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# Safety aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# ============================================================
# PATH Configuration
# ============================================================
# Add local bin to PATH (for user-installed tools)
export PATH="$HOME/.local/bin:$PATH"

# Node.js (if using nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ============================================================
# Environment Variables
# ============================================================
export EDITOR='nvim'
export VISUAL='nvim'
export LANG='en_US.UTF-8'

# ============================================================
# Custom Functions
# ============================================================

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Quick find
qf() {
  find . -name "*$1*"
}
