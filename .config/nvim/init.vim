"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein/')
  call dein#begin('~/.cache/dein/')

  " Let dein manage dein
  " Required:
  "call dein#add('~/.cache/dein//repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  "call dein#add('Shougo/deoplete.nvim')
  "call dein#add('zchee/deoplete-clang')
  let g:dein_dir = expand('~/.config/nvim')
  let s:toml = g:dein_dir . '/dein.toml'
  let s:lazy_toml = g:dein_dir . '/dein_lazy.toml'

  " You can specify revision/branch/tag.
  ""call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml,{'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif



" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------



"コメントはダブルクォーテーション

syntax enable
filetype plugin indent on
set ruler
set encoding=utf-8
scriptencoding=utf-8
set number
set title
"set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
set hlsearch
set showmatch
set cindent
set showcmd
set ignorecase
set smartcase
set nowrapscan
set noincsearch
set nobackup
set backspace=indent,eol,start
"set mouse=a
inoremap { {}<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
nnoremap <C-b> :copen<Enter>:make<Enter>
nnoremap <C-u> :copen<Enter>:make run<Enter>
hi Comment ctermfg=gray
nnoremap ; :
nnoremap : ;

"htmlのカッコ補間
"augroup fileTypeIndent
"    autocmd!
"    autocmd BufNewFile,BufRead *.html inoremap < <><Left>
"augroup END

autocmd BufNewFile *.js 0r $HOME/.vim/template/javascript.js
"autocmd BufNewFile *.cpp 0r $HOME/.vim/template/cpp.cpp
"autocmd BufNewFile *.c 0r $HOME/.vim/template/cpp.cpp
"autocmd BufNewFile *.cpp :27
set dictionary=/usr/share/dict/cracklib-small
set path+=/usr/include/c++/7.1.1/x86_64-pc-linux-gnu/

autocmd BufNewFile,BufRead *.vue set filetype=html


runtime! userautoload/*.vim
