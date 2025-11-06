{ config, pkgs, lib, ... }:

{
  options.sysUtils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable base std sysutils (e.g. nvim, emacs, gcc)";
  };

  config = lib.mkIf config.sysUtils.enable {
    environment.systemPackages = with pkgs; [
      wget
      ispell
      tts
      espeak
      tree-sitter
      git
      fd
	  fzf
      bat
      curl
      broot
      fastfetch
      ripgrep
      tmux
      musl
      openssl
      libressl
      sxhkd
      neovim
      emacs
      gcc
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
    ];
  };
}
