# Shell integration for ghostty
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# Enable autocompletions
autoload -Uz compinit

typeset -i updated_at=$(date +'%j' -r $HOME/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' $HOME/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist

# Enable hooks
autoload -U add-zsh-hook

# Enable zsh recompilation
autoload -Uz zrecompile

# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Stop zsh autocorrect from suggesting undesired completions
CORRECT_IGNORE_FILE=".*"
CORRECT_IGNORE="_*"

# Options
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt hist_expire_dups_first # expire duplicate entries first when trimming history
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt hist_verify # don't execute immediately upon history expansion
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances
setopt correct_all # autocorrect commands
setopt interactive_comments # allow comments in interactive shells

# Improve autocompletion style
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Theme
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  node          # Node.js section
  exec_time     # Execution time
  async         # Async jobs indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  sudo          # Sudo indicator
  line_sep      # Line break
  char          # Prompt character
)

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

# Install and load plugins
plugins=(
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-completions
  t413/zsh-background-notify
  rapgenic/zsh-git-complete-urls
  buonomo/yarn-completion
  spaceship-prompt/spaceship-prompt
)

PLUGIN_DIR=$HOME/.zsh_plugins

for plugin in $plugins; do
  if [[ ! -d $PLUGIN_DIR/${plugin:t} ]]; then
    git clone --depth 1 https://github.com/${plugin} $PLUGIN_DIR/${plugin:t}

    for f in $PLUGIN_DIR/${plugin:t}/**/*.zsh; do
      echo "Recompiling $f"
      zrecompile -pq "$f"
    done
  fi

  if [[ -f $PLUGIN_DIR/${plugin:t}/${plugin:t}.plugin.zsh ]]; then
    source $PLUGIN_DIR/${plugin:t}/${plugin:t}.plugin.zsh
  fi
done

# Load spaceship prompt
source $PLUGIN_DIR/spaceship-prompt/spaceship.zsh

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

# Open new tabs in same directory
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  function chpwd {
    printf '\e]7;%s\a' "file://$HOSTNAME${PWD// /%20}"
  }

  chpwd
fi

# Zsh notify configuration
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10

# Language
export LANGUAGE=en
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR=nano

alias dotfiles="git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

if [[ -f $HOME/.zsh_secrets.zsh ]]; then source $HOME/.zsh_secrets.zsh; fi
if [[ -f $HOME/.zsh_local.zsh ]]; then source $HOME/.zsh_local.zsh; fi

# Setup keybindings for fuzzy finder and zoxide
if [[ -x $(command -v fzf) ]]; then eval "$(fzf --zsh)"; fi
if [[ -x $(command -v zoxide) ]]; then eval "$(zoxide init zsh)"; fi

# Use fd for fzf if available
if [[ -x $(command -v fd) ]]; then
  export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --exclude .npm --exclude .cache'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git --exclude .npm --exclude .cache"

  _fzf_compgen_path() {
    fd --hidden --exclude .git --exclude .npm --exclude .cache . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --exclude .git --exclude .npm --exclude .cache . "$1"
  }
fi

# Setup aliases for alternative commands
if [[ -x $(command -v z) ]]; then alias cd="z"; fi
if [[ -x $(command -v eza) ]]; then alias ls="eza --icons=auto"; fi

# Setup podman if available
if [[ -x $(command -v podman) ]]; then
  PODMAN_SOCKET=$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)

  if [[ -n "$PODMAN_SOCKET" ]]; then
    export DOCKER_HOST="unix://$PODMAN_SOCKET"
  fi
fi

# Setup rbenv if available
if [[ -x $(command -v rbenv) ]]; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

# Setup sdkman if available
if [[ -z "$SDKMAN_DIR" && -x $(command -v brew) ]]; then
  export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
fi

if [[ -n "$SDKMAN_DIR" && -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

if [[ $(uname) == "Darwin" ]]; then
  alias nix-rebuild="nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake $HOME/.nix/darwin#default"
fi

if [[ $(uname) == "Linux" && -f "$HOME/.nix/$(hostname)/flake.nix" ]]; then
  alias nix-rebuild="sudo nixos-rebuild switch --flake $HOME/.nix/$(hostname)"
fi

export BAT_THEME="OneHalfDark"

# Use correct node version based on .nvmrc
switch-node() {
  if [[ (( $+commands[n] )) && -f ".nvmrc" ]]; then
    local node_auto_version="v$(n ls-remote auto --all 2>/dev/null | head -n 1)"
    local node_active_version="$(node --version 2>/dev/null)"

    if [[ "$node_auto_version" != "$node_active_version" ]]; then
      n auto
    fi
  fi
}

add-zsh-hook chpwd switch-node
switch-node
