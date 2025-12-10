#! /bin/bash
if [ ! -e ~/.vimrc ]; then ln -s ~/dotfiles/.vimrc ~/.vimrc ; else echo .vimrc is exist; fi
if [ ! -e ~/.vim ]; then ln -s ~/dotfiles/.vim ~/.vim ; else echo .vim is exist; fi
if [ ! -e ~/.gitconfig ]; then ln -s ~/dotfiles/.gitconfig ~/.gitconfig ; else echo .gitconfig is exist; fi
if [ ! -e ~/.tmux.conf ]; then ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf ; else echo .tmux.conf is exist; fi
mkdir -p ~/.config
if [ ! -e ~/.config/nvim ]; then ln -s ~/dotfiles/.config/nvim ~/.config/nvim ; else echo .config/nvim is exist; fi
if [ ! -e ~/.config/efm-langserver ]; then ln -s ~/dotfiles/.config/efm-langserver ~/.config/efm-langserver ; else echo .config/efm-langserver is exist; fi
if [ ! -e ~/.config/lazygit ]; then ln -s ~/dotfiles/.config/lazygit ~/.config/lazygit ; else echo .config/lazygit is exist; fi

# For Arch
# if [ ! -e ~/.bashrc ]; then ln -s ~/dotfiles/.bashrc_for_arch ~/.bashrc ; else echo .bashrc is exist; fi
