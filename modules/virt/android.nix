{ config, pkgs, lib, ... }:

{
  options.androidUtils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable android emulator and SDK tools";
  };

  config = lib.mkIf config.androidUtils.enable {
    environment.systemPackages = with pkgs; [
      android-tools
      android-studio
      genymotion
      dex2jar
      frida-tools
      #cabextract                # winetricks helper
      # optional helpers:
      #lutris                    # if you like GUIs for Wine
      #bottles                   # another GUI manager
    ];
  };
}
