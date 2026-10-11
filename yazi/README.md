# Yazi configuration

My personal [Yazi](https://github.com/sxyazi/yazi) configuration.

Symlink this directory to `${XDG_CONFIG_HOME}/yazi`.
If `XDG_CONFIG_HOME` is unset or empty, use `~/.config`.

## Setup

This configuration uses the following flavor and plugins:

- [Dracula flavor](https://github.com/yazi-rs/flavors/tree/main/dracula.yazi), licensed under the MIT License.
- [full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi), licensed under the MIT License.
- [whoosh.yazi](https://gitlab.com/WhoSowSee/whoosh.yazi), licensed under the MIT License.

Dracula and full-border are listed in [`package.toml`](./package.toml) and managed by
Yazi's official package manager. Run [`setup.sh`](./setup.sh) from this directory
to install and update them:

```sh
bash setup.sh
```

whoosh is included as a Git submodule. Initialize it from the repository root:

```sh
git submodule update --init -- yazi/plugins/whoosh.yazi
```
