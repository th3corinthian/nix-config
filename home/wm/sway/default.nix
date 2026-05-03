{ pkgs, lib, config, ... }:

# Autumn Frappe palette — Catppuccin Frappe structure shifted to warm reds/maroons
let
  base      = "#2a1f1f";
  surface0  = "#3d2b2b";
  surface1  = "#4f3535";
  overlay0  = "#7a5050";
  text      = "#e8d5cb";
  subtext0  = "#c0ab9f";
  red       = "#d63d3d";
  maroon    = "#b5262a";

  swayPkgs = with pkgs; [
    libnotify
    ouch
    pass
    pavucontrol
    playerctl
    tldr
    wl-clipboard
    wlr-randr
    swaylock
    swayidle
    grim
    slurp
    brightnessctl
    networkmanagerapplet
    blueman
  ];
in
{
  imports = [
    ../../shared
    ../../programs/alacritty
    ../../programs/rofi
    ../../programs/waybar
  ];

  home = {
    stateVersion = "25.11";
    packages = swayPkgs;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;

  # Override the rofi package to the Wayland-native build
  programs.rofi.package = pkgs.rofi;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";
      terminal  = "${pkgs.alacritty}/bin/alacritty";
      menu      = "rofi -show drun -show-icons";

      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size  = 10.0;
      };

      gaps = {
        inner     = 8;
        outer     = 4;
        smartGaps = true;
      };

      window = {
        border   = 2;
        titlebar = false;
      };

      floating = {
        border   = 2;
        titlebar = false;
      };

      colors = {
        focused = {
          background  = surface0;
          border      = maroon;
          childBorder = maroon;
          indicator   = red;
          text        = text;
        };
        focusedInactive = {
          background  = base;
          border      = surface0;
          childBorder = surface0;
          indicator   = overlay0;
          text        = subtext0;
        };
        unfocused = {
          background  = base;
          border      = surface0;
          childBorder = surface0;
          indicator   = overlay0;
          text        = subtext0;
        };
        urgent = {
          background  = red;
          border      = red;
          childBorder = red;
          indicator   = red;
          text        = text;
        };
      };

      output = {
        "*" = { bg = "${base} solid_color"; };
      };

      input = {
        "*" = { xkb_options = "caps:ctrl_modifier"; };
      };

      keybindings = let mod = "Mod4"; in lib.mkOptionDefault {
        # Applications
        "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${mod}+d"      = "exec rofi -show drun -show-icons";
        "${mod}+p"      = "exec rofi -show run";

        # Window control
        "${mod}+Shift+q"     = "kill";
        "${mod}+f"           = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space"       = "focus mode_toggle";

        # Layout
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # Focus — vim-style
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move — vim-style
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus"       = "scratchpad show";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # Sway control
        "${mod}+Shift+r" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -B 'Yes' 'swaymsg exit'";
        "${mod}+ctrl+l"  = "exec ${pkgs.swaylock}/bin/swaylock -c 2a1f1f";

        # Resize mode
        "${mod}+r" = "mode resize";

        # Screenshots
        "Print"       = "exec ${pkgs.grim}/bin/grim ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png";
        "Shift+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png";

        # Audio
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute"        = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioPlay"        = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext"        = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev"        = "exec ${pkgs.playerctl}/bin/playerctl previous";
      };

      modes = {
        resize = {
          h      = "resize shrink width 10px";
          j      = "resize grow height 10px";
          k      = "resize shrink height 10px";
          l      = "resize grow width 10px";
          Left   = "resize shrink width 10px";
          Down   = "resize grow height 10px";
          Up     = "resize shrink height 10px";
          Right  = "resize grow width 10px";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      startup = [
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
        { command = "${pkgs.blueman}/bin/blueman-applet"; }
      ];

      bars = [{ command = "waybar"; }];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      background-color  = "#2a1f1f";
      border-color      = "#b5262a";
      border-size       = 2;
      border-radius     = 6;
      text-color        = "#e8d5cb";
      font              = "JetBrainsMono Nerd Font 10";
      default-timeout   = 5000;
      max-visible       = 5;
      "urgency=high" = {
        background-color = "#3d2b2b";
        border-color     = "#d63d3d";
        default-timeout  = 0;
      };
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -c 2a1f1f";
      }
      {
        timeout        = 600;
        command        = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand  = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
    events = [
      {
        event   = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -c 2a1f1f";
      }
    ];
  };
}
