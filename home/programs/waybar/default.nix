{ pkgs, ... }:

# Autumn Frappe palette
let
  base      = "#2a1f1f";
  mantle    = "#231919";
  surface0  = "#3d2b2b";
  overlay0  = "#7a5050";
  text      = "#e8d5cb";
  subtext1  = "#d4c0b5";
  rosewater = "#f5c2a0";
  peach     = "#e0895e";
  yellow    = "#d4a846";
  red       = "#d63d3d";
  maroon    = "#b5262a";
  green     = "#8fa858";
  blue      = "#7890c0";
in
{
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      height   = 32;
      spacing  = 4;

      modules-left   = [ "sway/workspaces" "sway/mode" "sway/scratchpad" ];
      modules-center = [ "sway/window" ];
      modules-right  = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "clock"
        "tray"
      ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs    = true;
        format         = "{icon}";
        format-icons   = {
          "1" = "󰲠"; "2" = "󰲢"; "3" = "󰲤"; "4" = "󰲦"; "5" = "󰲨";
          "6" = "󰲪"; "7" = "󰲬"; "8" = "󰲮"; "9" = "󰲰"; "10" = "󰿬";
          urgent   = "󰀨";
          focused  = "";
          default  = "";
        };
      };

      "sway/mode" = {
        format = "<span style='italic'>{}</span>";
      };

      "sway/scratchpad" = {
        format       = "{icon} {count}";
        show-empty   = false;
        format-icons = [ "" "" ];
        tooltip      = true;
        tooltip-format = "{app}: {title}";
      };

      "sway/window" = {
        max-length = 60;
      };

      clock = {
        format         = " {:%H:%M}";
        format-alt     = "{:%Y-%m-%d}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format  = " {usage}%";
        tooltip = false;
      };

      memory = {
        format = " {}%";
      };

      temperature = {
        critical-threshold = 80;
        format             = " {temperatureC}°C";
        format-critical    = " {temperatureC}°C";
      };

      network = {
        format-wifi        = " {signalStrength}%";
        format-ethernet    = "󰈀 {ipaddr}";
        format-linked      = "󰈀 (No IP)";
        format-disconnected = "󰖪 Disconnected";
        tooltip-format     = "{ifname}: {ipaddr}/{cidr}";
        format-alt         = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format           = "{icon} {volume}%";
        format-bluetooth = "{icon} {volume}%";
        format-muted     = "󰝟";
        format-icons     = {
          headphone  = "";
          headset    = "󰋎";
          default    = [ "" "" "" ];
        };
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };

      tray = {
        spacing = 10;
      };
    }];

    style = ''
      * {
        border:        none;
        border-radius: 0;
        font-family:   JetBrainsMono Nerd Font;
        font-size:     13px;
        min-height:    0;
      }

      window#waybar {
        background-color: ${mantle};
        color:            ${text};
        border-bottom:    2px solid ${surface0};
      }

      .modules-left,
      .modules-right,
      .modules-center {
        padding: 0 4px;
      }

      #workspaces button {
        padding:          0 8px;
        background-color: transparent;
        color:            ${subtext1};
        border-radius:    4px;
        margin:           4px 2px;
        transition:       all 0.15s ease;
      }

      #workspaces button:hover {
        background-color: ${surface0};
        color:            ${text};
      }

      #workspaces button.focused {
        background-color: ${surface0};
        color:            ${rosewater};
        border-bottom:    2px solid ${maroon};
      }

      #workspaces button.urgent {
        background-color: ${red};
        color:            ${text};
      }

      #mode {
        padding:          0 10px;
        background-color: ${maroon};
        color:            ${text};
        border-radius:    4px;
        margin:           4px 2px;
      }

      #scratchpad {
        padding:          0 10px;
        background-color: ${surface0};
        color:            ${yellow};
        border-radius:    4px;
        margin:           4px 2px;
      }

      #window {
        padding:    0 10px;
        color:      ${subtext1};
        font-style: italic;
      }

      #clock,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray {
        padding:          0 10px;
        background-color: ${surface0};
        color:            ${text};
        border-radius:    4px;
        margin:           4px 2px;
      }

      #clock       { color: ${rosewater}; }
      #cpu         { color: ${peach};     }
      #memory      { color: ${yellow};    }
      #temperature { color: ${green};     }
      #network     { color: ${blue};      }

      #temperature.critical {
        background-color: ${red};
        color:            ${text};
      }

      #pulseaudio       { color: ${maroon};  }
      #pulseaudio.muted { color: ${overlay0}; }

      #network.disconnected { color: ${overlay0}; }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect:  highlight;
        background-color:  ${red};
      }
    '';
  };
}
