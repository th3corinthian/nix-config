{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../wm/sway.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    # Required for Wayland — enables DRM kernel modesetting and GBM provider.
    # This also sets boot.kernelParams += ["nvidia-drm.modeset=1"] automatically,
    # so the manual kernelParams/kernelModules entries are not needed.
    modesetting.enable = true;

    # Suspend/resume GPU state preservation. Enable for laptops; safe to leave
    # off for desktops where suspend is not commonly used.
    powerManagement.enable = false;

    # Use the proprietary driver. Set to true for Turing+ (RTX 20xx+) to try
    # the open-source GSP-firmware modules; false is safer for general use.
    open = false;

    nvidiaSettings = true;
  };

  # Installs the NVIDIA userspace driver stack (GL, Vulkan, GBM).
  # Required even on Wayland-only systems.
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.sessionVariables = {
    # Vulkan renderer bypasses the GBM/EGLStreams conflict with NVIDIA entirely.
    # Requires hardware.nvidia.modesetting.enable = true (already set above).
    WLR_RENDERER              = "vulkan";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # NVIDIA's cursor plane has known issues under wlroots; render in software.
    WLR_NO_HARDWARE_CURSORS   = "1";
    # VA-API hardware decode via NVIDIA.
    LIBVA_DRIVER_NAME         = "nvidia";
    # Opt Electron/Chromium apps into native Wayland rendering.
    NIXOS_OZONE_WL            = "1";
  };

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    nvidia-vaapi-driver
  ];

  networking.hostName = "navi";

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

  users.users.corinthian = {
    extraGroups = [ "jellyfin" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJT8xLIbH8FJDod+5p12lCvDm7qA36P1L4R9+FCiHYPk corinthian@nixos"
    ];
  };

  system.stateVersion = "25.11";
}
