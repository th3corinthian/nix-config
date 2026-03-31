{ pkgs, ... }:

{
  home.packages = [ pkgs.xmobar ];

  xdg.configFile."xmobar/xmobarrc".text = ''
    Config
      { font        = "xft:JetBrainsMono Nerd Font:size=10:antialias=true"
      , bgColor     = "#1c2028"
      , fgColor     = "#c8ccd4"
      , position    = TopW L 100
      , lowerOnStart = True
      , hideOnStart  = False
      , allDesktops  = True
      , persistent   = True

      , commands =
          [ Run XMonadLog

          , Run Battery
              [ "--template", "<acstatus>"
              , "--Low",      "20"
              , "--High",     "80"
              , "--low",      "#be5046"
              , "--normal",   "#d19a66"
              , "--high",     "#98c379"
              , "--"
              , "-o", "bat <left>% (<timeleft>)"
              , "-O", "chg <left>%"
              , "-i", "full"
              ] 60

          , Run Cpu
              [ "--template", "cpu <total>%"
              , "--Low",      "30"
              , "--High",     "70"
              , "--low",      "#98c379"
              , "--normal",   "#d19a66"
              , "--high",     "#be5046"
              ] 20

          , Run Memory
              [ "--template", "mem <usedratio>%"
              , "--Low",      "50"
              , "--High",     "80"
              , "--low",      "#98c379"
              , "--normal",   "#d19a66"
              , "--high",     "#be5046"
              ] 20

          , Run Date "%a %d %b  %H:%M" "date" 60
          ]

      , sepChar  = "%"
      , alignSep = "}{"
      , template = " %XMonadLog% }{ %cpu%  ·  %memory%  ·  %battery%  ·  %date% "
      }
  '';
}
