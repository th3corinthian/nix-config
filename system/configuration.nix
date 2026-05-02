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

  #nixpkgs.config.allowBroken = true;
  #nixpkgs.config.allowUnsupportedSystem = true;
in
{
  # CVE: https://discourse.nixos.org/t/newly-announced-vulnerabilities-in-cups/52771
  systemd.services.cups-browsed.enable = false;

  networking = {
    extraHosts = pkgs.sxm.hosts.extra or "";

    # Enables wireless support and openvpn via network manager.
    networkmanager = {
      enable = true;
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;   # full GUI+CLI+daemon derivation
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
    "zh_TW.UTF-8/UTF-8"
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
    ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    firejail
    vim
    wget

    pass
    pinentry-curses


    git
    alacritty
    vlc
    firefox
    ranger
    bluetui
    qbittorrent
    nasm
    android-tools
    scrcpy
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  boot.kernel.sysctl."net.ipv4.ping_group_range" = "0 2147483647";

  # List services that you want to enable:

  networking.firewall = {
    enable = true;
    # All TCP/UDP traffic on the Tailscale interface is trusted (SSH, Sunshine, etc.)
    # Once Tailscale is confirmed working, remove 22 from allowedTCPPorts — SSH
    # will then only be reachable via the encrypted Tailscale tunnel.
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 41641 ];
  };

  # Enable Docker support
  virtualisation = {
    docker = {
      enable = true;
      #autoPrune = {
        #enable = true;
        #dates = "weekly";
      #};
      daemon.settings = {
        #bip = "169.254.0.1/16";
        log-driver = "json-file";
        log-opts = {
          max-size = "10m";
          max-file = "3";
        };
      };
    };
  };

  users.extraGroups.vboxusers.members = [ "corinthian" ];

  security.rtkit.enable = true;

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

     #fail2ban = {
       #enable = true;
       # Ban IP after 5 failures
       #maxretry = 5;
       #bantime = "24h"; # Ban IPs for one day on the first ban
       #bantime-increment = {
         #enable = true; # Enable increment of bantime after each violation
         #formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
         #multipliers = "1 2 4 8 16 32 64";
         #maxtime = "168h"; # Do not ban for more than 1 week
         #overalljails = true; # Calculate the bantime based on all the violations
       #};
       #jails = {
         #apache-nohome-iptables.settings = {
           # Block an IP address if it accesses a non-existent
           # home directory more than 5 times in 10 minutes,
           # since that indicates that it's scanning.
           #filter = "apache-nohome";
           #action = ''iptables-multiport[name=HTTP, port="http,https"]'';
           #logpath = "/var/log/httpd/error_log*";
           #backend = "auto";
           #findtime = 600;
           #bantime  = 600;
           #maxretry = 5;
         #};
       #};
     #};

    # Yubikey smart card mode (CCID)
    #pcscd.enable = true;

    #udev.packages = with pkgs; [
      #bazecor # Dygma Defy keyboard udev rules for non-root modifications
      #yubikey-personalization # Yubikey OTP mode (udev)
    #];

    tailscale = {
      enable = true;
      # After sops bootstrap, uncomment to auto-authenticate on nixos-rebuild:
      # authKeyFile = config.sops.secrets."tailscale/authkey".path;
    };

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
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
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

  #programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.corinthian = {
    isNormalUser = true;
    # wheel for 'sudo', uucp for bazecor to access ttyAMC0 (keyboard firmware updates)
    extraGroups = [ "docker" "networkmanager" "wheel" "scanner" "lp" "uucp" "adbusers" ];
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPXjObNZb56FQNYTCfhj2z6gzn+pxIX9JQtFvl5eRsaB corinthian@x220"
    ];
    shell = pkgs.fish;
  };

  security = {
    # Sudo custom prompt message
    sudo.configFile = ''
      Defaults lecture=always
      Defaults lecture_file=${misc/groot.txt}
    '';
  };

  # sops-nix: decrypt secrets using each machine's SSH host key as an age key.
  # Bootstrap steps (one-time, per machine):
  #   1. nix shell nixpkgs#age nixpkgs#ssh-to-age
  #   2. Get age pubkey: cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
  #      (or remotely: ssh-keyscan -t ed25519 <host> | ssh-to-age)
  #   3. Add pubkeys to .sops.yaml at the repo root, then:
  #   4. sops secrets/secrets.yaml  — create/edit the encrypted secrets file
  #   5. Uncomment authKeyFile in services.tailscale above
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # sops.defaultSopsFile = ../secrets/secrets.yaml;   # uncomment after step 4
  # sops.secrets."tailscale/authkey" = {};            # uncomment after step 4

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
