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

  services.x2goserver.enable = true;

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
  users.users.corinthian.extraGroups = [ "jellyfin" ];

  system.stateVersion = "25.11";
}
