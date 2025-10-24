#!bin/bash

local CONFIG_DIR=${XDG_CONFIG_HOME:-"${HOME}/.config"}

mkdir ${CONFIG_DIR}
mkdir ${CONFIG_DIR}/tmux
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/share/zsh
mkdir ~/.cache/zsh

ZDOTDIR="$HOME/.local/share/zsh"
CFG_PWD="$(pwd)"

ln -s ${CFG_PWD}/nvim/config ${CONFIG_DIR}/nvim
ln -s ${CFG_PWD}/tmux/tmux.conf ${CONFIG_DIR}/tmux/tmux.conf
ln -s ${CFG_PWD}/vim/.vimrc ${HOME}/.vimrc
ln -s ${CFG_PWD}/vim/.vim ${HOME}/.vim
ln -s ${CFG_PWD}/fastfetch ${CONFIG_DIR}/fastfetch
ln -s ${CFG_PWD}/zsh/.zshrc ${HOME}/.local/share/zsh/.zshrc
ln -s ${CFG_PWD}/zsh/.zshenv ${HOME}/.zshenv
ln -s ${CFG_PWD}/zsh/config ${CONFIG_DIR}/zsh

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chmod u+x ${CFG_PWD}/config/aliases.zsh
chmod u+x ${CFG_PWD}/config/functions.zsh

unset CFG_PWD
unset CONFIG_DIR

