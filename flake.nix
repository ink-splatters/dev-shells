{
  description = "basic cpp development shell";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs.llvmPackages_latest) stdenv;
        inherit (pkgs) nixpkgs-fmt;
      in
      with pkgs; {
        formatter = nixpkgs-fmt;
        devShells.default = mkShell.override { stdenv = stdenv; } {

          hardeningDisable = [ "all" ];

          CFLAGS = "-mcpu native -O3";
          CXXFLAGS = "-mcpu native -stdlib=libc++ -O3";
          shellHook = ''
            export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
          '';
        };
        checks.default = stdenv.mkDerivation {
          inherit (self.devShells.${system}.default) hardeningDisable CFLAGS CXXFLAGS;

          name = "check";
          src = ./.;
          dontBuild = true;
          doCheck = true;

          checkPhase = ''
            clang++ checks/main.cpp -o helloworld
          '';
          installPhase = ''
            mkdir "$out"
          '';
        };
      });
}
