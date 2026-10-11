# Dotfiles

My personal dotfiles.

## File locations

If `XDG_CONFIG_HOME` is unset or empty, use `~/.config` for the destinations below.

Create symbolic links at the destinations listed below, pointing to the corresponding files or directories in this repository.

| Source | Destination |
| --- | --- |
| [Neovim configuration](./nvim/config/) | `${XDG_CONFIG_HOME}/nvim` |
| [tmux.conf](./tmux/tmux.conf) | `${XDG_CONFIG_HOME}/tmux/tmux.conf` |
| [.vimrc](./vim/.vimrc) | `~/.vimrc` |
| [.vim](./vim/.vim/) | `~/.vim` |
| [Fastfetch configuration](./fastfetch/) | `${XDG_CONFIG_HOME}/fastfetch` |
| [.zshrc](./zsh/.zshrc) | `~/.local/share/zsh/.zshrc` |
| [.zshenv](./zsh/.zshenv) | `~/.zshenv` |
| [Zsh configuration](./zsh/config/) | `${XDG_CONFIG_HOME}/zsh` |
| [Yazi configuration](./yazi/) | `${XDG_CONFIG_HOME}/yazi` |
| [Kitty configuration](./kitty/) | `${XDG_CONFIG_HOME}/kitty` |

For Zsh, also install:

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) at `~/.local/share/zsh/ohmyzsh`.
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) at `~/.local/share/zsh/ohmyzsh/themes/powerlevel10k`.

Create `~/.cache/zsh/` for the completion cache and `~/.local/share/zsh/` for the command history.

## Setup

- Create the symbolic links described in [File locations](#file-locations).
  See also [`setup.sh`](./setup.sh).
- Vim:
  - Open Vim and run `:PlugInstall` to install plugins.
  - Change to `vim/.vim/plugged/youcompleteme/` and run `./install.py`.
    For language-specific installation instructions, see the [Full Installation Guide](https://github.com/ycm-core/YouCompleteMe/wiki/Full-Installation-Guide).
- Neovim: See the [Neovim README](./nvim/README.md) for setup instructions.
- Yazi: See the [Yazi README](./yazi/README.md) for setup instructions.
- Fastfetch: See the [Fastfetch README](./fastfetch/README.md) for setup instructions.

## Credits

This project incorporates code from the following open-source project:

- [folke/snacks.nvim](https://github.com/folke/snacks.nvim) by [folke](https://github.com/folke) -
  licensed under [Apache-2.0](http://www.apache.org/licenses/LICENSE-2.0). For more information,
  see [the modified file](./nvim/config/lua/core/modify/snacks-statuscolumn.lua).
