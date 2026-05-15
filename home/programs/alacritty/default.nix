{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      bell = {
        animation = "EaseOutExpo";
        duration = 5;
        color = "#ffffff";
      };
      colors = {
        primary = {
          background = "#0a0a0a";
          foreground = "#d0d0d0";
        };
        normal = {
          black   = "#141414"; red     = "#c0392b"; green   = "#5a8a3c"; yellow = "#d4a520";
          blue    = "#4a7fa5"; magenta = "#8b6aaf"; cyan    = "#4ecdc4"; white  = "#d0d0d0";
        };
        bright = {
          black   = "#383838"; red     = "#e74c3c"; green   = "#6aaf46"; yellow = "#e8c030";
          blue    = "#5aafd0"; magenta = "#a080cc"; cyan    = "#6ee8e0"; white  = "#f0f0f0";
        };
      };
      font = {
        normal = {
          family = "Mononoki Nerd Font Mono";
          style = "Regular";
        };
        #size = config.programs.alacritty.fontsize;
      };
      keyboard.bindings = [
        { key = 53; mods = "Shift"; mode = "Vi"; action = "SearchBackward"; }
        #{ key = "Return"; mods = "Shift"; chars = "\\x1b[13;2u"; }
        #{ key = "Return"; mods = "Control"; chars = "\\x1b[13;5u"; }
      ];
      hints.enabled = [
        {
          regex = ''(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
          command = "${pkgs.mimeo}/bin/mimeo";
          post_processing = true;
          mouse.enabled = true;
        }
      ];
      selection.save_to_clipboard = true;
      terminal.shell.program = "${pkgs.fish}/bin/fish";
      window = {
        decorations = "full";
        opacity = 0.92;
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}
