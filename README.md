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
nix develop github:ink-splatters/dev/shells/<name> --impure
```

e.g.:

```shell
nix develop github:ink-splatters/dev/shells/cpp/O3 --impure
```

### Shells

#### c++

all shells share the common defaults:

nixpkgs version | stdenv | CFLAGS | CXXFLAGS 
:---: | :---: | :---: | :---: 
[e5d1c8](https://github.com/NixOS/nixpkgs/commit/e5d1c87f5813afde2dda384ac807c57a105721cc) | llvmPackages_latest | `-mcpu native` | `-mcpu native -stdlib=libc++`

##### Shells

name | CFLAGS | CXXFLAGS | hardening 
:--- | :---: | :---: | :---
`cpp/default` |  |  | default
`cpp/O3` | `-O3` | `-O3` | default
`cpp/hardening_disabled` |  |  | fully disabled
`cpp/hardening_disabled_O3` | `-O3` | `-O3` | fully disabled
`cpp/hardening_disabled_specific` |  |  | no `format`, `stackprotector`, `fortify`, `strictoverflow`, `relro`, `bindnow` 
`cpp/hardening_disabled_specific_O3` | `-O3` | `-O3` | no `format`, `stackprotector`, `fortify`, `strictoverflow`, `relro`, `bindnow` 
  
