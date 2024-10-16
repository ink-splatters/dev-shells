{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix = {
      url = "github:NixOS/nix/2.24.9";
      inputs = {
        flake-compat.follows="flake-compat";
        flake-parts.follows="flake-parts";
        git-hooks-nix.follows="git-hooks";
        nixpkgs.follows="nixpkgs";
      };
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
          nixpkgs.follows = "nixpkgs";
          nixpkgs-stable.follows = "nixpkgs";
          flake-compat.follows="flake-compat";
      };
    };
    cachix = {
      url = "github:cachix/cachix";
      inputs = {
        devenv.follows = "devenv";
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows="flake-compat";
      };

    };
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        cachix.follows = "cachix";
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows="flake-compat";
        nix.follows="nix";
      };
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = [ pkgs.hello ];

                  enterShell = ''
                    hello
                  '';

                  processes.hello.exec = "hello";
                }
              ];
            };
          });
    };
}
