{
  services.picom = {
    enable = true;
    #activeOpacity = 1.0;
    #inactiveOpacity = 0.8;
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    opacityRules = [
      #"100:name *= 'i3lock'"
          # Focused Alacritty: 100% opaque; unfocused: 90%
      "95:class_g = 'Alacritty' && focused"
      "85:class_g = 'Alacritty' && !focused"

      # Kitty: focused 95%, unfocused 85%
      "95:class_g = 'kitty' && focused"
      "85:class_g = 'kitty' && !focused"

      "90:class_g = 'Emacs'"
      "90:class_g = 'firefox'"
    ];
    shadow = true;
    shadowOpacity = 0.75;
  };
}
