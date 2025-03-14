# Shell integration for ghostty
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

if [[ `command -v brew` && -f `brew --prefix`/etc/bash_completion ]]; then
    . `brew --prefix`/etc/bash_completion
fi

export PS1="\[\033[38;5;78m\]\W\[\033[m\]\[\033[38;5;221m\]\[\033[m\]\n\[\033[36m\]❯\[\033[m\] "

export CLICOLOR=1

export LSCOLORS=ExFxBxDxCxegedabagacad

export LANGUAGE=en
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR=nvim

alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"

if [ -f ~/.git-completion.sh ]; then
  . ~/.git-completion.sh
fi

if [ -f ~/.bash_secrets.sh ]; then source ~/.bash_secrets.sh; fi
if [ -f ~/.bash_local.sh ]; then source ~/.bash_local.sh; fi
