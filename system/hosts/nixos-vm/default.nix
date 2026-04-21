{ pkgs, ... }:

{
  imports = [
    # After spinning up the VM, run `nixos-generate-config` and drop the
    # resulting hardware-configuration.nix alongside this file, then add:
    # ./hardware-configuration.nix
    ../../wm/bspwm.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "nixos-vm";

  # Useful for VMs — adjust or remove depending on your hypervisor
  services.qemuGuest.enable = true;

  system.stateVersion = "25.11";
}
