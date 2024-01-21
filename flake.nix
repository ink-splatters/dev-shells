{
  description = "basic cpp development shell";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs.llvmPackages_latest) stdenv;
        inherit (pkgs) nixpkgs-fmt;
      in
      with pkgs; {
        formatter = nixpkgs-fmt;
        devShells.default = mkShell.override { stdenv = stdenv; } {
          CFLAGS = "-mcpu native";
          CXXFLAGS = "-mcpu native -stdlib=libc++";
          shellHook = ''
            export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
          '';
        };
      });
}
