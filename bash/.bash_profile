# ============================================================
# Bash Profile Configuration
# ============================================================
# This file ensures that your environment is set up correctly
# when you log in, even if your default shell is bash.
# ============================================================

# ============================================================
# Source .bashrc if it exists
# ============================================================
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# ============================================================
# PATH Configuration
# ============================================================
# Add local bin to PATH (for user-installed tools)
export PATH="$HOME/.local/bin:$PATH"

# ============================================================
# Node.js (nvm)
# ============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ============================================================
# Environment Variables
# ============================================================
export EDITOR='nvim'
export VISUAL='nvim'

# ============================================================
# Auto-switch to Zsh if available
# ============================================================
# If zsh is available and this is an interactive shell, switch to it
if [ -n "$PS1" ] && command -v zsh &> /dev/null && [ "$SHELL" != "$(command -v zsh)" ]; then
    export SHELL="$(command -v zsh)"
    if [ -z "$ZSH_SWITCHED" ]; then
        export ZSH_SWITCHED=1
        exec zsh
    fi
fi
