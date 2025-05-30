{ config, pkgs, lib, ... }:

let 
    nerdFonts = with pkgs; [
	noto-fonts
     ];
     fonts.fontDir.enable = true;
in {
   environment.systemPackages = nerdFonts;
}
