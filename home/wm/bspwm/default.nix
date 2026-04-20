{ pkgs, ... }:

let
  bspwmPkgs = with pkgs; [
    arandr       # GUI for xrandr
    dmenu        # application launcher
    feh          # wallpaper setter
    libnotify    # notify-send
    ouch         # compression/decompression
    pass
    pavucontrol  # pulseaudio volume control
    playerctl    # media player control
    tldr
    xdotool
    xorg.xrandr
  ];
in
{
  programs.home-manager.enable = true;

  imports = [
    ../../shared
    ../../programs/alacritty
  ];

  home = {
    stateVersion = "25.11";
    packages = bspwmPkgs;
    username = "corinthian";
    homeDirectory = "/home/corinthian";
  };

  xsession = {
    enable = true;

    initExtra = ''
      set +x
      ${pkgs.xorg.xset}/bin/xset s off
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option ctrl:nocaps
    '';

    windowManager.bspwm = {
      enable = true;

      settings = {
        border_width      = 2;
        window_gap        = 8;
        split_ratio       = 0.52;
        borderless_monocle = true;
        gapless_monocle   = true;
      };

      rules = {
        "Gimp" = { state = "floating"; };
        "Pavucontrol" = { state = "floating"; };
      };

      startupPrograms = [
        "${pkgs.feh}/bin/feh --bg-scale ~/.wallpaper"
      ];
    };
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      # Terminal
      "super + Return" = "${pkgs.alacritty}/bin/alacritty";

      # Launcher
      "super + @space" = "${pkgs.dmenu}/bin/dmenu_run";

      # Reload sxhkd
      "super + Escape" = "pkill -USR1 -x sxhkd";

      # Quit / restart bspwm
      "super + alt + {q,r}" = "bspc {quit,wm -r}";

      # Close / kill window
      "super + {_,shift + }w" = "bspc node -{c,k}";

      # Window state
      "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";

      # Focus / swap — vim directions
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

      # Workspaces 1–9
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

      # Expand / contract window
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
    };
  };

  xresources.properties = {
    "Xft.dpi"       = 96;
    "Xft.antialias" = 1;
    "Xft.hinting"   = 1;
    "Xft.hintstyle" = "hintfull";
    "Xft.rgba"      = "rgb";
  };
}
