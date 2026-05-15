import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.Gaps
import XMonad.Hooks.ManageDocks      (avoidStruts, docks)
import XMonad.Hooks.DynamicLog       (xmobarColor, shorten, PP(..))
import XMonad.Hooks.StatusBar        (withSB, statusBarProp)
import XMonad.Hooks.StatusBar.PP     (def, wrap)

myLayout = avoidStruts $
           gaps [(U,8), (R,8), (D,8), (L,8)] $
           Tall 1 (3/100) (1/2) ||| Full

myXmobarPP :: PP
myXmobarPP = def
  { ppSep             = xmobarColor "#3d2b2b" ""  "  ·  "
  , ppCurrent         = xmobarColor "#b5262a" "" . wrap "[" "]"
  , ppVisible         = xmobarColor "#d4a846" ""
  , ppHidden          = xmobarColor "#e8d5cb" ""
  , ppHiddenNoWindows = xmobarColor "#3d2b2b" ""
  , ppUrgent          = xmobarColor "#d63d3d" "" . wrap "!" "!"
  , ppTitle           = xmobarColor "#e8d5cb" "" . shorten 50
  , ppLayout          = xmobarColor "#d4a846" ""
  }

main :: IO ()
main = xmonad
     . withSB (statusBarProp "xmobar" (pure myXmobarPP))
     . docks
     $ def
  { layoutHook         = myLayout
  , terminal           = "alacritty"
  , modMask            = mod4Mask
  , borderWidth        = 2
  , focusedBorderColor = "#b5262a"
  , normalBorderColor  = "#3d2b2b"
  , startupHook =
      spawn "nitrogen --set-zoom-fill ~/.wallpapers/my-wallpaper.jpg" <>
      spawn "picom --config /home/corinthian/.config/picom/picom.conf"
  } `additionalKeys`
  [ ((mod4Mask,               xK_Return), spawn "alacritty")
  , ((mod4Mask .|. shiftMask, xK_p),     spawn "rofi -show drun")
  , ((mod4Mask .|. shiftMask, xK_c),     kill)
  , ((mod4Mask,               xK_q),     spawn "xmonad --recompile && xmonad --restart")
  ]
