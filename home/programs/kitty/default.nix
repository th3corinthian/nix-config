{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      background_opacity   = "0.92";
      background           = "#0a0a0a";
      foreground           = "#d0d0d0";
      selection_background = "#1c1c1c";
      selection_foreground = "#d0d0d0";
      cursor               = "#4ecdc4";
      cursor_text_color    = "#0a0a0a";
      url_color            = "#4ecdc4";

      color0  = "#141414";  color8  = "#383838";
      color1  = "#c0392b";  color9  = "#e74c3c";
      color2  = "#5a8a3c";  color10 = "#6aaf46";
      color3  = "#d4a520";  color11 = "#e8c030";
      color4  = "#4a7fa5";  color12 = "#5aafd0";
      color5  = "#8b6aaf";  color13 = "#a080cc";
      color6  = "#4ecdc4";  color14 = "#6ee8e0";
      color7  = "#d0d0d0";  color15 = "#f0f0f0";

      shell                   = "${pkgs.fish}/bin/fish";
      window_padding_width    = 6;
      hide_window_decorations = "yes";
    };
  };
}
