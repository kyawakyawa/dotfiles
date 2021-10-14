"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('~/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

let g:dein_dir = expand('~/.config/nvim')

let s:vim_denops_toml = g:dein_dir . '/vim-denops.toml'
"let s:ddc_toml = g:dein_dir . '/ddc.toml'
let s:ddc_nvim_lsp_toml = g:dein_dir . '/ddc-nvim-lsp.toml'
let s:git_toml = g:dein_dir . '/git.toml'
let s:vim_airline_toml = g:dein_dir . '/vim-airline.toml'
let s:fzf_toml = g:dein_dir . '/fzf.toml'
let s:solarized_toml = g:dein_dir . '/solarized.toml'

call dein#load_toml(s:vim_denops_toml, {'lazy': 1})
"call dein#load_toml(s:ddc_toml, {'lazy': 1})
call dein#load_toml(s:ddc_nvim_lsp_toml, {'lazy': 1})
call dein#load_toml(s:git_toml, {'lazy': 0})
call dein#load_toml(s:vim_airline_toml, {'lazy': 0})
call dein#load_toml(s:fzf_toml, {'lazy': 1})
call dein#load_toml(s:solarized_toml, {'lazy': 0})

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

" Essential
set nocompatible
filetype plugin on
set number
syntax enable
set expandtab
set tabstop=2
set shiftwidth=2
set cindent
set hlsearch
set cursorline
set smartindent

" For plugins

"" gitgutter

""" solarizedを導入したときにこちらに移動しないとだめだった
let g:gitgutter_override_sign_column_highlight=0
highlight! link SignColumn LineNr " Sign Columnのハイライトを無効化
