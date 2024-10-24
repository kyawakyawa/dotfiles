#! /bin/bash
if [ ! -e ~/.Xresouces ]; then ln -s ~/dotfiles/.Xresouces ~/.Xresouces ; else echo .Xresouces is exist; fi
mkdir -p ~/.config
if [ ! -e ~/.config/alacritty ]; then ln -s ~/dotfiles/.config/alacritty ~/.config/alacritty ; else echo .config/alacritty is exist; fi
if [ ! -e ~/dotfiles/.config/alacritty/alacritty-unix.toml ]; then ln -s ~/dotfiles/.config/alacritty_unix/alacritty.toml ~/dotfiles/.config/alacritty/alacritty-unix.toml ; else echo dotfiles/.config/alacritty/alacritty-unix.toml is exist; fi
if [ ! -e ~/.config/wezterm ]; then ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm ; else echo .config/wezterm is exist; fi
if [ ! -e ~/.config/kitty ]; then ln -s ~/dotfiles/.config/kitty ~/.config/kitty ; else echo .config/kitty is exist; fi
