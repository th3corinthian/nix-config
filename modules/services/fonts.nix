{ config, pkgs, lib, ... }:

let 
    nerdFonts = with pkgs; [
	nerd-fonts.fira-code
	nerd-fonts.droid-sans-mono
	nerd-fonts.symbols-only
     ];
in {
   environment.systemPackages = nerdFonts;
}
