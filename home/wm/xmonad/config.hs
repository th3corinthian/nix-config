import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.Gaps
import XMonad.Hooks.ManageDocks      (avoidStruts, docks)
import XMonad.Hooks.DynamicLog       (xmobarColor, shorten, PP(..))
import XMonad.Hooks.StatusBar        (withSB, statusBarProp)
import XMonad.Hooks.StatusBar.PP     (def, wrap)

myLayout = avoidStruts $
           gaps [(U,6), (R,6), (D,6), (L,6)] $
           Tall 1 (3/100) (1/2) ||| Full

myXmobarPP :: PP
myXmobarPP = def
  { ppSep             = xmobarColor "#4b5263" "" "  ·  "
  , ppCurrent         = xmobarColor "#7aa2d4" "" . wrap "[" "]"
  , ppVisible         = xmobarColor "#7aa2d4" ""
  , ppHidden          = xmobarColor "#c8ccd4" ""
  , ppHiddenNoWindows = xmobarColor "#4b5263" ""
  , ppUrgent          = xmobarColor "#be5046" "" . wrap "!" "!"
  , ppTitle           = xmobarColor "#c8ccd4" "" . shorten 50
  , ppLayout          = xmobarColor "#7aa2d4" ""
  }

main :: IO ()
main = xmonad
     . withSB (statusBarProp "xmobar" (pure myXmobarPP))
     . docks
     $ def
  { layoutHook  = myLayout
  , terminal    = "alacritty"
  , modMask     = mod4Mask
  , borderWidth = 1
  , startupHook =
      spawn "nitrogen --set-zoom-fill ~/.wallpapers/my-wallpaper.jpg" <>
      spawn "picom --config /home/corinthian/.config/picom/picom.conf"
  } `additionalKeys`
  [ ((mod4Mask,               xK_Return), spawn "alacritty")
  , ((mod4Mask .|. shiftMask, xK_p),     spawn "rofi -show drun")
  , ((mod4Mask .|. shiftMask, xK_c),     kill)
  , ((mod4Mask,               xK_q),     spawn "xmonad --recompile && xmonad --restart")
  ]
