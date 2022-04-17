#! /bin/bash

if [ ! -e ~/.vimrc ]; then ln -s ~/dotfiles/.vimrc ~/.vimrc ; else echo .vimrc is exist; fi
if [ ! -e ~/.gitconfig ]; then ln -s ~/dotfiles/.gitconfig ~/.gitconfig ; else echo .gitconfig is exist; fi
if [ ! -e ~/.config/nvim ]; then ln -s ~/dotfiles/.config/nvim ~/.config/nvim ; else echo .config/nvim is exist; fi
if [ ! -e ~/.config/.tmux.conf ]; then ln -s ~/dotfiles/.config/.tmux.conf ~/.config/.tmux.conf ; else echo .config/.tmux.conf is exist; fi
