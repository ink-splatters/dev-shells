## dev-shells / cpp

basic nix flakes-based development shells. 

might or might not be ditched / partially merged into [devenv]()

### Requirements

`nix` with [flakes](https://nixos.wiki/wiki/Flakes) support

### Usage

all shells can be accessed using `nix develop`:

```shell
nix develop github:ink-splatters/dev-shell .#<shell name>
```

#### Default

cpp shell is currently the default one.

#### Note fo Apple Silicon users

There is binary cache for Apple Silicon platform and it's highly recommmended you would enable it either using cachix:

```sh
cachix use aarch64-darwin
```

or via specifying `accept-flake-config` in `nix develop`:

```shell
nix develop --accept-flake-config github:ink-splatters/dev-shell .#<shell name>
```

### Supported shells

#### c/c++/obj. c/obj. c++

two shells:

- gcc (`gccStdenv.mkShell` based)
- llvm 19
   

there are 3 more shell types:

- `#O3` ( adds `-O3` to `CFLAGS` and `CXXFLAGS` )
- `#unhardened` ( disables hardening using [hardeningDisable](https://nixos.wiki/wiki/C)
- `#O3-unhardened` ( self explanatory )

all the shells feature:

- `-mcpu=apple-m1` if applicable
- LDFLAGS=`-fused-ld=lld`


#### gcc

basic gcc shell 

### llvm

opinionated shell based on llvmPackages_19.libcxxStdenv

all c/c++ shells include

- gnumake
- ninja
- cmake
- pkg-config

##### toolchains

###### gcc




### Examples

#### Enter O3 shell

```shell
nix develop github:ink-splatters/cpp-shell#O3
```

#### Enter O3-unhardened shell locally

```shell
git clone https://github.com/ink-splatters/cpp-shell.git
cd cpp-shell
nix develop .#O3-unhardened
```

### nix profile installation

optionally, the following  tools can be installed `nix profile` - wise:

- `lldb`
- `clang-format`, `clangd` and more tools included in nix `clang-tools` package

to install it:

```shell
nix profile install github:ink-splatters/cpp-shell#cpp-tools
```

### Alternatives

More advanced `nix`-based alternatives which support wider range of tools and options:

[devshell](https://github.com/numtide/devshell)
[devenv](http://devenv.sh)
