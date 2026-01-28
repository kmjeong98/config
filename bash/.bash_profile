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
# Auto-switch to Zsh if available
# ============================================================
# If zsh is available and this is an interactive bash shell, switch to it
if [ -n "$BASH" ] && [ -z "$ZSH_NAME" ] && [ -n "$PS1" ] && command -v zsh &> /dev/null; then
    if [ -z "$ZSH_SWITCHED" ]; then
        export ZSH_SWITCHED=1
        exec zsh
    fi
fi
