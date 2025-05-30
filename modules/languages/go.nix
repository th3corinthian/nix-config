{ config, pkgs, lib, ... }:

let 
  goTools = with pkgs; [
    go
    gopls 
  ];
in {
  environment.systemPackages = goTools;
}
