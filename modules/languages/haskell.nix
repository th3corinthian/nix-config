{ config, pkgs, lib, ... }:

let 
  haskellTools = with pkgs; [
    haskell-ci
  ];
in {
  environment.systemPackages = haskellTools;
}
