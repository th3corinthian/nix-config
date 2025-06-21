{ config, pkgs, lib, ... }:
let
  androidTools = with pkgs; [
  	android-tools
	android-studio-tools
	jadx
  ];
in {
  environment.systemPackages = androidTools;
}
