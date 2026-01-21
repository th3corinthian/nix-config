{ config, pkgs, lib, ... }:

{
  options.sysUtils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable base std sysutils (e.g. nvim, emacs, gcc)";
  };

  config = lib.mkIf config.sysUtils.enable {
    environment.systemPackages = with pkgs; [
      pnpm
      nodejs_24
      wget
      cron
      ispell
      bluetui
	    tts
      docker
      go
      gopls
      python314
      remmina
      syncthing
      ruby
      rustc
      rustup
      cargo
      rust-analyzer
      espeak
      tree-sitter
      git
      fd
      fzf
      bat
      curl
      ranger
      fastfetch
      ripgrep
      tmux
      musl
      openssl
      libressl
      sxhkd
      neovim
      tinycc
      alacritty
      plan9port
      mpv
      man
      ed
      htop
      iwd
      iw
      virt-manager
      virt-viewer
      qemu
      qemu_kvm
      libguestfs
      OVMF
      pass
      gnupg
      gpgme
      gpg-tui
      home-manager
      unzip
      unetbootin
      tree
      keepass
	  kdePackages.kleopatra
    ];
  };
}
