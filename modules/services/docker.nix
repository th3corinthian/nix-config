{ config, pkgs, lib, ... }:

let 
    dockerUtils = with pkgs; [
	
     ];
in {
   environment.systemPackages = dockerUtils;
} 


