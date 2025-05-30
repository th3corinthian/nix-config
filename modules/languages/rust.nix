{ config, pkgs, lib, ... }:

let 
  rustTools = with pkgs; [
    rustc
	  rustup
	  rustlings
	  cargo
	  cargo-generate
	  rustfmt
	  rust-analyzer
    wasm-pack
  ];
in {
   # Append to whatever else you have already installed
   environment.systemPackages = rustTools;
}
