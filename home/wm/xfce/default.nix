{ pkgs, ... }:

let
  xfcePkgs = with pkgs; [
    arandr
    libnotify
    ouch
    pass
    pavucontrol
    playerctl
    tldr
    x11vnc  # VNC server — share this XFCE session; also used for `x11vnc -storepasswd`
  ];
in
{
  programs.home-manager.enable = true;

  imports = [
    ../../shared
    ../../programs/alacritty
    ../../services/picom
  ];

  home = {
    stateVersion = "25.11";
    packages = xfcePkgs;
    username = "corinthian";
    homeDirectory = "/home/corinthian";
  };

  # Share the running XFCE session over VNC on port 5900.
  # Port 5900 is not in allowedTCPPorts, so it is only reachable via tailscale0
  # (trustedInterface). One-time setup: run `x11vnc -storepasswd ~/.vnc/passwd`.
  systemd.user.services.x11vnc = {
    Unit = {
      Description = "x11vnc VNC server for display :0";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.x11vnc}/bin/x11vnc -display :0 -auth guess -forever -loop -noxdamage -shared -rfbauth %h/.vnc/passwd -rfbport 5900";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
