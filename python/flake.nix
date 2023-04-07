{
  description = "A Nix-flake-based Python development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:/DavHau/mach-nix";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs =
    { self
    , flake-utils
    , mach-nix
    , nixpkgs
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (self: super: {
          machNix = mach-nix.lib.${system};
        })
      ];

      pkgs = import nixpkgs { inherit overlays system; };

      # You can choose between using mach-nix or poetry2nix
      machNixEnv = (pkgs.machNix.mkPython {
        python = "python310";
        # requirements = builtins.readFile ./requirements.txt;
        requirements = ''
        black
        python-dotenv
        pip
        virtualenv
        '';
      });

      poetryEnv = (pkgs.poetry2nix.mkPoetryEnv {
        python = pkgs.python310;
        projectDir = ./.;
        overrides = [
          pkgs.poetry2nix.defaultPoetryOverrides
        ];
      });
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [
          # Pick one env 
          myPy                  # to use mach-nix
          poetryEnv pkgs.poetry # to use poetry2nix
        ];

        shellHook = ''
          ${myPy.python}/bin/python --version
          ${pythonEnv}/bin/python --version
        '';
      };
    });
}
