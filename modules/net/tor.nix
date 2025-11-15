{ config, lib, pkgs, ... }:

{
 
  options.hiddenServices.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "variety of hidden services";
  };

  config = lib.mkIf config.hiddenServices.enable {
 
    environment.systemPackages = with pkgs; [
      tor-browser
    ];
  
  };
}
