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

  mkXmonadHome = mkHome { mods = [ ../home/wm/xmonad ]; };
  mkXfceHome   = mkHome { mods = [ ../home/wm/xfce ]; };
  mkBspwmHome  = mkHome { mods = [ ../home/wm/bspwm ]; };
in
{
  xmonad        = mkXmonadHome;
  tongfang-xfce = mkXfceHome;
  nixos-vm      = mkBspwmHome;
}
