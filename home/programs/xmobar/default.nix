{ pkgs, ... }:

{
  home.packages = [ pkgs.xmobar ];

  xdg.configFile."xmobar/xmobarrc".text = ''
    Config
      { font             = "xft:Mononoki Nerd Font:size=10:antialias=true:hinting=true:hintstyle=hintslight"
      , bgColor          = "#0d1b2a"
      , fgColor          = "#c8e6f5"
      , alpha            = 210
      , position         = Static { xpos = 8, ypos = 6, width = 1350, height = 28 }
      , lowerOnStart     = True
      , hideOnStart      = False
      , allDesktops      = True
      , persistent       = True
      , border           = NoBorder

      , commands =
          [ Run XMonadLog

          , Run Battery
              [ "--template", "<acstatus>"
              , "--Low",      "20"
              , "--High",     "80"
              , "--low",      "#e57373"
              , "--normal",   "#ffb74d"
              , "--high",     "#81c784"
              , "--"
              , "-o", "<left>% (<timeleft>)"
              , "-O", "chg <left>%"
              , "-i", "full"
              ] 60

          , Run Cpu
              [ "--template", "<total>%"
              , "--Low",      "30"
              , "--High",     "70"
              , "--low",      "#81c784"
              , "--normal",   "#ffb74d"
              , "--high",     "#e57373"
              ] 20

          , Run Memory
              [ "--template", "<usedratio>%"
              , "--Low",      "50"
              , "--High",     "80"
              , "--low",      "#81c784"
              , "--normal",   "#ffb74d"
              , "--high",     "#e57373"
              ] 20

          , Run Date "<fc=#90caf9> %a %d %b   %H:%M</fc>" "date" 60
          ]

      , sepChar  = "%"
      , alignSep = "}{"
      , template = "  %XMonadLog%  }{ <fc=#4fc3f7></fc> %cpu%  <fc=#2980b9>|</fc>  <fc=#4fc3f7></fc> %memory%  <fc=#2980b9>|</fc>  <fc=#4fc3f7></fc> %battery%  <fc=#2980b9>|</fc>  %date%  "
      }
  '';
}
