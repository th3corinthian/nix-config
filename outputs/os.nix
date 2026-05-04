{ extraSystemConfig, inputs, system, pkgs, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (pkgs) lib;

  hosts = {
    thinkpad-x220 = [];
    navi          = [
      ({ config, ... }: {
        hardware.nvidia.package =
          config.boot.kernelPackages.nvidiaPackages.latest;
      })
    ];
    nixos-vm      = []; };

  modules' = [
    ../system/configuration.nix
    ../system/virtualisation.nix
    ../system/podman.nix
    inputs.sops-nix.nixosModules.sops
    extraSystemConfig
    { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
  ];

  make = host: extraModules: {
    ${host} = nixosSystem {
      inherit lib pkgs system;
      specialArgs = { inherit inputs; };
      modules = modules' ++ [ ../system/hosts/${host} ] ++ extraModules;
    };
  };
in
lib.mergeAttrsList (lib.mapAttrsToList make hosts)
