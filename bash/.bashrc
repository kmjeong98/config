# ============================================================
# Bashrc Configuration
# ============================================================
# This file provides bash-specific interactive shell configuration
# Environment variables should be set in .profile
# ============================================================

# ============================================================
# If not running interactively, don't do anything
# ============================================================
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================================
# Basic Aliases
# ============================================================
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
alias vi='nvim'
alias gs='git status'
