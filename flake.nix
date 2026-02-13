{
  description = "corinthian's home-manager & nix-config";

  nixConfig = {
    extra-substitutors = [
      "https://cache.nixos.org"
      "https://garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-schemas.url = github:DeterminateSystems/flake-schemas;
    # https://github.com/hyprwm/Hyprland/issues/9518
    nixpkgs-hyprland.url = "nixpkgs/b582bb5b0d7af253b05d58314b85ab8ec46b8d19";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs

    #emacs-flake = {
      #url = github:th3corinthian/emacs-flake;
      #inputs.nixpkgs.follows = "nixpkgs";
      #inputs.flake-schemas.follows = "flake-schemas";
    #};

    # ... your other inputs (nixpkgs, home-manager, etc.)
    #nix-index-db.url = "github:nix-community/nix-index-database";
    #nix-index-db.inputs.nixpkgs.follows = "nixpkgs";

    # Nix-index
    nix-index-database = {
      url = github:nix-community/nix-index-database;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index = {
      url = github:gvolpe/nix-index;
      inputs.nix-index-database.follows = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland = {
      url = github:hyprwm/Hyprland?ref=v0.46.2;
      flake = false;
    };

    hypr-binds-flake = {
      url = github:hyprland-community/hypr-binds;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland = {
      url = github:hyprland-community/pyprland?ref=2.3.8;
      flake = false;
    };

    # Github Markdown ToC generator
    gh-md-toc = {
      url = github:ekalinin/github-markdown-toc;
      flake = false;
    };

    # Fast nix search client
    nix-search = {
      url = github:diamondburned/nix-search;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cowsay = {
      url = github:snowfallorg/cowsay;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    diskonaut = {
      url = github:kfkonrad/diskonaut?ref=0.12.0;
      flake = false;
    };

    snitch = {
      url = github:karol-broda/snitch;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nord-tmux = {
      url = github:arcticicestudio/nord-tmux;
      flake = false;
    };

  };

  outputs = inputs @ { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";

    overlays = import ./lib/overlays.nix { inherit inputs system; };

    pkgs = import nixpkgs {
      inherit overlays system;
      config = {
        allowUnfree = true;
        contentAddressedByDefault = false;
      };
    };
  in
  {
    homeConfigurations = pkgs.builders.mkHome { };
    nixosConfigurations = pkgs.builders.mkNixos { };

    out = { inherit pkgs overlays; };

    schemas =
      inputs.flake-schemas.schemas //
      import ./lib/schemas.nix { inherit (inputs) flake-schemas; };
  };
}
