# ============================================================
# Zsh Profile Configuration
# ============================================================
# This file is sourced by zsh login shells before .zshrc
# It ensures that essential environment setup happens first
# ============================================================

# ============================================================
# PATH Configuration
# ============================================================
# Add local bin to PATH (for user-installed tools)
export PATH="$HOME/.local/bin:$PATH"

# ============================================================
# Node.js (nvm)
# ============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ============================================================
# Environment Variables
# ============================================================
export EDITOR='nvim'
export VISUAL='nvim'
export LANG='en_US.UTF-8'
