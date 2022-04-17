#! /bin/bash

if [ ! -e ~/.vimrc ]; then ln -s ~/dotfiles/.vimrc ~/.vimrc ; else echo .vimrc is exist; fi
if [ ! -e ~/.gitconfig ]; then ln -s ~/dotfiles/.gitconfig ~/.gitconfig ; else echo .gitconfig is exist; fi
if [ ! -e ~/.tmux.conf ]; then ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf ; else echo .tmux.conf is exist; fi
mkdir -p ~/.config
if [ ! -e ~/.config/nvim ]; then ln -s ~/dotfiles/.config/nvim ~/.config/nvim ; else echo .config/nvim is exist; fi
