#! /bin/bash
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -e ~/.vimrc ]; then ln -s "$DOTFILES_DIR/.vimrc" ~/.vimrc ; else echo .vimrc is exist; fi
if [ ! -e ~/.vim ]; then ln -s "$DOTFILES_DIR/.vim" ~/.vim ; else echo .vim is exist; fi
if [ ! -e ~/.gitconfig ]; then ln -s "$DOTFILES_DIR/.gitconfig" ~/.gitconfig ; else echo .gitconfig is exist; fi
if [ ! -e ~/.tmux.conf ]; then ln -s "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf ; else echo .tmux.conf is exist; fi
mkdir -p ~/.config
if [ ! -e ~/.config/nvim ]; then ln -s "$DOTFILES_DIR/.config/nvim" ~/.config/nvim ; else echo .config/nvim is exist; fi
if [ ! -e ~/.config/efm-langserver ]; then ln -s "$DOTFILES_DIR/.config/efm-langserver" ~/.config/efm-langserver ; else echo .config/efm-langserver is exist; fi
if [ ! -e ~/.config/lazygit ]; then ln -s "$DOTFILES_DIR/.config/lazygit" ~/.config/lazygit ; else echo .config/lazygit is exist; fi
if [ ! -e ~/.config/peco ]; then ln -s "$DOTFILES_DIR/.config/peco" ~/.config/peco ; else echo .config/peco is exist; fi

if [ ! -e ~/.config/starship.toml ]; then ln -s "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml ; else echo ~/.config/starship.toml is exist; fi

# For Arch
# if [ ! -e ~/.bashrc ]; then ln -s "$DOTFILES_DIR/.bashrc_for_arch" ~/.bashrc ; else echo .bashrc is exist; fi
