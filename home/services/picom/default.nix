{
  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    #cornerRadius = 10;
    opacityRules = [
      "95:class_g = 'Alacritty' && focused"
      "85:class_g = 'Alacritty' && !focused"
      "95:class_g = 'kitty' && focused"
      "85:class_g = 'kitty' && !focused"
      "90:class_g = 'Emacs'"
      "90:class_g = 'firefox'"
    ];
    shadow = true;
    shadowOpacity = 0.75;
    settings = {
      "blur-method" = "dual_kawase";
      "blur-strength" = 5;
      "blur-background" = true;
      "blur-background-exclude" = [
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      "rounded-corners-exclude" = [
        "window_type = 'desktop'"
      ];
    };
  };
}
