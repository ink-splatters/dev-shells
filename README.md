## Dev Shells

barebone dev shells based on `nix flakes`

production ready and much more feature-rich alternative: https://devenv.sh

### Requirements

`nix` with `flake` support

to enable it, given nix is installed:

```shell
mkdir -p $HOME/.config/nix
cat <<'EOF' >> $HOME/.config/nix.conf

experimental-features = flakes nix-command

EOF
```

### Usage

```shell
nix develop github:ink-splatters/dev-shells#<name> --impure
```

e.g.:

```shell
nix develop github:ink-splatters/dev-shells#swift --impure
```
