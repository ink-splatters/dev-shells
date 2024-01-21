{
  description = "basic cpp development shell";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs.llvmPackages_latest) stdenv;
        inherit (pkgs) nixpkgs-fmt;
        hardeningDisable = [ "all" ];

        shellHook = ''
          export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
        '';

        CFLAGS = "-mcpu native -O3";
        CXXFLAGS = "${CFLAGS} -stdlib=libc++";
      in
      with pkgs; {
        formatter = nixpkgs-fmt;
        devShells = {
          swift = mkShell.override { stdenv = stdenv; } {
            inherit hardeningDisable CXXFLAGS shellHook;

            nativeBuildInputs = [
              swift
              swiftpm
              xcodebuild
            ];
          };

          cpp = mkShell.override { stdenv = stdenv; } {
            inherit hardeningDisable CFLAGS CXXFLAGS shellHook;
          };
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

          # TODO: integrate and make working  (cannot pull remote deps)
          # checks.default = stdenv.mkDerivation {
          #   inherit (self.devShells.${system}.default) nativeBuildInputs hardeningDisable CXXFLAGS;

          #   name = "check";
          #   src = ./checks/swift;
          #   dontBuild = true;
          #   doCheck = true;

          #   checkPhase = ''
          #     swift build -c release
          #   '';
          #   installPhase = ''
          #     mkdir "$out"
          #   '';
          # };
        };
      });
}
