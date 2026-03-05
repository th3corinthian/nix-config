{ pkgs, ... }:

{
  home.packages = with pkgs; [
    feh
  ];

  home.file.".wallpapers/my-wallpaper.jpg".source = ../../../assets/wp10117214.jpg;
}
