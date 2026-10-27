# Completion preferences. Oh My Zsh runs compinit using ZSH_COMPDUMP.
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# ensure always show dotfiles for file completion
_comp_options+=(globdots)
