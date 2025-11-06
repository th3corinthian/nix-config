{ config, lib, pkgs, ... }:

{
 
  options.mullvadService.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "mullvad VPN";
  };

  config = lib.mkIf config.mullvadService.enable {
  
    systemd.services.mullvad-daemon.environment = {
      TALPID_NET_CLS_MOUNT_DIR = "/run/net-cls-v1";
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # the mole mutha fucka <O_O> 
    services.mullvad-vpn.enable = true;
    networking.iproute2.enable = true;
  
    environment.systemPackages = with pkgs; [
      mullvad-vpn 
    ];
  
  };
}
