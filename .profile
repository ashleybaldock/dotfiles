# Only executed by login shells
# NOT executed by shells created within tmux

export PATH=/usr/local/opt/gnu-tar/libexec/gnubin:$PATH

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

# Also source .bashrc for terminal shells
source ~/.bashrc
