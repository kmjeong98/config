# ============================================================
# Bashrc Configuration
# ============================================================
# This file provides basic bash configuration and ensures
# PATH is set correctly even when not using zsh
# ============================================================

# ============================================================
# If not running interactively, don't do anything
# ============================================================
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================================
# PATH Configuration
# ============================================================
export PATH="$HOME/.local/bin:$PATH"

# ============================================================
# Node.js (nvm)
# ============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============================================================
# Basic Aliases
# ============================================================
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
alias vi='nvim'
alias gs='git status'

# ============================================================
# Environment Variables
# ============================================================
export EDITOR='nvim'
export VISUAL='nvim'
