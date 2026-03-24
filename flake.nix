{
  description = "rekordcrate development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShells.default = pkgs.mkShell rec {
          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.systemd
            pkgs.openssl
            pkgs.cmake
            pkgs.git
            pkgs.rpiboot
            pkgs.minicom
          ];
          buildInputs = [
            pkgs.clang
            pkgs.llvmPackages.bintools
            pkgs.rustup
            pkgs.bash
            pkgs.yaml-language-server
          ];

          RUSTC_VERSION = "nightly";

          LIBCLANG_PATH = pkgs.lib.makeLibraryPath [pkgs.llvmPackages_latest.libclang.lib];

          shellHook = ''
            export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
            export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/
          '';

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (buildInputs ++ nativeBuildInputs);
        };
      }
    );
}
