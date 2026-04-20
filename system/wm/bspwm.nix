{ pkgs, ... }:

{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    displayManager.defaultSession = "none+bspwm";

    xserver = {
      enable = true;

      windowManager.bspwm.enable = true;

      xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };
    };
  };
}
