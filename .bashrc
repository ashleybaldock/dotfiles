# NOT executed by login bash instances (e.g. the ones created by terminal)
# Run each time a shell is created within tmux

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Disable per-session shell command history
export SHELL_SESSION_HISTORY=0

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export PS1='\033[0;33m\]\u@\h:\033[00m\w\033[0;35m\]$(__git_ps1 " (%s)")\033[00m\]\$ '

alias ls='ls -F'
alias vi='vim'

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true


export NODE_ENV='development'
