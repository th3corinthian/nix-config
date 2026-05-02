{ pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      displayManager.lightdm.enable = true;
    };

    # Autologin so the XFCE graphical session is always running — required for
    # the Sunshine user service to start and stay up without anyone at the keyboard.
    displayManager.autoLogin = {
      enable = true;
      user = "corinthian";
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  services.blueman.enable = true;
}
