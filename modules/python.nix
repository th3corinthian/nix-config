{ config, pkgs, lib, ... }:

let
   pythonTools = with pkgs; [
	python39
	manim
   ];
in {
   # Append to whatever else you have already installed
   environment.systemPackages = pythonTools;
}
