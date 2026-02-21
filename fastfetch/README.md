# Fastfetch Config

This is the config for [`fastfetch`](https://github.com/fastfetch-cli/fastfetch).

## Usage

Pick up the proper config file in the [`config`](./config/) directory and link `config.jsonc`
to it.

For example:

```sh
ln -s config/config-wsl.jsonc config.jsonc
```

## Limitation of `Windows Terminal`

Because of the limitation of `Windows Terminal`, images cannot be shown directly.
Instead, it must be converted to the `sixel` file.

For more details, see:

- [README.md in fastfetch](https://github.com/fastfetch-cli/fastfetch?tab=readme-ov-file#windows-terminal)
- [discussions#1243](https://github.com/fastfetch-cli/fastfetch/discussions/1243)
- [Logo-options#sixel](https://github.com/fastfetch-cli/fastfetch/wiki/Logo-options#sixel)

## Credits

This configuration incorporates images from artists.
Refer to [`credit.md`](./custom/credit.md) to get a full list of them.
