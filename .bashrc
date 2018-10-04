#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias pbcopy='xsel --clipboard --input'
alias c++='clang++ -g -std=c++11 -Wall -O2'

#lightline用
export TERM=xterm-256color

#git branch
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh 
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWSTASHSTATE=auto
    export PS1='\[\033[01;32m\]\u@\h\[\033[01;33m\] \w$(__git_ps1 " (%s)") \n \[\033[01;34m\]\$\[\033[00m\] '
else
    export PS1='\[\033[01;32m\]\u@\h\[\033[01;33m\] \w \n \[\033[01;34m\]\$\[\033[00m\] '
fi
