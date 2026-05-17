{ pkgs, ... }:

# Van Gogh Starry Night dark palette + xmobar-style accent colors per module.
# Icons use pango <span> so only the glyph is tinted (like xmobar's <fc>...</fc>),
# matching the layout in home/programs/xmobar/default.nix.
let
  bg       = "#0a0a0a";
  surface0 = "#141414";
  surface1 = "#1c1c1c";
  overlay0 = "#383838";
  text     = "#d0d0d0";
  subtext1 = "#888888";
  teal     = "#4ecdc4";
  yellow   = "#d4a520";
  blue     = "#4a7fa5";
  red      = "#c0392b";
  green    = "#5a8a3c";

  # Per-module icon tints, mirroring the xmobar palette.
  cpuIcon  = "#a9a1e1";
  memIcon  = "#51afef";
  tempIcon = "#cdb464";
  netRx    = "#4db5bd";
  netTx    = "#c678dd";
  dateIcon = "#ecbe7b";
  batIcon  = "#b1de76";
in
{
  programs.waybar = {
    enable = true;

    # Run as a systemd user service tied to sway-session.target so it survives
    # sway reloads and starts reliably at login. The previous `bars` block in
    # the sway config relied on bare `waybar` being on PATH at greetd-launch
    # time, which it wasn't — hence the missing bar at login.
    systemd = {
      enable  = true;
      targets = [ "sway-session.target" ];
    };

    settings = [{
      layer    = "top";
      position = "top";
      height   = 30;
      spacing  = 0;

      # Margins create the "hover" gap between the bar and any tiled window.
      margin-top    = 8;
      margin-left   = 10;
      margin-right  = 10;
      margin-bottom = 0;

      modules-left   = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right  = [
        "cpu"
        "memory"
        "temperature"
        "network"
        "bluetooth"
        "battery"
        "clock"
        "tray"
      ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs    = true;
        format         = "{name}";
      };

      "sway/mode" = {
        format = " {}";
      };

      "sway/window" = {
        max-length = 60;
      };

      clock = {
        format         = "<span color='${dateIcon}'></span>  {:%a %b %d %I:%M}";
        format-alt     = "<span color='${dateIcon}'></span>  {:%Y-%m-%d}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format   = "<span color='${cpuIcon}'></span>  {usage}%";
        tooltip  = false;
        interval = 2;
      };

      memory = {
        format         = "<span color='${memIcon}'></span>  {percentage}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        interval       = 5;
      };

      temperature = {
        critical-threshold = 80;
        format             = "<span color='${tempIcon}'></span>  {temperatureC}°";
        format-critical    = "<span color='${red}'></span>  {temperatureC}°";
      };

      network = {
        format-wifi         = "<span color='${netRx}'></span>  {signalStrength}%";
        format-ethernet     = "<span color='${netRx}'>󰈀</span>  {ipaddr}";
        format-linked       = "<span color='${netRx}'>󰈀</span>";
        format-disconnected = "<span color='${overlay0}'>󰖪</span>";
        tooltip-format-wifi     = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
        tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}";
        on-click            = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      bluetooth = {
        format           = "<span color='${teal}'></span>  {status}";
        format-connected = "<span color='${teal}'></span>  {device_alias}";
        format-disabled  = "<span color='${overlay0}'></span>  off";
        tooltip-format   = "{controller_alias}\n{num_connections} connected";
        tooltip-format-connected    = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click         = "${pkgs.blueman}/bin/blueman-manager";
      };

      battery = {
        states = {
          warning  = 25;
          critical = 10;
        };
        format          = "<span color='${batIcon}'>{icon}</span>  {capacity}%";
        format-charging = "<span color='${green}'></span>  {capacity}%";
        format-plugged  = "<span color='${green}'></span>  {capacity}%";
        format-icons    = [ "" "" "" "" "" ];
        tooltip-format  = "{timeTo}";
      };

      tray = {
        spacing   = 8;
        icon-size = 14;
      };
    }];

    style = ''
      * {
        border:        none;
        border-radius: 0;
        font-family:   "UbuntuMono Nerd Font", "UbuntuMono Nerd Font Mono", monospace;
        font-size:     12px;
        min-height:    0;
      }

      /* Floating / "hover" bar: transparent window, opaque rounded pill inside. */
      window#waybar {
        background-color: transparent;
        color:            ${text};
      }

      window#waybar > box {
        background-color: rgba(10, 10, 10, 0.92);
        border:           1px solid ${surface1};
        border-radius:    10px;
        padding:          0 6px;
        margin:           0;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding:          0 8px;
        background-color: transparent;
        color:            ${subtext1};
        border-bottom:    2px solid transparent;
        border-radius:    0;
        transition:       color 0.1s ease, border-color 0.1s ease;
      }

      #workspaces button:hover {
        background-color: ${surface0};
        color:            ${text};
        border-radius:    6px;
      }

      #workspaces button.focused {
        color:         ${teal};
        border-bottom: 2px solid ${teal};
      }

      #workspaces button.urgent {
        color: ${red};
      }

      #mode {
        padding:       0 10px;
        color:         ${yellow};
        border-bottom: 2px solid ${yellow};
      }

      #window {
        padding:    0 8px;
        color:      ${subtext1};
        font-style: italic;
      }

      #cpu,
      #memory,
      #temperature,
      #network,
      #bluetooth,
      #battery,
      #clock,
      #tray {
        padding: 0 10px;
        color:   ${text};
      }

      #temperature.critical { color: ${red};      }
      #network.disconnected { color: ${overlay0}; }

      #bluetooth.disabled,
      #bluetooth.off {
        color: ${overlay0};
      }

      #battery.warning  { color: ${yellow}; }
      #battery.critical { color: ${red};    }

      #tray {
        padding: 0 6px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color:            ${red};
      }
    '';
  };
}
