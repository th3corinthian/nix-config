{
  description = "x220 flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.x220 = nixpkgs.lib.nixosSystem {
      inherit system;
      # make self/inputs available inside modules
      specialArgs = { inherit inputs self; };
      modules = [
        ./hosts/x220/configuration.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = {
            inherit inputs;
            flake-root = self;
          };
          home-manager.users.corinthian = import ./home/corinthian/home.nix;
        }
      ];
    };
  };
}
