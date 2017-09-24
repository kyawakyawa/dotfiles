"コメントはダブルクォーテーション

syntax enable
filetype plugin indent on
set ruler
set encoding=utf-8
scriptencoding=utf-8
set number
set title
set expandtab
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
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.html inoremap < <><Left>
augroup END

autocmd BufNewFile *.js 0r $HOME/.vim/template/javascript.js
autocmd BufNewFile *.cpp 0r $HOME/.vim/template/cpp.cpp
autocmd BufNewFile *.c 0r $HOME/.vim/template/cpp.cpp
"autocmd BufNewFile *.cpp :27
