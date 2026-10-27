# Initialize pyenv's interactive integration only when it is installed.
if (( $+commands[pyenv] )); then
    eval "$(pyenv init - zsh)"
fi
