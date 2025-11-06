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
        "85:class_g = 'Alacritty'"
        "85:class_g = 'Emacs'"
        "85:class_g = 'iaito'"
        "85:class_g = 'librewolf'"
        "85:class_g = 'st'"
      ];
    };
    services.pcscd.enable = true;
  };
}
