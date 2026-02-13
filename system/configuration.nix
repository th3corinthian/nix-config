# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  customFonts = with (pkgs.nerd-fonts); [
    jetbrains-mono
    iosevka
  ];

  myfonts = pkgs.callPackage fonts/default.nix { inherit pkgs; };
in
{
  # CVE: https://discourse.nixos.org/t/newly-announced-vulnerabilities-in-cups/52771
  systemd.services.cups-browsed.enable = false;

  networking = {
    extraHosts = pkgs.sxm.hosts.extra or "";

    # Enables wireless support and openvpn via network manager.
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  services.mullvad-vpn.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "New-York";

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    firejail
    vim
    wget

    pass
    pinentry-curses

    mullvad-vpn

    git
    alacritty
    vlc
    firefox
    ranger
    bluetui
    qbittorrent
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };



  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable Docker support
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        bip = "169.254.0.1/16";
      };
    };
  };

  users.extraGroups.vboxusers.members = [ "corinthian" ];

  security.rtkit.enable = true;

  # Scanner backend
  #hardware.sane = {
    #enable = true;
    #extraBackends = with pkgs; [
      #epkowa
      #sane-airscan
    #];
  #};

  services = {
    # Network scanners
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    # Mount MTP devices
    gvfs.enable = true;

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      allowSFTP = true;
    };

    # Yubikey smart card mode (CCID)
    #pcscd.enable = true;

    #udev.packages = with pkgs; [
      #bazecor # Dygma Defy keyboard udev rules for non-root modifications
      #yubikey-personalization # Yubikey OTP mode (udev)
    #];

    # SSH daemon.
    sshd.enable = true;

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
  };

  # Making fonts accessible to applications.
  fonts.packages = with pkgs; [
    font-awesome
    myfonts.flags-world-color
    myfonts.icomoon-feather
  ] ++ customFonts;

  programs.fish.enable = true;

  # Diff report
  system.activationScripts.diff = ''
    if [[ $TERM == "xterm-kitty" ]]; then
      export TERM=xterm-256color
    fi

    BLUE=$(${pkgs.ncurses}/bin/tput setaf 4)
    CLEAR=$(${pkgs.ncurses}/bin/tput sgr0)

    if [[ -e /run/current-system ]]; then
      echo "$BLUE   $CLEAR System Diff Report $BLUE   $CLEAR"
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      echo "$BLUE                $CLEAR"
    fi
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.corinthian = {
    isNormalUser = true;
    # wheel for 'sudo', uucp for bazecor to access ttyAMC0 (keyboard firmware updates)
    extraGroups = [ "docker" "networkmanager" "wheel" "scanner" "lp" "uucp" ];
    shell = pkgs.fish;
  };

  security = {
    # Sudo custom prompt message
    sudo.configFile = ''
      Defaults lecture=always
      Defaults lecture_file=${misc/groot.txt}
    '';
  };

  # Nix daemon config
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Flakes settings
    package = pkgs.nixVersions.latest;

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Required by Cachix to be used as non-root user
      trusted-users = [ "root" "corinthian" ];

      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      warn-dirty = false;

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };
}
