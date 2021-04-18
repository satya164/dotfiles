if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

export PS1="\[\033[38;5;78m\]\W\[\033[m\]\[\033[38;5;221m\]\[\033[m\]\n\[\033[36m\]❯\[\033[m\] "

export CLICOLOR=1

export LSCOLORS=ExFxBxDxCxegedabagacad

export EDITOR=/usr/bin/nano

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

if [ -f ~/.git-completion.sh ]; then
  . ~/.git-completion.sh
fi

if [ -f ~/.bashrc_secrets ]; then source ~/.bashrc_secrets; fi
if [ -f ~/.bash_local.inc ]; then source ~/.bash_local.inc; fi