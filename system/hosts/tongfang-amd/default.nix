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

  system.stateVersion = "25.11";
}
