if [[ `command -v brew` && -f `brew --prefix`/etc/bash_completion ]]; then
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

if [ -f ~/.bash_secrets.sh ]; then source ~/.bash_secrets.sh; fi
if [ -f ~/.bash_local.sh ]; then source ~/.bash_local.sh; fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
