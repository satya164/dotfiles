# dotfiles

This repo is managed using a git bare repository.

To setup the workflow and restore settings to a new system:

```sh
echo ".dot.git" >> .gitignore
git clone --bare git@github.com:satya164/dotfiles.git $HOME/.dot.git
alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"
dot config --local status.showUntrackedFiles no
```

Then sync the files with:

```sh
dot checkout
```

If there are conflicts with existing files, backup them and delete them.

To setup this workflow from scratch:

```sh
git init --bare $HOME/.dot.git
echo 'alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"' >> $HOME/.zshrc
source $HOME/.zshrc
dot config --local status.showUntrackedFiles no
```

To [install Nix on MacOS](https://lix.systems/install/#on-any-other-linuxmacos-system), run:

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```
