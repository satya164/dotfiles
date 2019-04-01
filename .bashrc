if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

export PS1="\[\033[38;5;78m\]\W\[\033[m\]\[\033[38;5;221m\]\$(__git_ps1)\[\033[m\] \[\033[36m\]❯\[\033[m\] "

export CLICOLOR=1

export LSCOLORS=ExFxBxDxCxegedabagacad

export EDITOR=/usr/bin/nano

if [ -f ~/.git-completion.sh ]; then
  . ~/.git-completion.sh
fi
