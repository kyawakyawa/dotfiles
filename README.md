# dotfiles

## Install Essential

- Git
- Vim
- NeoVim
- Tmux

### Vim/NeoVim

#### Install common dependencies

- unzip (for deno install)
- deno
- Git

#### Install dein for Vim

```bash
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein_for_vim
```

In Vim

```
:call dein#install()
```

#### Install dein for Neovim

```bash
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
```

In NeoVim

```
:call dein#install()
```

#### プラグインの動作がおかしくなったとき
キャッシュを消してみる
```
:call dein#recache_runtimepath()
```
