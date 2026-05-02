{ pkgs, ... }:

{
  imports = [
    # Run `nixos-generate-config` on the target machine and copy the result here
    ./hardware-configuration.nix
    ../../wm/xfce.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "tongfang-amd";

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    # Don't use openFirewall — tailscale0 is already a trustedInterface,
    # so Sunshine ports are reachable via Tailscale without public exposure.
  };

  services.openssh = {
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Allow corinthian to access Jellyfin's media directories
  users.users.corinthian = {
    extraGroups = [ "jellyfin" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJT8xLIbH8FJDod+5p12lCvDm7qA36P1L4R9+FCiHYPk corinthian@nixos"
    ];
  };

  system.stateVersion = "25.11";
}
