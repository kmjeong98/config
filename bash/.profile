# ============================================================
# Profile Configuration
# ============================================================
# This file is sourced by various login shells (sh, bash, etc.)
# It ensures that your environment is set up correctly
# when you log in, regardless of the login shell.
# ============================================================

# ============================================================
# Source .bashrc if it exists and we're running bash
# ============================================================
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

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
