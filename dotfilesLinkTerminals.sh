#! /bin/bash
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -e ~/.Xresouces ]; then ln -s "$DOTFILES_DIR/.Xresouces" ~/.Xresouces ; else echo .Xresouces is exist; fi
mkdir -p ~/.config
if [ ! -e ~/.config/alacritty ]; then ln -s "$DOTFILES_DIR/.config/alacritty" ~/.config/alacritty ; else echo .config/alacritty is exist; fi
if [ ! -e "$DOTFILES_DIR/.config/alacritty/alacritty-unix.toml" ]; then ln -s "$DOTFILES_DIR/.config/alacritty_unix/alacritty.toml" "$DOTFILES_DIR/.config/alacritty/alacritty-unix.toml" ; else echo dotfiles/.config/alacritty/alacritty-unix.toml is exist; fi
if [ ! -e ~/.config/wezterm ]; then ln -s "$DOTFILES_DIR/.config/wezterm" ~/.config/wezterm ; else echo .config/wezterm is exist; fi
if [ ! -e ~/.config/kitty ]; then ln -s "$DOTFILES_DIR/.config/kitty" ~/.config/kitty ; else echo .config/kitty is exist; fi
