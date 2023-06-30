{
  description = "A Nix-flake-based Tex development environment";

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
      tex = (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-full
          dvisvgm dvipng # for preview and export as html
          wrapfig amsmath ulem hyperref capt-of
          minted tcolorbox etoolbox inconsolata
          titlesec natbib tocbibind enumitem booktabs
          tocloft url setspace amsfonts
          pslatex fancyhdr pdfpages
          float;
          #(setq org-latex-compiler "lualatex")
          #(setq org-preview-latex-default-process 'dvisvgm)
      });
      overlays = [ ];
      pkgs = import nixpkgs { inherit overlays system; };
    in
    {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          # texlive.combined.scheme-medium
          tex
          python310Packages.pygments
        ];

        shellHook = ''
          echo "LATEX LOADED"
        '';
      };
  });
}
