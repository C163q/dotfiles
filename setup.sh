#!/bin/bash

local CONFIG_DIR=${XDG_CONFIG_HOME:-"${HOME}/.config"}

mkdir ${CONFIG_DIR}
mkdir ${CONFIG_DIR}/tmux
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/share/zsh
mkdir ~/.cache/zsh

ZDOTDIR="$HOME/.local/share/zsh"
CFG_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
CFG_PWD="$(pwd)/${CFG_PATH}"

ln -s "${CFG_PWD}/nvim/config" "${CONFIG_DIR}/nvim"
ln -s "${CFG_PWD}/tmux/tmux.conf" "${CONFIG_DIR}/tmux/tmux.conf"
ln -s "${CFG_PWD}/vim/.vimrc" "${HOME}/.vimrc"
ln -s "${CFG_PWD}/vim/.vim" "${HOME}/.vim"
ln -s "${CFG_PWD}/fastfetch" "${CONFIG_DIR}/fastfetch"
ln -s "${CFG_PWD}/zsh/.zshrc" "${HOME}/.local/share/zsh/.zshrc"
ln -s "${CFG_PWD}/zsh/.zshenv" "${HOME}/.zshenv"
ln -s "${CFG_PWD}/zsh/config" "${CONFIG_DIR}/zsh"
ln -s "${CFG_PWD}/yazi" "${CONFIG_DIR}/yazi"
ln -s "${CFG_PWD}/kitty" "${CONFIG_DIR}/kitty"

git clone https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.local/share/zsh"
git clone https://github.com/romkatv/powerlevel10k.git "${HOME}/.local/share/zsh/ohmyzsh/themes"

chmod u+x ${CFG_PWD}/zsh/config/aliases.zsh
chmod u+x ${CFG_PWD}/zsh/config/functions.zsh

unset CFG_PWD
unset CONFIG_DIR

