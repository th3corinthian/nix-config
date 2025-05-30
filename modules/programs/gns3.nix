{ config, pkgs, lib, ... }:
let 
  gns3 = with pkgs; [
    gns3-gui
    gns3-server
  ];
in {
  environment.systemPackages = gns3;
}

