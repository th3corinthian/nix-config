{ config, lib, pkgs, ... }:

{

  options.dockerServices.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "install docker";
  };

  config = lib.mkIf config.dockerServices.enable {
    virtualisation.docker = {
      enable = true;
      # Customize Docker daemon settings using the daemon.settings option
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        log-driver = "journald";
        registry-mirrors = [ "https://mirror.gcr.io" ];
        storage-driver = "overlay2";
      };
      # Use the rootless mode - run Docker daemon as non-root user
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
