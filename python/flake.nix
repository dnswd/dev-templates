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

      myPy = pkgs.machNix.mkPython {
        python = "python310";
        # requirements = builtins.readFile ./requirements.txt;
        requirements = ''
        black
        python-dotenv
        pip
        virtualenv
        '';
      };
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ myPy ];

        shellHook = ''
          ${myPy.python}/bin/python --version
        '';
      };
    });
}
