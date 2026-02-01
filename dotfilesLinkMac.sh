#! /bin/bash
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -e ~/.zprofile ]; then ln -s "$DOTFILES_DIR/.zprofile_for_mac" ~/.zprofile ; else echo .zprofile is exist; fi
if [ ! -e ~/.zshrc ]; then ln -s "$DOTFILES_DIR/.zshrc_for_mac" ~/.zshrc ; else echo .zprofile is exist; fi
