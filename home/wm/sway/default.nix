{ pkgs, lib, ... }:

# Van Gogh Starry Night dark palette
let
  bg       = "#0a0a0a";
  surface0 = "#141414";
  surface1 = "#1c1c1c";
  overlay0 = "#383838";
  text     = "#d0d0d0";
  subtext0 = "#888888";
  teal     = "#4ecdc4";
  yellow   = "#d4a520";
  red      = "#c0392b";

  # ── WALLPAPER ──────────────────────────────────────────────────────────────
  # Nix path literal — Nix copies the file into the store at build time.
  # To change the wallpaper, replace the path below (relative to this file).
  wallpaper = "${../../../assets/light-green.jpg}";
  # ──────────────────────────────────────────────────────────────────────────

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
    swaybg
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
    ../../programs/kitty
    ../../programs/rofi
    ../../programs/waybar
  ];

  home = {
    stateVersion = "25.11";
    packages = swayPkgs;
  };

  programs.rofi.package = pkgs.rofi;

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    # swayfx's GLES2 renderer can't init inside the Nix build sandbox (no DRM
    # FD), so the home-manager config check fails. Skip it — sway/swayfx will
    # still validate the config at actual startup.
    checkConfig = false;

    # swayfx-only knobs (corner_radius, blur, shadows). Stock sway will reject
    # these, so they live in extraConfig rather than `config`.
    extraConfig = ''
      corner_radius 10
      smart_corner_radius enable
      default_dim_inactive 0.0
      blur disable
      shadows disable
    '';

    config = {
      modifier = "Mod4";
      terminal  = "${pkgs.alacritty}/bin/alacritty";
      menu      = "rofi -show drun -show-icons";

      fonts = {
        names = [ "UbuntuMono Nerd Font" ];
        size  = 10.0;
      };

      gaps = {
        inner     = 8;
        outer     = 6;
        smartGaps = true;
      };

      window = {
        border   = 1;
        titlebar = false;
      };

      floating = {
        border   = 1;
        titlebar = false;
      };

      colors = {
        focused = {
          background  = surface0;
          border      = teal;
          childBorder = teal;
          indicator   = teal;
          text        = text;
        };
        focusedInactive = {
          background  = bg;
          border      = surface1;
          childBorder = surface1;
          indicator   = overlay0;
          text        = subtext0;
        };
        unfocused = {
          background  = bg;
          border      = surface1;
          childBorder = surface1;
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
        # WALLPAPER: update the `wallpaper` variable at the top of this file
        # Supported modes: fill, fit, stretch, center, tile
        "*" = { bg = "${wallpaper} fill"; };
      };

      input = {
        "*" = { xkb_options = "caps:ctrl_modifier"; };
      };

      keybindings = let mod = "Mod4"; in lib.mkOptionDefault {
        # Applications
        "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${mod}+Shift+Return" = "exec ${pkgs.kitty}/bin/kitty";
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
        "${mod}+ctrl+l"  = "exec ${pkgs.swaylock}/bin/swaylock -c 0a0a0a";

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

      # Empty — waybar is launched via systemd (sway-session.target) by
      # programs.waybar, see ../../programs/waybar. Leaving a bar block here
      # too would race the systemd unit and you'd get either zero or two bars.
      bars = [ ];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      background-color  = "#0e0e0e";
      border-color      = "#4ecdc4";
      border-size       = 1;
      border-radius     = 6;
      text-color        = "#d0d0d0";
      font              = "UbuntuMono Nerd Font 10";
      default-timeout   = 5000;
      max-visible       = 5;
      "urgency=high" = {
        background-color = "#141414";
        border-color     = "#c0392b";
        default-timeout  = 0;
      };
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -c 0a0a0a";
      }
      {
        timeout        = 600;
        command        = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand  = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
    #events = [
      #{
        #event   = "before-sleep";
        #command = "${pkgs.swaylock}/bin/swaylock -c 0a0a0a";
      #}
    #];
  };
}
