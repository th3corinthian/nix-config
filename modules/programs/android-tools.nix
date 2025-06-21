{ config, pkgs, lib, ... }:
let
  androidTools = with pkgs; [
  	android-tools
	android-studio-tools
  ];
in {
  environment.systemPackages = androidTools;
}
