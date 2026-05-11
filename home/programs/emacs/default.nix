{ pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30;
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    (aspellWithDicts (dicts: [ dicts.en dicts.ru dicts.de ]))
    imagemagick
    sqlite
  ];

  # Doom config tracking: populate home/programs/emacs/doom/ with your
  # config.el, init.el, and packages.el. home-manager symlinks each file
  # into ~/.config/doom/, leaving room for doom to write .local/ alongside them.
  xdg.configFile."doom" = lib.mkIf (builtins.pathExists ./doom) {
    source = ./doom;
    recursive = true;
  };
}
