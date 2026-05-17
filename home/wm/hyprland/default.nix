{ pkgs, ... }:

# Van Gogh Starry Night dark palette. Hyprland-specific knobs (rounding, blur,
# dual-color border gradient) are tuned to the reference rice: dark base, teal
# primary, amber secondary.
let
  bg       = "#0a0a0a";
  surface1 = "#1c1c1c";
  text     = "#d0d0d0";
  teal     = "#4ecdc4";
  yellow   = "#d4a520";
  red      = "#c0392b";

  # Hyprland's `rgb(...)` colour format takes a 6-digit hex with no `#`.
  hx = c: builtins.substring 1 6 c;

  # ── WALLPAPER ──────────────────────────────────────────────────────────────
  # Nix path literal — Nix copies the file into the store at build time.
  # To change the wallpaper, replace the path below (relative to this file).
  wallpaper = "${../../../assets/light-green.jpg}";
  # ──────────────────────────────────────────────────────────────────────────

  hyprPkgs = with pkgs; [
    libnotify
    ouch
    pass
    pavucontrol
    playerctl
    tldr
    wl-clipboard
    wlr-randr
    grim
    slurp
    brightnessctl
    networkmanagerapplet
    blueman
    hyprpaper
    hyprpicker
    hyprcursor
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
    packages = hyprPkgs;
  };

  programs.rofi.package = pkgs.rofi;

  wayland.windowManager.hyprland = {
    enable = true;
    # Overlaid to the upstream-flake build — see lib/overlays.nix.
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;

    # Propagate Wayland-relevant env vars into the user systemd session so
    # services like waybar / mako pick them up on login.
    systemd.variables = [ "--all" ];

    settings = {
      "$mod" = "SUPER";
      "$term" = "${pkgs.alacritty}/bin/alacritty";
      "$menu" = "rofi -show drun -show-icons";

      monitor = [ ",preferred,auto,1" ];

      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.mako}/bin/mako"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "${pkgs.blueman}/bin/blueman-applet"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 2;
        # Dual-stop gradient: teal → amber on focus, plain dark on inactive.
        "col.active_border" = "rgb(${hx teal}) rgb(${hx yellow}) 45deg";
        "col.inactive_border" = "rgb(${hx surface1})";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.96;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
        };

        shadow = {
          enabled = true;
          range = 14;
          render_power = 3;
          color = "rgba(00000099)";
        };
      };

      animations = {
        enabled = true;
        bezier = [ "ease, 0.25, 0.1, 0.25, 1.0" ];
        animation = [
          "windows, 1, 4, ease"
          "border, 1, 6, ease"
          "fade, 1, 4, ease"
          "workspaces, 1, 4, ease, slide"
        ];
      };

      input = {
        kb_layout = "us";
        kb_options = "caps:ctrl_modifier";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      bind = [
        # Applications
        "$mod, Return, exec, $term"
        "$mod SHIFT, Return, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, D, exec, $menu"
        "$mod, P, exec, rofi -show run"

        # Window control
        "$mod SHIFT, Q, killactive"
        "$mod, F, fullscreen, 0"
        "$mod SHIFT, space, togglefloating"
        "$mod, space, cyclenext"

        # Focus — vim-style
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        # Move — vim-style
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        # Scratchpad — special workspace
        "$mod SHIFT, minus, movetoworkspace, special"
        "$mod, minus, togglespecialworkspace,"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Compositor control
        "$mod SHIFT, R, exec, hyprctl reload"
        "$mod SHIFT, E, exit,"
        "$mod CTRL, L, exec, ${pkgs.hyprlock}/bin/hyprlock"

        # Screenshots — grim + slurp
        ", Print, exec, ${pkgs.grim}/bin/grim ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png"
        "SHIFT, Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png"

        # Media (non-repeat)
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ];

      # Volume / brightness keys want to repeat while held — use `bindel`.
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp,   exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"
      ];

      # Mouse — drag with $mod, resize with $mod+right.
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrule = [
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(blueman-manager)$"
      ];
    };
  };

  # hyprpaper has no nice home-manager wrapper for arbitrary outputs, but a
  # one-shot config file keeps it simple — preload the wallpaper, set on `,`
  # which matches any monitor.
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaper}
    wallpaper = , ${wallpaper}
    splash = false
  '';

  # hyprlock — themed to match the Van Gogh palette.
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 2;
      };

      background = [{
        path = wallpaper;
        blur_passes = 3;
        blur_size = 8;
        contrast = 0.9;
        brightness = 0.7;
        vibrancy = 0.15;
      }];

      input-field = [{
        size = "260, 50";
        position = "0, -80";
        halign = "center";
        valign = "center";
        outline_thickness = 2;
        dots_size = 0.3;
        dots_spacing = 0.3;
        outer_color = "rgb(${hx teal})";
        inner_color = "rgb(${hx bg})";
        font_color = "rgb(${hx text})";
        fade_on_empty = false;
        placeholder_text = ''<i><span foreground="##d0d0d0">password</span></i>'';
        check_color = "rgb(${hx yellow})";
        fail_color = "rgb(${hx red})";
      }];

      label = [
        {
          text = "$TIME";
          color = "rgb(${hx text})";
          font_size = 64;
          font_family = "UbuntuMono Nerd Font";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:60000] date "+%A, %d %B"'';
          color = "rgb(${hx teal})";
          font_size = 18;
          font_family = "UbuntuMono Nerd Font";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # hypridle: lock on idle, dpms off shortly after.
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
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
}
