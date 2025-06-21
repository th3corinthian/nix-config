# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      
      ./modules/languages/rust.nix
      ./modules/languages/python.nix
      ./modules/languages/go.nix
      ./modules/languages/haskell.nix

      ./modules/services/fonts.nix
      #./modules/services/ssh.nix

      ./modules/programs/gns3.nix
      ./modules/programs/emulators.nix
      ./modules/programs/android-tools.nix
      ./modules/programs/reverse-eng.nix
    ];
  
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  #networking.firewall.checkReversePath = false;
  #networking.firewall.allowedUDPPorts = [ 53 51820 ];	# DNS + WireGuard
  #networking.firewall.allowedTCPPorts = [ 443 ];	# HTTPS
  #networking.firewall.interfaces."tun0".allowedTCPPorts = [ 443 ];
  #networking.firewall.interfaces."tun0".allowedUDPPorts = [ 53 51820 ];
  

  # Enable mullvad-vpn
  services.mullvad-vpn.enable = true;
  networking.iproute2.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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
  
  security.polkit.enable = true;
  
  programs.hyprland.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm.enable = false;

  services.greetd.enable = true;
  services.greetd.settings = {
	default_session = {
		command = "Hyprland";
		user = "corinthian";
	};
  };

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.corinthian = {
    isNormalUser = true;
    description = "corinthian";
    extraGroups = [ "networkmanager" "wheel" "storage "];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 
  # enable D-Bus (required by udisks2)
  services.dbus.enable = true;

  # enable the udisk2 daemon
  services.udisks2.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     firefox
     krita
     steam 
     alacritty
     neovim
     vim
     texmacs
     libgcc
     libgccjit
     godot_4
     code-cursor
     blender
     libreoffice-qt6-fresh
     neofetch
     librepcb
     kitty
     _1password-gui
     git
     gh
     ripgrep
     fd
     findutils
     tor
     tor-browser
     emacs
     mu
     gcc
     clang
     zulu
     wget
     libsForQt5.kdenlive
     deluge
     openvpn
     zip
     unzip
     gimp-with-plugins
     librewolf
     wireguard-tools
     popsicle
     gcc
     gnumake
     tmux
     zulu
     dconf
     xwayland
     waybar
     rofi
     xfce.thunar
     xfce.thunar-volman
     gvfs
     udiskie
     udisks2
     hyprpaper
     mpv
     discord
     mullvad-vpn
     nixd
     p7zip
     pdfstudioviewer
  ];

  programs.steam.enable = true;
     
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable virtualbox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableKvm = true;
  virtualisation.virtualbox.host.addNetworkInterface = false;
  
  
  services.redis.servers."talos".enable = true;
  services.redis.servers."talos".port 	= 6379;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
