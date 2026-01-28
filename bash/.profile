# ============================================================
# Profile Configuration
# ============================================================
# This file is sourced by various login shells (sh, bash, etc.)
# It ensures that your environment is set up correctly
# when you log in, regardless of the login shell.
# ============================================================

# ============================================================
# PATH Configuration
# ============================================================
export PATH="$HOME/.local/bin:$PATH"

# ============================================================
# Node.js (nvm)
# ============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# ============================================================
# Environment Variables
# ============================================================
export EDITOR='nvim'
export VISUAL='nvim'
export LANG='en_US.UTF-8'

# ============================================================
# Auto-switch to Zsh if available
# ============================================================
# If zsh is available and this is an interactive shell, switch to it
if [ -z "$ZSH_NAME" ] && [ -n "$PS1" ] && command -v zsh > /dev/null 2>&1; then
    if [ -z "$ZSH_SWITCHED" ]; then
        export ZSH_SWITCHED=1
        exec zsh
    fi
fi
