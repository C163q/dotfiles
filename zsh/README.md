# Zsh configuration

My personal Zsh configuration, using Oh My Zsh and Powerlevel10k.

## Requirements

- Zsh.
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh), installed at `~/.local/share/zsh/ohmyzsh`.
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k), installed at `~/.local/share/zsh/ohmyzsh/themes/powerlevel10k`.

Homebrew and pyenv are initialized when available.

## Setup

Run the [setup script](../setup.sh) from the repository root:

```sh
bash setup.sh
```

It creates the following symbolic links and installs Oh My Zsh and Powerlevel10k if needed:

| Source | Destination |
| --- | --- |
| [`.zshenv`](./.zshenv) | `~/.zshenv` |
| [`.zshrc`](./.zshrc) | `~/.zshrc` |
| [`config/`](./config/) | `${XDG_CONFIG_HOME}/zsh` |

If `XDG_CONFIG_HOME` is unset or empty, use `~/.config`.
Zsh startup files use their default locations in `HOME`.

## Organization

```text
zsh/
├── .zshenv
├── .zshrc
└── config/
    ├── interactive/
    │   ├── brew.zsh
    │   ├── oh-my-zsh.zsh
    │   ├── completion.zsh
    │   ├── functions.zsh
    │   ├── aliases.zsh
    │   └── pyenv.zsh
    └── local/                 # Ignored by Git; create files as needed.
        ├── env.zsh
        ├── load_order.zsh
        └── interactive/
```

[`.zshenv`](./.zshenv) sets the basic environment and loads the optional
`config/local/env.zsh` for interactive and non-interactive Zsh processes.
Keep this local file lightweight and free of interactive initialization.

[`.zshrc`](./.zshrc) loads shared and machine-specific interactive configuration
in an explicit order. The entire `config/local/` directory is excluded from version control.

## Loading order

For interactive shells, `.zshrc` loads:

1. `interactive/brew.zsh`, to set up Homebrew before completion is initialized.
2. `interactive/oh-my-zsh.zsh`, to configure the theme and completion cache, then load Oh My Zsh.
3. `interactive/completion.zsh`, `functions.zsh`, and `aliases.zsh`.
4. Cargo's environment file, if present, followed by `interactive/pyenv.zsh`.
5. `local/load_order.zsh`, if present, followed by the files listed in its `_load_order` array.

Paths in this list are relative to `config/`.

Define machine-specific interactive scripts and their order in `config/local/load_order.zsh`:

```zsh
typeset -a _load_order=(
    credentials.zsh
    tool-settings.zsh
    tool-completion.zsh
)
```

Each entry is a path relative to `config/local/interactive/`, including the `.zsh`
extension. Subdirectories and quoted paths containing spaces are supported.
Only listed, readable files are sourced, in array order; missing files are skipped.
If the order file is absent or the array is empty, no local interactive scripts are loaded.

Place API settings before dependent application settings in the array. Completion
integrations run after Oh My Zsh has initialized the completion system.
The order file is used only by interactive shells; `local/env.zsh` is loaded
independently by `.zshenv`.

## Cache and history

- Completion caches: `${XDG_CACHE_HOME:-$HOME/.cache}/zsh/`.
  File names include the hostname and Zsh version; compiled copies and lock files
  stay in the same directory.
- Command history: `~/.local/share/zsh/.histfile`.
- Powerlevel10k settings: `~/.p10k.zsh`, falling back to
  `~/.local/share/zsh/.p10k.zsh` when the default file is unavailable.
