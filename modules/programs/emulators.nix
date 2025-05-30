{ config, pkgs, lib, ... }:

let 
  emulatorUtils = with pkgs; [
    vice 
    dosbox
  ];
in {
  environment.systemPackages = emulatorUtils;
}
