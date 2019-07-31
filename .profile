# Only executed by login shells
# NOT executed by shells created within tmux

export PATH=/usr/local/opt/gnu-tar/libexec/gnubin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Setting PATH for Python 2.7
# The original version is saved in .profile.pysave
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

# Add dotnet tools to path if installed
if [ -d /usr/local/share/dotnet ]; then
  export PATH="/usr/local/share/dotnet:~/.dotnet/tools:${PATH}"
fi

# Start ssh-agent if it isn't already
# Add new ssh keys with ssh-add -K <key>
# They will be added automatically from keychain
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add -A;
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    PID_PROCESS=$(ps ${SSH_AGENT_PID} | awk '{print $5}' | sed 1d)
    if [ "$PID_PROCESS" != "/usr/bin/ssh-agent" ]; then
      start_agent
    fi
else
    start_agent;
fi

# Also source .bashrc for terminal shells
source ~/.bashrc
