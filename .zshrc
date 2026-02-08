# Shell integration for ghostty
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# Set up git bare repository for dotfiles
alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"

# Setup aliases for nix
if [[ -f "$HOME/.nix/flake.nix" ]]; then
  case "$(uname)" in
    Darwin)
      alias nix-rebuild="sudo darwin-rebuild switch --flake $HOME/.nix#default"
      ;;
    Linux)
      alias nix-rebuild="sudo nixos-rebuild switch --flake $HOME/.nix"
      ;;
  esac
fi

# Load local secrets and configurations
if [[ -f $HOME/.zsh_secrets.zsh ]]; then source $HOME/.zsh_secrets.zsh; fi
if [[ -f $HOME/.zsh_local.zsh ]]; then source $HOME/.zsh_local.zsh; fi

# Add local bin directory to path
export PATH="$HOME/.local/bin:$PATH";

# Language
export LANGUAGE=en
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR=nvim

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

# Enable hooks
autoload -U add-zsh-hook

# Enable zsh recompilation
autoload -Uz zrecompile

# Install and load plugins
plugins=(
  Aloxaf/fzf-tab
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-completions
  buonomo/yarn-completion
  spaceship-prompt/spaceship-prompt
)

PLUGIN_DIR=$HOME/.zsh_plugins

for plugin in $plugins; do
  local name=${plugin:t}
  local plugin_path=$PLUGIN_DIR/$name

  # Install missing or uninitialized plugin directories
  if [[ ! -f $plugin_path/.git ]]; then
    dot submodule update --init --depth 1 $plugin_path 2>/dev/null ||
      dot submodule add --depth 1 https://github.com/$plugin $plugin_path
  fi

  # Recompile stale .zwc files
  for f in $plugin_path/**/*.zsh; do
    if [[ ! -f $f.zwc || $f -nt $f.zwc ]]; then
      zrecompile -pq "$f"
    fi
  done

  # Source the plugin
  if [[ -f $plugin_path/$name.plugin.zsh ]]; then
    source $plugin_path/$name.plugin.zsh
  fi
done

# Load spaceship prompt
source $PLUGIN_DIR/spaceship-prompt/spaceship.zsh

# Enable autocompletions
autoload -Uz compinit

