{
  callPackage,
  llvmPackages,
  mkShell,
  stdenvNoCC,  
  lib,
  ...
}:
let
  inherit (lib) pre-commit-check compiler-flags;
  # compilerFlags = callPackage ./compiler-flags.nix { maxPerf = true; };
  

in
{
  cpp = callPackage ./shells/cpp.nix { inherit compilerFlags llvmPackages pre-commit-check; };
  
  install-hooks = mkShell.override { stdenv = stdenvNoCC; } {
    shellHook =
      let
        inherit (pre-commit-check) shellHook;
      in
      ''
        ${shellHook}
        echo Done!
        exit
      '';
  };
}
