{
  description = "basic cpp development shell";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hardeningDisable = [ "all" ];

        shellHook = ''
          export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
        '';

        CFLAGS = "-mcpu native";
        SWIFTFLAGS = "${CFLAGS}";
        CXXFLAGS = "${CFLAGS} -stdlib=libc++";

        inherit (pkgs) llvmPackages_latest swiftPackages mkShell;

        myMkShell = packages: mkShell.override { inherit (packages) stdenv; };
        mkCppShell = myMkShell llvmPackages_latest;
        mkSwiftShell = myMkShell swiftPackages;
        nativeBuildInputs = with swiftPackages; [
          swift
          swiftpm
          xcodebuild
        ];
      in
      with pkgs; {
        formatter = nixpkgs-fmt;
        devShells = {
          swift = mkSwiftShell {
            inherit SWIFTFLAGS shellHook nativeBuildInputs;
          };

          swift-O3 = mkSwiftShell {
            inherit shellHook nativeBuildInputs;
            SWIFTFLAGS = "${SWIFTFLAGS} -O3";
          };

          swift-unhardened = mkSwiftShell {
            inherit SWIFTFLAGS shellHook nativeBuildInputs hardeningDisable;
          };

          swift-O3-unhardened = mkSwiftShell {
            inherit shellHook nativeBuildInputs hardeningDisable;
            SWIFTFLAGS = "${SWIFTFLAGS} -O3";
          };

          cpp = mkCppShell {
            inherit CFLAGS CXXFLAGS shellHook;
          };

          cpp-O3 = mkCppShell {
            inherit CFLAGS shellHook;
            CXXFLAGS = "${CXXFLAGS} -O3";
          };

          cpp-unhardened = mkCppShell {
            inherit CFLAGS CXXFLAGS shellHook hardeningDisable;
          };

          cpp-O3-unhardened = mkCppShell {
            inherit CFLAGS shellHook hardeningDisable;
            CXXFLAGS = "${CXXFLAGS} -O3";
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
