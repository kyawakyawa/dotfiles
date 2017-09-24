#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias pbcopy='xsel --clipboard --input'
alias c++='g++ -g -std=c++11 -Wall -O2'
