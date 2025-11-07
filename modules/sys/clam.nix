{ config, pkgs, lib, ... }:

{
  options.clamTools.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable clam";
  };

  config = lib.mkIf config.clamTools.enable {
    
    services.clamav.daemon.enable = true;
	services.clamav.updater.enable = true;

    environment.systemPackages = with pkgs; [
      clamav
    ];
  };
}
