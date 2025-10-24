# My Configs

Personal dotfile repository. Collect all my configs.

## Placement

By default, `XDG_CONFIG_HOME` is `~/.config`

- [nvim](./nvim/)
    - [config](./nvim/config/) should be placed at `${XDG_CONFIG_HOME}/nvim`
- [tmux](./tmux/)
    - [tmux.conf](./tmux/tmux.conf) should be placed at `${XDG_CONFIG_HOME}/tmux/tmux.conf`
- [vim](./vim/)
    - [.vimrc](./vim/.vimrc) should be placed at `~/.vimrc`
    - [.vim](./vim/.vim/) should be placed at `~/.vim`
- [fastfetch](./fastfetch/) should be placed at `${XDG_CONFIG_HOME}/fastfetch`
- [zsh](./zsh/)
    - [.zshrc](./zsh/.zshrc) should be placed at `~/.local/share/zsh/.zshrc`
    - [.zshenv](./zsh/.zshenv) should be placed at `~/.zshenv`
    - [config](./zsh/config/) should be placed at `${XDG_CONFIG_HOME}/zsh`
    - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) should be placed at `~/.local/share/zsh/ohmyzsh`
    - require `~/.cache/zsh/` to place `.zcompdump` file
    - require `~/.local/share/zsh/` to place `.histfile` file

## Credit

This project incorporates code from the following open-source project:

- [folke/snacks.nvim](https://github.com/folke/snacks.nvim) by [folke](https://github.com/folke) -
    licensed under [Apache-2.0](http://www.apache.org/licenses/LICENSE-2.0). For more information,
    see [the modified file](./nvim/config/lua/core/modify/snacks-statuscolumn.lua).
