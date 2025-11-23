{ config, lib, ... }:

{

  options.picomConf.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable picom";
  };

  config = lib.mkIf config.picomConf.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      fade = true;
      inactiveOpacity = 1.0;
      activeOpacity = 1.0;
      opacityRules = [
        "90:class_g = 'Alacritty'"
        "90:class_g = 'Emacs'"
        "90:class_g = 'iaito'"
        "90:class_g = 'librewolf'"
      ];
    };
    services.pcscd.enable = true;
  };
}
