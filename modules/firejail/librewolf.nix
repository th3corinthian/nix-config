{ config, pkgs, lib, ... }:

{

  options.fireLibrewolf.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable picom";
  };

  config = lib.mkIf config.fireLibrewolf.enable {
    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        librewolf = {
          executable = "${pkgs.librewolf}/bin/librewolf";
          profile = "${pkgs.firejail}/etc/firejail/librewolf.profile";
          extraArgs = [
            # Required for U2F USB stick
            "--ignore=private-dev"
            # Enforce dark mode
            "--env=GTK_THEME=Adwaita:dark"
            # Enable system notifications
            "--dbus-user.talk=org.freedesktop.Notifications"
          ];
        };
        signal-desktop = {
          executable = "${pkgs.signal-desktop}/bin/signal-desktop --enable-features=UseOzonePlatform --ozone-platform=x11";
          profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
          extraArgs = [ "--env=GTK_THEME=Adwaita:dark" ];
        };
      };
    };
  };
}
