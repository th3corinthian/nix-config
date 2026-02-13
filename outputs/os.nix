{ extraSystemConfig, inputs, system, pkgs, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (pkgs) lib;

  hosts = [ "thinkpad-x220" "thinkpad-t60p" "tongfang-amd" ];

  modules' = [
    ../system/configuration.nix
    ../system/virtualisation.nix
    extraSystemConfig
    { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
  ];

  make = host: {
    ${host} = nixosSystem {
      inherit lib pkgs system;
      specialArgs = { inherit inputs; };
      modules = modules' ++ [ ../system/hosts/${host} ];
    };
  };
in
lib.mergeAttrsList (map make hosts)
