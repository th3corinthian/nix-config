{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../modules/sys/utils.nix
	  ../../modules/sys/picom.nix

      ../../modules/firejail/librewolf.nix

      ../../modules/wine.nix
      ../../modules/virt.nix
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
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  systemd.services.mullvad-daemon.environment = {
    TALPID_NET_CLS_MOUNT_DIR = "/run/net-cls-v1";
  };

  systemd.enableCgroupAccounting = true;
  # Enable networking
  networking.networkmanager.enable = true;

  # the mole mutha fucka <O_O> 
  services.mullvad-vpn.enable = true;
  networking.iproute2.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

  # Enable sound with pipewire.
  #services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.corinthian = {
    isNormalUser = true;
    description = "corinthian";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "docker" "lxd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [

  	/* utils */
	alsa-utils
	alsa-oss
	gparted
	libreoffice
	docker
	mullvad-vpn
    clamav
	fzf
	thunderbird
	irssi
	catgirl
	qbittorrent
	librewolf
  obs-studio
  keepass
  nixos-generators

	# bulky heavy software, ewww
	krita
	kdePackages.kdenlive
	renoise
	discord
	godot
	_1password-gui
  aseprite

	/* languages */
	lua
	go
	gopls
	cargo
	rustc
	ruby
	python313
	python314
	python313Packages.pip
	zulu
	powershell
	dotnet-sdk
  nodejs_24
  ];

  sysUtils.enable = true;
  wineUtils.enable = true;
  virtUtils.enable = true;
  picomConf.enable = true;

  fireLibrewolf.enable = true;

  environment.variables.EDITOR = "neovim";

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 443 80 ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";
}
