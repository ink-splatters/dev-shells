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

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
#      formatter = forEachSystem (system:
#        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
#      );

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
              NIX_ENABLE_HARDENING="pic";
              modules = [
                {

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
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [

			llvmPackages_latest.stdenv
		 ];

                }
              ];
            };
          });
    };
}



