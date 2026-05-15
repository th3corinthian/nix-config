{ pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd startx";
          user = "greeter";
        };
      };
    };

    xserver = {
      enable = true;

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      videoDrivers = [ "modesetting" ];

      displayManager.startx.enable = true;

      xkb = {
        extraLayouts.us-custom = {
          description = "US layout with custom hyper keys";
          languages = [ "eng" ];
          symbolsFile = ./us-custom.xkb;
        };

        layout = "us";
        options = "ctrl:nocaps";
      };
    };
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-vaapi-driver libva-vdpau-driver libvdpau-va-gl ];
    };

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  services.blueman.enable = true;

  systemd.services.upower.enable = true;
}
