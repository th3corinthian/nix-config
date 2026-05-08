{ pkgs, ... }:

# Van Gogh Starry Night dark palette
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
in
{
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      height   = 24;
      spacing  = 0;

      modules-left   = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right  = [
        "cpu"
        "memory"
        "temperature"
        "network"
        "bluetooth"
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
        format         = "{:%H:%M}";
        format-alt     = "{:%Y-%m-%d}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format   = " {usage}%";
        tooltip  = false;
        interval = 2;
      };

      memory = {
        format         = " {percentage}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        interval       = 5;
      };

      temperature = {
        critical-threshold = 80;
        format             = " {temperatureC}°C";
        format-critical    = " {temperatureC}°C";
      };

      network = {
        format-wifi         = " {signalStrength}%";
        format-ethernet     = "󰈀 {ipaddr}";
        format-linked       = "󰈀";
        format-disconnected = "󰖪";
        tooltip-format-wifi     = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
        tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}";
        on-click            = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      bluetooth = {
        format           = " {status}";
        format-connected = " {device_alias}";
        format-disabled  = " off";
        tooltip-format   = "{controller_alias}\n{num_connections} connected";
        tooltip-format-connected    = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click         = "${pkgs.blueman}/bin/blueman-manager";
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
        font-family:   JetBrainsMono Nerd Font;
        font-size:     12px;
        min-height:    0;
      }

      window#waybar {
        background-color: rgba(10, 10, 10, 0.97);
        color:            ${text};
        border-bottom:    1px solid ${surface1};
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
      #clock,
      #tray {
        padding: 0 10px;
        color:   ${text};
      }

      #cpu         { color: ${teal};    }
      #memory      { color: ${yellow};  }
      #temperature { color: ${green};   }
      #network     { color: ${blue};    }
      #bluetooth   { color: ${teal};    }
      #clock       { color: ${text};    }

      #temperature.critical {
        color: ${red};
      }

      #network.disconnected {
        color: ${overlay0};
      }

      #bluetooth.disabled,
      #bluetooth.off {
        color: ${overlay0};
      }

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
