{
  description = "A Nix-flake-based Protobuf development environment";

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
        buildInputs = with pkgs; [ buf protobuf ];

        shellHook = with pkgs; ''
          echo "buf `${buf}/bin/buf --version`"
          ${protobuf}/bin/protoc --version
        '';
      };
    });
}
