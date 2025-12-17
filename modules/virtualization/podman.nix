{ config, lib, pkgs, ... }:

{

  options.podMan.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "install podman";
  };

  config = lib.mkIf config.podMan.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };
  };
}
