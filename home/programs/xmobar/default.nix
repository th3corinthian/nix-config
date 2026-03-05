{ pkgs, config, ... }:

{

  home.packages = [ pkgs.xmobar ];

    xdg.configFile."xmobar/xmobarrc".text = ''

    Config {
      font = "xft:DejaVu Sans Mono:size=10"
        , bgColor = "#lelele"
        , fgColor = "#ffffff"
        , position = Top
        , lowerOnStart = True
        , commands = [
            Run Battery [
                "-t", "<acstatus><left>% <timeleft>"
                , "-L", "20", "-H", "80"
                , "--low", "red", "--normal", "yellow", "--high", "green"
              ] 30
            , Run Date "%a %b %d %H:%M" "date" 10
            , Run XMonadLog          -- if you use XMonad
            -- Alternative for window title (see below):
            -- , Run Com "sh" ["-c", "xdotool getactivewindow getwindowname 2>/dev/null || echo 'No window'"] "title" 1
          ]
        , template = "} %XMonadLog% }{ %date%   |   %battery% {"
        -- If using the alternative title command:
        -- , template = "} %title% }{ %date%   |   %battery% {"
      }

    '';

  systemd.user.services.xmobar = {
    Unit = {
      Description = "Xmobar status bar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.xmobar}/bin/xmobar ${config.xdg.configFile."xmobar/xmobarrc".source}";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

#Config {
#      font = "xft:DejaVu Sans Mono:size=10"
#        , bgColor = "#222222"
#        , fgColor = "#eeeeee"
#        , position = Top
#        , lowerOnStart = True
#        , commands = [
#            Run Battery [
#                "-t", "<acstatus><left>% <timeleft>"
#                , "-L", "20", "-H", "80"
#                , "--low", "red", "--normal", "yellow", "--high", "green"
#              ] 30
#            , Run Date "%a %b %d %H:%M" "date" 10
#            , Run XMonadLog          -- if you use XMonad
#            -- Alternative for window title (see below):
#            -- , Run Com "sh" ["-c", "xdotool getactivewindow getwindowname 2>/dev/null || echo 'No window'"] "title" 1
#          ]
#        , template = "} %XMonadLog% }{ %date%   |   %battery% {"
#        -- If using the alternative title command:
#        -- , template = "} %title% }{ %date%   |   %battery% {"
#      }
