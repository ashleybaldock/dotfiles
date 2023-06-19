# NOT executed by login bash instances (e.g. the ones created by terminal)
# Run each time a shell is created within tmux

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


## SSH
# Start ssh-agent if it isn't already
# Add new ssh keys with ssh-add -K <key>
# They will be added automatically from keychain
SSH_ENV="$HOME/.ssh/environment"

function new_ssh_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  source "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add --apple-load-keychain;
}

function start_agent {
  if [ -f "${SSH_ENV}" ]; then
      source "${SSH_ENV}" > /dev/null
      PID_PROCESS=$(ps ${SSH_AGENT_PID} | awk '{print $5}' | sed 1d)
      if [ "$PID_PROCESS" != "/usr/bin/ssh-agent" ]; then
        new_ssh_agent
      fi
  else
      new_ssh_agent;
  fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  start_agent
fi


## Shell config
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

alias ls='ls -F'
if [ -f /Applications/MacVim.app/Contents/MacOS/Vim ]; then
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
  alias mvim='vim -g'
  export VISUAL='vim -f'
  export EDITOR='vim -f'
fi
alias vi='vim'

alias j='jobs'

alias notify="terminal-notifier -message 'Command completed'"

## git
alias gu='echo "User config: $(git config --get user.name) <$(git config --get user.email)>"'
alias gl="git log --color --pretty=format:'%C(auto)%h %Cred %<(10,trunc)%an %Creset%C(auto)%s %Cgreen(%cr,%ar) %Creset%C(auto)%d'"
alias gb="git branch"
alias gp="git push"
alias gpu="git pull"
alias gpull="git pull"
alias gpb='git push -u origin $(git branch | grep \* | cut -d " " -f2)'
alias gs="gu && git status"
alias gm="git merge"
alias gmm='git merge $(git remote show origin | grep "HEAD branch" | sed "s/.*: //")'
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gdd="git diff --staged"
alias gco="git checkout"
alias gcb="git checkout -b"

# Open github for repo (base path)
gh() {
  open $(git config remote.origin.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")/$1$2
}
# Open github for branch (base path)
ghb() {
  gh tree/$(git symbolic-ref --quiet --short HEAD)
}
# Open github for repo (current path)
gho() {
  gh tree/master/$(git rev-parse --show-prefix)
}
# Open github for branch (current path)
ghob() {
  gh tree/$(git symbolic-ref --quiet --short HEAD)/$(git rev-parse --show-prefix)
}
# Open new PR for current branch against parent branch
# See parent alias in .gitconfig
ghpr() {
  gh compare/$(git parent)...$(git symbolic-ref --quiet --short HEAD)?expand=1
}
alias ghbo="ghob"


## node & nvm
if [ -z "$NVM_DIR" ]; then
  export NVM_DIR="$HOME/.nvm"
fi

# If using nvm set up lazy loading
# First time node/npm/nvm are run this loads nvm
# If not using nvm node will come from brew or system path
if [ -d "$NVM_DIR" ] && [ -z "$NVM_BIN" ]; then
  nvmload() {
    unset -f nvm
    unset -f node
    unset -f npm
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    unset -f nvmload
  }

  # Lazy load nvm first time commands are run
  # $PATH with npm etc. will be setup by containing shell
  node() {
    nvmload
    node "$@"
  }
  npm() {
    nvmload
    npm "$@"
  }
  nvm() {
    nvmload
    nvm "$@"
  }
fi


## Bash completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && source "/opt/homebrew/etc/profile.d/bash_completion.sh"

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  source /usr/local/share/bash-completion/bash_completion
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true


## tmux
# Split current pane into equal two-part columns in different directories
# Configure in .bashrc.local with an array and pass it as an alias, e.g.:
# splits=($HOME/some/path, $HOME/another/path)
# alias tmux_split_name='tmux_split splits'
function tmux_split {
  local paths=("$@")

  initialPaneId=$TMUX_PANE
  width=$(($(tmux display -p '#{pane_width}') / ${#paths[@]}))

  cd "${paths[0]}"
  tmux split-window -v

  for i in "${paths[@]:1}"
  do
    cd "$i"
    tmux split-window -h -f -l $width
    tmux split-window -v
  done

  cd "${paths[0]}"
  tmux resize-pane -t $initialPaneId -x $width
  tmux select-pane -t $initialPaneId
}


## Other bits
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi

export PS1='\[\033[0;33m\]\u@\h:\[\033[00m\]\w\[\033[0;35m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '

