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

    # ly: a TUI display manager. Lives on a vt, boots fast, themes well with
    # the rest of the dark/teal rice.
    displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        hide_borders = false;
        clock = "%c";
        # Pre-fill the username field so login is just a password.
        default_input = "login";
      };
    };
  };

  # Hyprland comes from the upstream flake input (see flake.nix + overlay in
  # lib/overlays.nix). `pkgs.hyprland` is the overlaid bleeding-edge build.
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # PAM for hyprlock — without this, the lock screen can't authenticate.
  security.pam.services.hyprlock = { };

  xdg.portal = {
    enable = true;
    # xdg-desktop-portal-hyprland is wired in by programs.hyprland above; we
    # only need the GTK portal here for file-chooser / settings fallback.
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  services.blueman.enable = true;
}
