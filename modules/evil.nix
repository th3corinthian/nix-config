{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hackrf
    radare2
    iaito
    wireshark
    ghidra-bin
    cutter
    kismet
    gdb
  ];
}
