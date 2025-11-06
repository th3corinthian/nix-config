{ config, pkgs, ... }:

{
  imports = [
    ../../modules/suckless.nix
    ../../modules/fonts.nix
  ];

  home.username = "corinthian";
  home.homeDirectory = "/home/corinthian";
  home.stateVersion = "25.05";
  
  home.packages = with pkgs; [
    zathura
    xdg-utils
    feh
  ];

  xsession = {
    enable = true;
    windowManager.command = "dwm";
    initExtra = ''
    feh --bg-fill ~/Documents/nix-config/assets/lain_sun.jpg &
    '';
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
	"applications/pdf" = [ "org.pwmt.zathura.desktop" ];
  };

  programs.bash = {
    enable = true;
#initExtra = ''
#export PS1='\[\e[38;5;196;1m\][\[\e[0m\]+\[\e[38;5;196;1m\]]\[\e[38;5;81;3m\]\u\[\e[38;5;196m\]@\[\e[38;5;81m\]\H\[\e[0;2m\]-\[\e[0;1m\][\[\e[0m\]\w\[\e[1m\]]\[\e[0m\]\\$'
#'';
  };
}
