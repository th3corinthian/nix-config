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
  ];
in
{
  programs.home-manager.enable = true;

  imports = [
    ../../shared
    ../../programs/alacritty
    ../../services/picom
  ];

  programs.x2goserver = {
    enable = true;
  };

  home = {
    stateVersion = "25.11";
    packages = xfcePkgs;
    username = "corinthian";
    homeDirectory = "/home/corinthian";
  };
}
