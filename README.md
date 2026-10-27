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
| [.zshrc](./zsh/.zshrc) | `~/.zshrc` |
| [.zshenv](./zsh/.zshenv) | `~/.zshenv` |
| [Zsh configuration](./zsh/config/) | `${XDG_CONFIG_HOME}/zsh` |
| [Yazi configuration](./yazi/) | `${XDG_CONFIG_HOME}/yazi` |
| [Kitty configuration](./kitty/) | `${XDG_CONFIG_HOME}/kitty` |

## Setup

Run [`setup.sh`](./setup.sh) with Bash from the repository root:

```sh
bash setup.sh
```

The script creates the symbolic links listed in [File locations](#file-locations)
and installs shell dependencies as needed.
Existing links to the correct sources and existing installations are left in place.
If a destination conflicts with an existing file, directory, or symlink, the script
stops and reports the path. Move the conflicting item aside and rerun the script.

Then complete the application-specific setup:

- Vim:
  - Open Vim and run `:PlugInstall` to install plugins.
  - Change to `vim/.vim/plugged/youcompleteme/` and run `./install.py`.
    For language-specific installation instructions, see the [Full Installation Guide](https://github.com/ycm-core/YouCompleteMe/wiki/Full-Installation-Guide).
- Neovim: See the [Neovim README](./nvim/README.md) for setup instructions.
- Yazi: See the [Yazi README](./yazi/README.md) for setup instructions.
- Fastfetch: See the [Fastfetch README](./fastfetch/README.md) for setup instructions.
- Zsh: See the [Zsh README](./zsh/README.md) for dependencies and configuration details.

## Tests

Run the regression tests from the repository root with Python 3, Git, Bash, and Zsh installed:

```sh
python3 -B -m unittest discover -s tests -p 'test_*.py' -v
```

The tests use temporary home directories and local Git repositories, without network downloads.

## Credits

This project incorporates code from the following open-source project:

- [folke/snacks.nvim](https://github.com/folke/snacks.nvim) by [folke](https://github.com/folke) -
  licensed under [Apache-2.0](http://www.apache.org/licenses/LICENSE-2.0). For more information,
  see [the modified file](./nvim/config/lua/core/modify/snacks-statuscolumn.lua).
