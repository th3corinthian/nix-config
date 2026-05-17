{ extraHomeConfig, inputs, system, pkgs, ... }:

let
  modules' = [
    inputs.nix-index.homeManagerModules.${system}.default
    { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
    extraHomeConfig
  ];

  mkHome = { mods ? [ ] }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = pkgs.xargs;
      modules = modules' ++ mods;
    };

  mkXmonadHome   = mkHome { mods = [ ../home/wm/xmonad ]; };
  mkHyprlandHome = mkHome { mods = [ ../home/wm/hyprland ]; };
  mkBspwmHome    = mkHome { mods = [ ../home/wm/bspwm ]; };
in
{
  xmonad        = mkXmonadHome;
  hyprland      = mkHyprlandHome;
  nixos-vm      = mkBspwmHome;
}
