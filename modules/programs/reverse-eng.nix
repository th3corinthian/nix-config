{ config, pkgs, lib, ... }:
let
  reTools = with pkgs; [
	ghidra
	radare2
	iaito
	gdb
	pwntools
	wireshark
	file
  ];
in {
  environment.systemPackages = reTools;
}
