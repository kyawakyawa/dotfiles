# dotfiles

## Install Essential

- Git
- Vim
- NeoVim
- Tmux

### Vim/NeoVim

#### Install common dependencies

##### Common

- unzip (for deno install)
- deno
- Git
- The Silver Searcher Ag (optional)
- `/usr/share/dict/words` (optional) (Ex. `sudo pacman -S words` )

##### C++

- ccls
- cmake-language-server (pip install --user cmake-language-server)

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

##### for Tree Sitter
```
:TSUpdate
```

`C/C++`
```
:TSInstall c cpp cmake make cuda glsl
```

`Rust`
```
:TSInstall rust
```

`Python`
```
:TSInstall python
```

`Lua`
```
:TSInstall lua
```

`Web`
```
:TSInstall html css javascript typescript json jsonc json5 tsx
```

`TOML/YAML` 
```
:TSInstall toml yaml
```

`Vim`
```
:TSInstall vim
```

`Bash`
```
TSInstall bash
```
or

'MyTSInstall'
```
:call MyTSInstall()
```

#### プラグインの動作がおかしくなったとき

キャッシュを消してみる

```
:call dein#recache_runtimepath()
```
