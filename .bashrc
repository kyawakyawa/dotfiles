#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias pbcopy='xsel --clipboard --input'
alias c++='g++ -g -std=c++11 -Wall -O2'
alias make='make -j4'
alias vi='vim -u ~/.vim/essential.vim'
alias vim='vim -u ~/.vim/essential.vim'
alias clang++='clang++ -std=c++11 -Wall'
#alias nvim='nvim -u ~/.config/nvim/simple.vim'

#lightline用
export TERM=xterm-256color

#git branch
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh 
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM=1
    GIT_PS1_SHOWUNTRACKEDFILES=
    GIT_PS1_SHOWSTASHSTATE=1
    export PS1='\[\033[01;32m\]\u@\h\[\033[01;33m\] \w$(__git_ps1 " (%s)") \n \[\033[01;34m\]\$\[\033[00m\] '
else
    export PS1='\[\033[01;32m\]\u@\h\[\033[01;33m\] \w \n \[\033[01;34m\]\$\[\033[00m\] '
fi

if [ -d "$HOME/bin" ]; then
    export PATH="$PATH":"$HOME/bin"
fi

