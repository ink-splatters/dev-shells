## dev shells

barebone dev shells based on `nix flakes`

production ready and much more feature-rich alternative: https://devenv.sh

### requrements

`nix` with `flake` support

to enable it, given nix is installed:

```shell
mkdir -p $HOME/.config/nix
cat <<'EOF' >> $HOME/.config/nix.conf

experimental-features = flakes nix-command

EOF
```

### usage

```shell
nix develop github:ink-splatters/dev/shells/<name> --impure
```

e.g.:

```shell
nix develop github:ink-splatters/dev/shells/cpp/O3--impure
```

### shells

#### cpp


name | nixpkgs | stdenv | CFLAGS | CXXFLAGS | LDFLAGS | disabled hardening | packages | buildInputs | nativeBuildInputs
:---: :---: :---: :---: :---: :---: :---: :---: :---:
cpp/cpp | unstable [`e5d1c87`] | llvmPackages_latest |  `-mcpu native` | `-mcpu native -stdlib=libc++` | - | -| - | - | -
cpp/O3 | unstable [`e5d1c87`] | llvmPackages_latest |  `-mcpu native -O3` | `-mcpu native -stdlib=libc++ -O3` | - | -| - | - | -
cpp/hardening_disable | unstable [`e5d1c87`] | llvmPackages_latest |  `-mcpu native` | `-mcpu native -stdlib=libc++` | - | fully disabled | - | - | -
cpp/hardening_disable_O3 | unstable [`e5d1c87`] | llvmPackages_latest |  `-mcpu native -O3` | `-mcpu native -stdlib=libc++ -O3` | - | fully disabled | - | - | -
cpp/hardening_disable_explicit_O3 | unstable [`e5d1c87`] | llvmPackages_latest |  `-mcpu native` | `-mcpu native -stdlib=libc++` | - | format, stackprotector, fortify, strictoverflow, relro, bindnow| fully disabled | - | - | -
cpp/hardening_disable_explicit_O3 | unstable [`e5d1c87`] | llvmPackages_latest |  `-mcpu native -O3` | `-mcpu native -stdlib=libc++ -O3` | - | format, stackprotector, fortify, strictoverflow, relro, bindnow | - | - | -


