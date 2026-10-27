# Environment shared by interactive and non-interactive Zsh processes.
typeset -U PATH path
path=("$HOME/bin" "$HOME/.local/bin" /usr/local/bin "${path[@]}")
export PATH

export EDITOR="${EDITOR:-vim}"

export PYENV_ROOT="${PYENV_ROOT:-$HOME/.local/extra/pyenv}"
if [[ -d "$PYENV_ROOT/bin" ]]; then
    path=("$PYENV_ROOT/bin" "${path[@]}")
fi

# Machine-specific environment shared by all Zsh processes.
_dotfiles_zsh_env="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/local/env.zsh"
if [[ -r "$_dotfiles_zsh_env" ]]; then
    source "$_dotfiles_zsh_env"
fi
unset _dotfiles_zsh_env

# /etc/zshenv   → ~/.zshenv
# /etc/zprofile → ~/.zprofile     login shell
# /etc/zshrc    → ~/.zshrc        interactive shell
# /etc/zlogin   → ~/.zlogin       login shell
