import XMonad
import XMonad.Util.EZConfig

main = xmonad $ def
  { terminal    = "alacritty"
  , modMask     = mod4Mask
  , borderWidth = 2
  } `additionalKeys`
  [ ((mod4Mask, xK_Return), spawn "alacritty")
  , ((mod4Mask .|. shiftMask, xK_p), spawn "rofi -show drun")
  , ((mod4Mask .|. shiftMask, xK_c), kill)
  , ((mod4Mask, xK_q), spawn "xmonad --recompile && xmonad --restart")
  ]
