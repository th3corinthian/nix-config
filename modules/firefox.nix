{ config, lib, pkgs, ... }:

{

  options.firefox.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "variety of hidden services";
  };

  config = lib.mkIf config.firefox.enable {

    environment.systemPackages = with pkgs; [
      firefox
    ];

  };
}
