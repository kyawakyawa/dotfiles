#! /bin/bash
if [ ! -e ~/.config/efm-langserver ]; then ln -s ~/dotfiles/.config/efm-langserver ~/.config/efm-langserver ; else echo .config/efm-langserver is exist; fi
if [ ! -e ~/.config/nvim ]; then ln -s ~/dotfiles/.config/nvim ~/.config/nvim ; else echo .config/nvim is exist; fi
