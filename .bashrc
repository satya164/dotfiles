if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

export PS1="\[\033[38;5;78m\]\W\[\033[m\]\[\033[38;5;221m\]\[\033[m\]\n\[\033[36m\]❯\[\033[m\] "

export CLICOLOR=1

export LSCOLORS=ExFxBxDxCxegedabagacad

export EDITOR=/usr/bin/nano

if [ -f ~/.git-completion.sh ]; then
  . ~/.git-completion.sh
fi

if [ -f ~/.secrets.bash.inc ]; then source ~/.secrets.bash.inc; fi
if [ -f ~/.local_config.bash.inc ]; then source ~/.local_config.bash.inc; fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
