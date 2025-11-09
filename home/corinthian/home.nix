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
    initExtra = ''
			PS1='[\[\e[38;5;203;1m\]\u\[\e[0m\]@\[\e[38;5;45;1m\]\H\[\e[0m\]]\[\e[2m\]->\[\e[0m\](\[\e[3m\]\w\[\e[0m\])\\$'
			'';
  };
}
