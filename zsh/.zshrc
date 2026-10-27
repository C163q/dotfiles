# Interactive shell configuration.
[[ -o interactive ]] || return

_dotfiles_zsh_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Homebrew must populate PATH and FPATH before Oh My Zsh initializes completion.
source "$_dotfiles_zsh_dir/interactive/brew.zsh"
source "$_dotfiles_zsh_dir/interactive/oh-my-zsh.zsh"

# Interactive defaults.
export PS1="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c %{$fg[white]%}%# %{$reset_color%}"
HISTFILE=~/.local/share/zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

source "$_dotfiles_zsh_dir/interactive/completion.zsh"
source "$_dotfiles_zsh_dir/interactive/functions.zsh"
source "$_dotfiles_zsh_dir/interactive/aliases.zsh"

# Application environment.
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export ARCHFLAGS="-arch $(uname -m)"

if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi
source "$_dotfiles_zsh_dir/interactive/pyenv.zsh"

# The local configuration owns its file names and loading order.
typeset -a _load_order=()
if [[ -r "$_dotfiles_zsh_dir/local/load_order.zsh" ]]; then
    source "$_dotfiles_zsh_dir/local/load_order.zsh"
fi
for _dotfiles_zsh_file in "${_load_order[@]}"; do
    if [[ -f "$_dotfiles_zsh_dir/local/interactive/$_dotfiles_zsh_file" &&
          -r "$_dotfiles_zsh_dir/local/interactive/$_dotfiles_zsh_file" ]]; then
        source "$_dotfiles_zsh_dir/local/interactive/$_dotfiles_zsh_file"
    fi
done
unset _load_order _dotfiles_zsh_file _dotfiles_zsh_dir

if [[ $- == *l* ]]; then
    fastfetch
fi
