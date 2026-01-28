# ============================================================
# Bash Profile Configuration
# ============================================================
# This file ensures that your environment is set up correctly
# when you log in with bash as the login shell.
# ============================================================

# ============================================================
# Source .profile if it exists (for common environment setup)
# ============================================================
if [ -f ~/.profile ]; then
    source ~/.profile
fi

# ============================================================
# Source .bashrc if it exists (for bash-specific interactive setup)
# ============================================================
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
