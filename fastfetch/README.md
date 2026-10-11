# Fastfetch configuration

My personal [Fastfetch](https://github.com/fastfetch-cli/fastfetch) configuration.

## Usage

Choose a configuration file from [`config/`](./config/) that matches your environment,
then create a symlink named `config.jsonc` pointing to it.

For example, to create a new `config.jsonc` symlink for WSL, run this command from this directory:

```sh
ln -s config/config-wsl.jsonc config.jsonc
```

## Images in Windows Terminal

The [WSL configuration](./config/config-wsl.jsonc) uses a preconverted Sixel file
and Fastfetch's `raw` logo type to display an image in Windows Terminal.

Preconversion is not required for every setup. Fastfetch also supports loading
image files with the `sixel` logo type, as described in its
[Windows Terminal instructions](https://github.com/fastfetch-cli/fastfetch#windows-terminal).

For more details, see:

- [Fastfetch discussion #1243](https://github.com/fastfetch-cli/fastfetch/discussions/1243)
- [Sixel logo options](https://github.com/fastfetch-cli/fastfetch/wiki/Logo-options#sixel)

## Credits

See [`custom/credit.md`](./custom/credit.md) for image credits and links to the original sources.
