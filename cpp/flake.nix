{
  description = "An opiniated Nix-flake-based C++ development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Compilers
          gcc
          llvmPackages_14.clang

          # Build system
          cmake
          cmakeCurses
          sccache
  
          # Development time dependencies
          gtest
  
          # Build time and Run time dependencies
          spdlog
          abseil-cpp
        ];

        shellHook = ''
          echo "gcc `${pkgs.gcc}/bin/gcc --version`"
          echo "clang `${pkgs.llvmPackages_14.clang}/bin/clang --version`"
          echo "cmake `${pkgs.cmake}/bin/cmake --version`"
          echo "sccache `${pkgs.sccache}/bin/sccache --version`"
        '';
      };
    });
}
