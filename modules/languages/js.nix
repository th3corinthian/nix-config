{ config, pkgs, lib, ... }:

let
  jsTools = with pkgs; [
	nodejs_24
  ]
in {
  environment.systemPackages = jsTools;
}
