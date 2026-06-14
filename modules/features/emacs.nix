{ self, inputs, ... }: {
  perSystem = { system, ... }:
    let
      emacsPkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.emacs-overlay.overlays.default
          (final: prev: {
            tree-sitter-grammars = prev.tree-sitter-grammars // {
              tree-sitter-quint = null;
            };
          })
        ];
      };

      treesitGrammarsFiltered = emacsPkgs.emacsPackages.treesit-grammars.with-grammars
        (grammars:
          builtins.filter
            (grammar: grammar != null && (grammar.pname or "") != "tree-sitter-quint")
            (builtins.attrValues grammars));
    in {
      packages.emacsWithGrammars = emacsPkgs.emacsWithPackagesFromUsePackage {
        config = "";
        defaultInitFile = false;
        alwaysEnsure = true;
        package = emacsPkgs.emacs-gtk;

        extraEmacsPackages = epkgs: with epkgs; [
          treesitGrammarsFiltered
          cond-let
          dockerfile-mode
          envrc
          llama
          magit
          nix-mode
          use-package
          yaml-mode
        ];
      };
    };

  flake.nixosModules.emacs = { pkgs, emacsWithGrammars, ... }: {
    environment.systemPackages = [
      emacsWithGrammars
      pkgs.mermaid-cli
      pkgs.pandoc
    ];
  };
}
