{ config, pkgs, lib, ... }:

let 
  goTools = with pkgs; [
    go
    gopls
    glibc.dev
    glibc.static
  ];
in {
  environment.systemPackages = goTools;
}