# Load completions from cache if it's updated today
if [[ $(date +'%j' -r $HOME/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' $HOME/.zcompdump 2>/dev/null) -eq $(date +'%j') ]]; then
  compinit -C -i
else
  compinit -i
fi

zmodload -i zsh/complist

# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh_history # path to the history file
HISTSIZE=100000 # number of history items to store in memory
HISTDUP=erase # remove older duplicate entries from history
SAVEHIST=$HISTSIZE # number of history items to save to the history file

# Stop zsh autocorrect from suggesting undesired completions
CORRECT_IGNORE_FILE=".*"
CORRECT_IGNORE="_*"

# Options
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt hist_expire_dups_first # expire duplicate entries first when trimming history
setopt hist_find_no_dups # don't display duplicate entries in history
setopt hist_ignore_space # ignore commands starting with space
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt hist_save_no_dups # don't save duplicate entries in history
setopt hist_verify # don't execute immediately upon history expansion
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances
setopt correct_all # autocorrect commands
setopt interactive_comments # allow comments in interactive shells

# Improve autocompletion style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # colorize filenames
zstyle ':completion:*' menu no # disable menu completion for fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # preview directory contents with cd
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath' # preview directory contents with zoxide
zstyle ':fzf-tab:*' use-fzf-default-opts yes # use FZF_DEFAULT_OPTS for fzf-tab

# Keybindings
bindkey '^[[A' history-substring-search-up # up arrow
bindkey '^[[B' history-substring-search-down # down arrow
bindkey '^[[3~' delete-char # delete key

# Disable paste highlighting for syntax-highlighting plugin
zle_highlight+=(paste:none)

# Open new tabs in same directory
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  function chpwd {
    printf '\e]7;%s\a' "file://$HOSTNAME${PWD// /%20}"
  }

  chpwd
fi

# Setup zoxide as a replacement for cd
if [[ -x $(command -v zoxide) ]]; then eval "$(zoxide init --cmd cd zsh)"; fi

# Setup fuzzy finder
export FZF_DEFAULT_OPTS=" \
--color=bg+:#424762,spinner:#b0bec5,hl:#f78c6c \
--color=fg:#bfc7d5,header:#ff9e80,info:#82aaff,pointer:#a5adce \
--color=marker:#89ddff,fg+:#eeffff,prompt:#c792ea,hl+:#ff9e80 \
--color=selected-bg:#424762"

if [[ -x $(command -v fzf) ]]; then eval "$(fzf --zsh)"; fi

# Use fd instead of find for fzf if available
if [[ -x $(command -v fd) ]]; then
  export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"

  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --exclude .git . "$1"
  }
fi

# Setup bat if available
if [[ -x $(command -v bat) ]]; then
  export BAT_THEME="base16"

  alias cat="bat --style=plain --paging=never"
fi

# Setup lazydocker to use podman if available
if [[ -z $DOCKER_HOST && -x $(command -v podman) ]]; then
  lazydocker() {
    local podman_socket="$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)"

    DOCKER_HOST="unix://${podman_socket}" command lazydocker $@
  }
fi

# Setup sdkman if available
if [[ -z $SDKMAN_DIR && -x $(command -v brew) ]]; then
  export SDKMAN_DIR="$(brew --prefix sdkman-cli 2>/dev/null)/libexec"
fi

if [[ -n $SDKMAN_DIR ]]; then
  export SDKMAN_CANDIDATES_DIR="$SDKMAN_DIR/candidates"
  export JAVA_HOME="$SDKMAN_CANDIDATES_DIR/java/current"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

sdk() {
  unset -f sdk

  if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
  fi

  sdk $@
}

# Setup Android SDK if available
if [[ -z $ANDROID_HOME && -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
fi

if [[ -n $ANDROID_HOME ]]; then
  export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
fi

# Setup rbenv if available
# This is not in .zprofile because it's not needed for non-interactive shells
if [[ -x $(command -v rbenv) ]]; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

# Use correct node version based on .nvmrc
if [[ -x $(command -v fnm) ]]; then
  eval "$(fnm env --use-on-cd --shell zsh | sed 's/-unchanged/& --install-if-missing/')"
fi

# Transparently use the correct package manager
pm() {
  local pm curdir input_pm input_cmd

  input_pm="${0##*/}"

  if [[ $input_pm == pm && ($1 == yarn || $1 == npm || $1 == pnpm) ]]; then
    input_pm=$1
    shift
  fi

  curdir=$PWD

  local lockfile_name=""

  while [[ $curdir != $HOME && $curdir != / ]]; do
    if [[ -f "$curdir/package-lock.json" ]]; then
      pm=npm
      lockfile_name="package-lock.json"
      break
    elif [[ -f "$curdir/pnpm-lock.yaml" ]]; then
      pm=pnpm
      lockfile_name="pnpm-lock.yaml"
      break
    elif [[ -f "$curdir/yarn.lock" ]]; then
      pm=yarn
      lockfile_name="yarn.lock"
      break
    fi

    curdir=$(dirname "$curdir")
  done

  if [[ -z $pm || $pm == $input_pm ]]; then
    command $input_pm "$@"
    return $?
  fi

  local cmd

  if [[ -z $1 ]]; then
    if [[ $input_pm == yarn ]]; then
      cmd=install
    else
      command $input_pm
      return $?
    fi
  else
    cmd=$1
    shift
  fi

  local -A map_npm=(
    [add]=install
    [remove]=uninstall [rm]=uninstall [del]=uninstall [delete]=uninstall
    [why]=explain
    [upgrade]=update
    [ls]=list
    [run]=run [exec]=run
  )

  local -A map_yarn=(
    [install]=install [add]=add [remove]=remove [why]=why
    [upgrade]=upgrade [ls]=list [run]=run [exec]=run
  )

  local -A map_pnpm=(
    [install]=install [add]=add [remove]=remove [why]=why
    [upgrade]=update [ls]=list [run]=run [exec]=run
  )

  local mapped

  if [[ $pm == npm ]]; then
    mapped=${map_npm[$cmd]:-$cmd}
  elif [[ $pm == pnpm ]]; then
    mapped=${map_pnpm[$cmd]:-$cmd}
  else
    mapped=${map_yarn[$cmd]:-$cmd}
  fi

  local supported=0

  if [[ $pm == npm && -n ${map_npm[$cmd]+_} ]]; then
    supported=1
  elif [[ $pm == pnpm && -n ${map_pnpm[$cmd]+_} ]]; then
    supported=1
  elif [[ $pm == yarn && -n ${map_yarn[$cmd]+_} ]]; then
    supported=1
  fi

  local is_script=0

  if [[ -n $cmd && $cmd != -* && -f package.json ]]; then
    jq -e --arg s "$cmd" '.scripts[$s] != null' package.json >/dev/null 2>&1 && is_script=1
  fi

  if [[ $supported -eq 1 || $is_script -eq 1 ]]; then
    echo -e "\033[43;30m WARN \033[0m Found $lockfile_name, using $pm" >&2

    if [[ $is_script -eq 1 && $supported -eq 0 ]]; then
      command $pm run $cmd "$@"
    else
      command $pm $mapped "$@"
    fi

    return $?
  fi

  command $input_pm $cmd "$@"
  return $?
}

alias yarn='pm yarn'
alias npm='pm npm'
alias pnpm='pm pnpm'
