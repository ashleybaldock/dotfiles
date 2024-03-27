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

# tabtab source for packages (pnpm)
[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash || true

alias p="pnpm" && complete -o default -F _pnpm_completion p

## Git
gitSubmodulesHaveChanges() {
  git submodule status | grep '^[^ ]'
}
gitRemoteHeadName() {
# git remote show origin | grep "HEAD branch" | sed "s/.*: //")
  basename $(git symbolic-ref --quiet --short refs/remotes/origin/HEAD)
}
gitCurrentBranchName() {
  git symbolic-ref --quiet --short HEAD
}
gitCurrentPathInRepo() {
  git rev-parse --show-prefix
}

alias gu='echo "User config: $(git config --get user.name) <$(git config --get user.email)>"'
alias gl="git log --color --pretty=format:'%C(auto)%h %Cred %<(10,trunc)%an %Creset%C(auto)%s %Cgreen(%cr,%ar) %Creset%C(auto)%d'"
alias gb="git branch" && __git_complete gb git_branch
alias gp="git push" && __git_complete gp git_push
alias gpu="git pull" && __git_complete gpu git_pull
# alias gpull="git pull" && __git_complete gpull git_pull
alias gpb='git push -u origin $(git branch | grep \* | cut -d " " -f2)'
alias gs="gu && git status" && __git_complete gs git_status
alias gm="git merge" && __git_complete gm git_merge
alias gmm='git checkout $(gitRemoteHeadName) && git pull --commit --no-edit --ff-only && git checkout - && git merge --commit --no-edit $(gitRemoteHeadName)'
alias ga="git add" && __git_complete ga git_add
alias gc="git commit" && __git_complete gc git_commit
alias gcq="gc -n -m'quick commit'"
alias gcn="gc -n -m'"
alias gd="git diff" && __git_complete gd git_diff
alias gdd="git diff --staged" && __git_complete gdd git_diff
alias gco="git checkout" && __git_complete gco git_checkout
alias gcol='git checkout -'
alias gcom='git checkout $(gitRemoteHeadName)' && __git_complete gco git_checkout
alias gcb="git checkout -b" && __git_complete gcb git_checkout
alias gst="git stash" && __git_complete gst git_stash
alias gstls="git stash list" && __git_complete gstls git_stash

# Open github for repo (base path)
gh() {
  open $(git config remote.origin.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")/$1$2
}
# Open github for branch (base path)
ghb() {
  gh tree/$(gitCurrentBranchName)
}
# Open github for repo (current path)
gho() {
  gh tree/master/$(gitCurrentPathInRepo)
}
# Open github for branch (current path)
ghob() {
  gh tree/$(gitCurrentBranchName)/$(gitCurrentPathInRepo)
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
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# If using nvm set up lazy loading
# First time node/npm/nvm are run this loads nvm
# If not using nvm node will come from brew or system path
if [ -d "$NVM_DIR" ] && [ -z "$NVM_BIN" ]; then
  nvmload() {
    unset -f nvm
    unset -f node
    unset -f npm
    unset -f yarn
    unset -f pnpm
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
  yarn() {
    nvmload
    yarn "$@"
  }
  pnpm() {
    nvmload
    pnpm "$@"
  }
fi

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

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=auto
export PS1='\[\033[0;33m\]\u@\h:\[\033[00m\]\w\[\033[0;35m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '



# pnpm
export PNPM_HOME="/Users/ashley/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
