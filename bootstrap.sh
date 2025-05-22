#!/bin/bash
set -e

TMP_DIR="$HOME/.config-temp"

git clone --depth=1 https://github.com/kunmo/dotfiles.git "$TMP_DIR"
cd "$TMP_DIR"
./install.sh
cd ~
rm -rf "$TMP_DIR"

