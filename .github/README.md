# dotfiles

This repo is managed using a git bare repository.

To install and restore settings on a fresh system:

```sh
alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"
mv $HOME/.zshrc $HOME/.zshrc.bak
mv $HOME/.bashrc $HOME/.bashrc.bak
echo ".dot.git" >> .gitignore
git clone --bare git@github.com:satya164/dotfiles.git $HOME/.dot.git
dot config --local status.showUntrackedFiles no
```

Then sync the files with:

```sh
dot checkout
```

If there are conflicts with existing files, backup them and delete them.

To setup this workflow on a new system:

```sh
git init --bare $HOME/.dot.git
echo 'alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"' >> $HOME/.zshrc
source $HOME/.zshrc
dot config --local status.showUntrackedFiles no
```

To make iTerm2 use the config from this repo:

```sh
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm2_config"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
```
