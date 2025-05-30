{ config, pkgs, lib, ... }:

let 
  pyTools = with pkgs; [
    manim
    jupyter-all 
  ];
in {
  environment.systemPackages = pyTools;
}
