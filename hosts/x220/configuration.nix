{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.

      #(builtins.fetchTarball {
        #url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-25.11/nixos-mailserver-nixos-25.11.tar.gz";
      #})

      ./hardware-configuration.nix

      ../../modules/firefox.nix

      ../../modules/sys/utils.nix
      ../../modules/sys/picom.nix
      ../../modules/sys/audio.nix
      ../../modules/sys/clam.nix
      ../../modules/sys/time.nix

      ../../modules/net/mullvad.nix
      ../../modules/net/tor.nix

      ../../modules/firejail/librewolf.nix

      ../../modules/virt/wine.nix
      ../../modules/virt/virt.nix

      ../../modules/virtualization/docker.nix
      ../../modules/virt/android.nix
    ];

  boot.kernelModules = [ "kvm-intel" "kvm" "tap" "tun" "vhost_net" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking.hostName = "nixos"; # Define your hostname.

  services.tor = {
    enable = true;
    # Default SOCKS port is 9050, accessible locally [3].
  };

  programs.proxychains = {
    enable = true;
    # Use the default Tor SOCKS proxy on 9050 [3].
    # Configure chain type (dynamic_chain is common for Tor) [9, 10].
    # Default options usually point to Tor [3, 9, 10].
    # Example to force DNS over proxy:
    proxies.prx1 = {
      type = "socks5";
      host = "127.0.0.1";
      port = 9050;
    };

    proxyDNS = true;
    # Example custom config (if needed, overrides defaults):
    #extraConfig = ''
       #dynamic_chain
       #socks5 127.0.0.1 9050 # Usually defaults to this for Tor
     #'';
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #systemd.enableCgroupAccounting = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # enable dwm
  services.displayManager.ly.enable = true;
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = ../../config/dwm;
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.corinthian = {
    isNormalUser = true;
    description = "corinthian";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "docker" "podman" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [

    /* socials */
    catgirl
    irssi
    discord
    protonmail-bridge
    thunderbird
    burpsuite
    cryptsetup
    veracrypt
    lsof
    proxychains-ng
    proxychains

    maltego
    javaPackages.compiler.openjdk21
    jdk8_headless
    compose2nix


    /* utils */
    gparted
    anki
    libreoffice
    clamav
    thunderbird
    qbittorrent
    obs-studio
    keepass
    pass
    gnupg
    pinentry-curses
    nixos-generators
    usbutils

    # bulky heavy software, ewww
    kdePackages.kdenlive
    audacity
    godot
    _1password-gui

  ];

  sysUtils.enable = true;
  wineUtils.enable = true;
  androidUtils.enable = true;
  virtUtils.enable = true;
  clamTools.enable = true;
  defTime.enable = true;
  dockerServices.enable = true;
  hiddenServices.enable = true;
  picomConf.enable = true;
  audioUtils.enable = true;
  mullvadService.enable = true;
  fireLibrewolf.enable = true;
  firefox.enable = true;

  environment.variables.EDITOR = "neovim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    #extraConfig = "
      #Host nixos-desktop
           #Hostname 192.168.1.84
           #Port     5432
           #User     corinthian

           #IdentitiesOnly  yes
           #IdentityFile    ~/.ssh/nixos-desktop
    #";
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 443 80 9050 9150 5432 ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11";
}
