{ inputs, system }:

let
  # nixos-version needs this to work with flakes
  libVersionOverlay = import "${inputs.nixpkgs}/lib/flake-version-info.nix" inputs.nixpkgs;

  libOverlay = f: p: rec {
    libx = import ./. { inherit (p) lib; };
    lib = (p.lib.extend (_: _: {
      inherit (libx) exe removeNewline secretManager;
    })).extend libVersionOverlay;
  };

  overlays = f: p: {
    inherit (inputs.cowsay.packages.${system}) cowsay;
    #inherit (inputs) fish-bobthefish-theme fish-keytool-completions;
    inherit (inputs.snitch.packages.${system}) snitch;

    #inherit (inputs.nix-index-database.packages.${system}) nix-index-database nix-index-small-database;

    builders = {
      mkHome = { pkgs ? f, extraHomeConfig ? { } }:
        import ../outputs/hm.nix { inherit extraHomeConfig inputs pkgs system; };

      mkNixos = { pkgs ? f, extraSystemConfig ? { } }:
        import ../outputs/os.nix { inherit extraSystemConfig inputs pkgs system; };
    };

    nix-search = inputs.nix-search.packages.${system}.default;

    yazi = inputs.yazi.packages.${system}.default;

    treesitterGrammars = ts: ts.withPlugins (p: [
      p.tree-sitter-c
      p.tree-sitter-nix
      p.tree-sitter-haskell
      p.tree-sitter-python
      p.tree-sitter-rust
      p.tree-sitter-markdown
      p.tree-sitter-markdown-inline
      p.tree-sitter-comment
      p.tree-sitter-toml
      p.tree-sitter-make
      p.tree-sitter-tsx
      p.tree-sitter-typescript
      p.tree-sitter-html
      p.tree-sitter-javascript
      p.tree-sitter-css
      p.tree-sitter-graphql
      p.tree-sitter-json
      p.tree-sitter-smithy
    ]);

    sources = {
      inherit (inputs) diskonaut gh-md-toc;
    };

    xargs = {
      inherit (inputs) nord-tmux;
    };
  };
in
[
  libOverlay
  overlays
]
