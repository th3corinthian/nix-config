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
    protonmail-bridge
  ];

    # 2. Enable and configure the systemd user service
  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "ProtonMail Bridge";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --noninteractive --log-level info";
      Restart = "always";
      RestartSec = "5";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xsession = {
    enable = true;
    windowManager.command = "dwm";
    initExtra = ''
    feh --bg-fill ~/Documents/prog/nix/nix-config/assets/lain-6.jpg &
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
