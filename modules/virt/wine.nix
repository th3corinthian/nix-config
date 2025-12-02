{ config, pkgs, lib, ... }:

{
  options.wineUtils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable wine";
  };

  config = lib.mkIf config.wineUtils.enable {
    environment.systemPackages = with pkgs; [
      wineWowPackages.stable    # 64+32-bit Wine build
      winetricks

      duckstation
      pcsx2
      #cabextract                # winetricks helper
      # optional helpers:
      #lutris                    # if you like GUIs for Wine
      #bottles                   # another GUI manager
    ];
  };
}
