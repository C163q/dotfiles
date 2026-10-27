#!/usr/bin/env bash

set -euo pipefail

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

check_link() {
    local source=$1 destination=$2

    [[ -e "$source" ]] || die "Configuration source is missing: $source"

    if [[ -L "$destination" && "$destination" -ef "$source" ]]; then
        return
    fi
    if [[ -e "$destination" || -L "$destination" ]]; then
        die "Destination already exists; move it aside before running setup: $destination"
    fi
}

create_link() {
    local source=$1 destination=$2

    if [[ -L "$destination" && "$destination" -ef "$source" ]]; then
        printf 'Already linked: %s\n' "$destination"
    else
        ln -s -- "$source" "$destination"
        printf 'Linked: %s -> %s\n' "$destination" "$source"
    fi
}

check_installation() {
    local destination=$1 entrypoint=$2

    if [[ -f "$destination/$entrypoint" ]]; then
        return
    fi
    if [[ -e "$destination" || -L "$destination" ]]; then
        die "Installation path exists but $entrypoint is missing: $destination"
    fi
}

clone_if_missing() {
    local url=$1 destination=$2 entrypoint=$3

    if [[ -f "$destination/$entrypoint" ]]; then
        printf 'Already installed: %s\n' "$destination"
    else
        mkdir -p -- "$(dirname -- "$destination")"
        git clone -- "$url" "$destination"
    fi
}

main() {
    local repo_dir config_dir cache_dir zsh_dir omz_dir theme_dir i
    repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
    config_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}
    cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    zsh_dir="$HOME/.local/share/zsh"
    omz_dir="$zsh_dir/ohmyzsh"
    theme_dir="$omz_dir/themes/powerlevel10k"

    local -a links=(
        "$repo_dir/nvim/config" "$config_dir/nvim"
        "$repo_dir/tmux/tmux.conf" "$config_dir/tmux/tmux.conf"
        "$repo_dir/vim/.vimrc" "$HOME/.vimrc"
        "$repo_dir/vim/.vim" "$HOME/.vim"
        "$repo_dir/fastfetch" "$config_dir/fastfetch"
        "$repo_dir/zsh/.zshrc" "$HOME/.zshrc"
        "$repo_dir/zsh/.zshenv" "$HOME/.zshenv"
        "$repo_dir/zsh/config" "$config_dir/zsh"
        "$repo_dir/yazi" "$config_dir/yazi"
        "$repo_dir/kitty" "$config_dir/kitty"
    )

    command -v git >/dev/null || die "Git is required to install Oh My Zsh and Powerlevel10k."

    # Check all sources and destinations before making changes or downloading anything.
    for ((i = 0; i < ${#links[@]}; i += 2)); do
        check_link "${links[i]}" "${links[i + 1]}"
    done
    check_installation "$omz_dir" oh-my-zsh.sh
    check_installation "$theme_dir" powerlevel10k.zsh-theme

    mkdir -p -- "$config_dir/tmux" "$zsh_dir" "$cache_dir"

    # Finish downloads before activating the configuration through symlinks.
    clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir" oh-my-zsh.sh
    clone_if_missing https://github.com/romkatv/powerlevel10k.git "$theme_dir" powerlevel10k.zsh-theme

    for ((i = 0; i < ${#links[@]}; i += 2)); do
        create_link "${links[i]}" "${links[i + 1]}"
    done
}

main "$@"

