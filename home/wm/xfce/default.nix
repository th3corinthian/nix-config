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
    tigervnc  # VNC server (virtual display :1); also used for `vncpasswd`
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

  # TigerVNC virtual display :1 on port 5901, reachable via tailscale0 only
  # (port not in allowedTCPPorts). One-time setup: run `vncpasswd ~/.vnc/passwd`.
  # -randr provides the resolution list clients can switch between.
  systemd.user.services.tigervnc = {
    Unit = {
      Description = "TigerVNC virtual display :1";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.tigervnc}/bin/Xvnc :1 -geometry 1920x1080 -randr 1920x1080,1680x1050,1440x900,1366x768,1280x800 -rfbport 5901 -rfbauth %h/.vnc/passwd -SecurityTypes VncAuth";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
