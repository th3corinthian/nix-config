{ extraHomeConfig, inputs, system, pkgs, ... }:

let
  modules' = [
    inputs.nix-index.homeManagerModules.${system}.default
    { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
    extraHomeConfig
  ];

  mkHome = { mut ? false, mods ? [ ] }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = pkgs.xargs;
      modules = modules' ++ mods ++ [
        #{ inherit hidpi; }
      ];
    };

  #mkXmonadHome = { hdipi }: mkHome

  mkXmonadHome = mkHome {
    #inherit hidpi;
    mods = [ ../home/wm/xmonad ];
  };

  mkHyprlandHome = { hidpi, mut ? false }: mkHome {
    inherit hidpi mut;
    mods = [
      inputs.hypr-binds-flake.homeManagerModules.${system}.default
      ../home/wm/hyprland
    ];
  };
in
{
  hyprland-edp = mkHyprlandHome { hidpi = false; };
  hyprland-hdmi = mkHyprlandHome { hidpi = true; };
  hyprland-hdmi-mutable = mkHyprlandHome { hidpi = true; mut = true; };
  
  xmonad-edp = mkXmonadHome; #{ hidpi = false; };
  xmonad-hdmi = mkXmonadHome { hidpi = true; };
}
