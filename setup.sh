#!bin/bash

mkdir ~/.config
mkdir ~/.config/tmux
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/share/zsh
mkdir ~/.cache/zsh

ZDOTDIR="$HOME/.local/share/zsh"
CFG_PWD="$(pwd)"

ln -s ${CFG_PWD}/nvim/config ${HOME}/.config/nvim
ln -s ${CFG_PWD}/tmux/tmux.conf ${HOME}/.config/tmux/tmux.conf
ln -s ${CFG_PWD}/vim/.vimrc ${HOME}/.vimrc
ln -s ${CFG_PWD}/vim/.vim ${HOME}/.vim
ln -s ${CFG_PWD}/fastfetch ${HOME}/.config/fastfetch
ln -s ${CFG_PWD}/zsh/.zshrc ${HOME}/.zshrc
ln -s ${CFG_PWD}/zsh/.zshenv ${HOME}/.zshenv
ln -s ${CFG_PWD}/zsh/config ${HOME}/.config/zsh

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chmod u+x ${CFG_PWD}/config/aliases.zsh
chmod u+x ${CFG_PWD}/config/functions.zsh

unset CFG_PWD

