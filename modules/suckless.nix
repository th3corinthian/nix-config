{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.surf.overrideAttrs (_: {
      src = ../config/surf;
      patches = [ ];
    }))
    #(pkgs.dmenu.overrideAttrs (_: {
      #src = ../config/dmenu;
      #patches = [ ];
    #}))
	#(pkgs.slstatus.overrideAttrs (_: {
      #src = ../config/slstatus;
	  #patches = [ ];
    #}))
    #slock
    #surf
  ];
}

