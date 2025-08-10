# Only executed by login shells
# NOT executed by shells created within tmux

## homebrew
if [ -r "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add dotnet tools to path if installed
if [ -d /usr/local/share/dotnet ]; then
  export PATH="/usr/local/share/dotnet:~/.dotnet/tools:${PATH}"
fi

# Add ruby to path if installed
if [ -d /usr/local/opt/ruby/bin ]; then
  export PATH="/usr/local/opt/ruby/bin:${PATH}"
fi
if [ -d $HOME/.gem/ruby/2.7.0/bin ]; then
  export PATH="$HOME/.gem/ruby/2.7.0/bin:${PATH}"
elif [ -d $HOME/.gem/ruby/2.6.0/bin ]; then
  export PATH="$HOME/.gem/ruby/2.6.0/bin:${PATH}"
fi

if [ -d $HOME/dotfiles/bin ]; then
  export PATH="$HOME/dotfiles/bin:${PATH}"
fi

## python
### unversioned aliases to python3
if [ -d '/opt/homebrew/opt/python@3.11/libexec/bin' ]; then
  export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:${PATH}"
fi

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

## ngrok
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi


# Also source .bashrc for terminal shells
source ~/.bashrc
