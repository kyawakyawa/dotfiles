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
let s:nvim_cmp_lsp_toml = g:dein_dir . '/nvim-cmp-lsp.toml'
let s:lsp_symbols_and_tags_toml = g:dein_dir . '/lsp_symbols_and_tags.toml'
let s:git_toml = g:dein_dir . '/git.toml'
let s:vim_airline_toml = g:dein_dir . '/vim-airline.toml'
let s:lualine_toml = g:dein_dir . '/lualine.toml'
let s:fzf_toml = g:dein_dir . '/fzf.toml'
let s:telescope_toml = g:dein_dir . '/telescope.toml'
let s:solarized_toml = g:dein_dir . '/solarized.toml'
let s:brackets_toml = g:dein_dir . '/brackets.toml'
let s:file_explorer_toml = g:dein_dir . '/file-explorer.toml'
let s:syntax_hightlight_toml = g:dein_dir . '/syntax-highlight.toml'
let s:debugger_toml = g:dein_dir . '/debugger.toml'
let s:nvim_dap_toml = g:dein_dir . '/nvim-dap.toml'
let s:markdown_toml = g:dein_dir . '/markdown.toml'

call dein#load_toml(s:vim_denops_toml, {'lazy': 1})
"call dein#load_toml(s:ddc_toml, {'lazy': 1})
call dein#load_toml(s:ddc_nvim_lsp_toml, {'lazy': 1})
"call dein#load_toml(s:nvim_cmp_lsp_toml, {'lazy': 1})
"call dein#load_toml(s:lsp_symbols_and_tags_toml, {'lazy': 0})
call dein#load_toml(s:git_toml, {'lazy': 0})
"call dein#load_toml(s:vim_airline_toml, {'lazy': 0})
call dein#load_toml(s:lualine_toml, {'lazy': 0})
"call dein#load_toml(s:fzf_toml, {'lazy': 1})
call dein#load_toml(s:telescope_toml, {'lazy': 0})
call dein#load_toml(s:solarized_toml, {'lazy': 0})
call dein#load_toml(s:brackets_toml, {'lazy': 0})
call dein#load_toml(s:file_explorer_toml, {'lazy': 0})
call dein#load_toml(s:syntax_hightlight_toml, {'lazy': 1})
"call dein#load_toml(s:debugger_toml, {'lazy': 1})
call dein#load_toml(s:nvim_dap_toml, {'lazy': 1})
call dein#load_toml(s:markdown_toml, {'lazy': 0})

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
set hidden

" For IME
function! ImeOff()
  call system('fcitx5-remote -c')
endfunction
autocmd InsertLeave * call ImeOff()

" For OpenCL
autocmd BufNewFile,BufRead *.cl  set filetype=cl

" Terminal
" TerminalモードでEscでエスケープ [参考] https://neovim.io/doc/user/nvim_terminal_emulator.html
tnoremap <Esc> <C-\><C-n>

" For plugins

"" gitgutter

" TODO(kyawakyawa) Delete
" "" solarizedを導入したときにこちらに移動しないとだめだった
" let g:gitgutter_override_sign_column_highlight=0
" highlight! link SignColumn LineNr " Sign Columnのハイライトを無効化
