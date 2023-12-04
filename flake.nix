{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-substituters = "https://devenv.cachix.org https://nix-community.cachix.org https://pre-commit-hooks.cachix.org";
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc=";
    filter-syscalls = false;
    sandbox = false;
  };

  outputs = { self, flake-utils, devenv, nixpkgs,  ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = nixpkgs.legacyPackages.${system}.extend (_: (prev: {

              llvmPackages = prev.llvmPackages_latest.override (_prev: {
                stdenv = prev.addAttrsToDerivation
                  {
                    hardeningDisable = [ "format" "stackprotector" "fortify" "strictoverflow" "relro" "bindnow" ];
                  }
                  (prev.impureUseNativeOptimizations _prev.stdenv);
              });
          }));
        pre-commit.hooks = {
                    # lint shell scripts
                    shellcheck.enable = true;
                    # execute example shell from Markdown files
                    mdsh.enable = true;

                    nixpkgs-fmt.enable = true;
                    nil.enable = true;
                    statix.enable = true;
                    deadnix.enable = true;
                    yamllint.enable = true;

                  };
    in
    {
      packages.devenv-up = self.devShells.${system}.default.config.procfileScript;

      devShells.default = devenv.lib.mkShell {
              inherit inputs pkgs;

              modules = [
                {
                  inherit pre-commit;
                  # languages.cplusplus.enable = true;

                  # packages = with pkgs; [
                  #   llvmPackages_latest.stdenv
                  # ];

                }
              ];
            };
          });
}



