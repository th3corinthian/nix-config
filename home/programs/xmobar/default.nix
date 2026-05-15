{ pkgs, ... }:

{
  home.packages = [ pkgs.xmobar ];

  xdg.configFile."xmobar/xmobarrc".text = ''
    Config
      { font             = "xft:Mononoki Nerd Font:size=10:antialias=true:hinting=true:hintstyle=hintslight"
      , bgColor          = "#2a1f1f"
      , fgColor          = "#e8d5cb"
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
              , "--low",      "#d63d3d"
              , "--normal",   "#d4a846"
              , "--high",     "#98c379"
              , "--"
              , "-o", "<left>% (<timeleft>)"
              , "-O", "chg <left>%"
              , "-i", "full"
              ] 60

          , Run Cpu
              [ "--template", "<total>%"
              , "--Low",      "30"
              , "--High",     "70"
              , "--low",      "#98c379"
              , "--normal",   "#d4a846"
              , "--high",     "#d63d3d"
              ] 20

          , Run Memory
              [ "--template", "<usedratio>%"
              , "--Low",      "50"
              , "--High",     "80"
              , "--low",      "#98c379"
              , "--normal",   "#d4a846"
              , "--high",     "#d63d3d"
              ] 20

          , Run Date "<fc=#f5c2a0>%a %d %b  %H:%M</fc>" "date" 60
          ]

      , sepChar  = "%"
      , alignSep = "}{"
      , template = "  %XMonadLog%  }{ <fc=#b5262a>cpu</fc> %cpu%  <fc=#3d2b2b>|</fc>  <fc=#b5262a>mem</fc> %memory%  <fc=#3d2b2b>|</fc>  <fc=#b5262a>bat</fc> %battery%  <fc=#3d2b2b>|</fc>  %date%  "
      }
  '';
}
