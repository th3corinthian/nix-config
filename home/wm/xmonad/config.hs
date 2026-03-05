import XMonad
import XMonad.Util.EZConfig

main = xmonad $ def
  { startupHook = spawn "feh --big-scale ~/.wallpapers/wp10117214.jpg"
  , terminal    = "alacritty"
  , modMask     = mod4Mask
  , borderWidth = 2
  } `additionalKeys`
  [ ((mod4Mask, xK_Return), spawn "alacritty")
  , ((mod4Mask .|. shiftMask, xK_p), spawn "rofi -show drun")
  , ((mod4Mask .|. shiftMask, xK_c), kill)
  , ((mod4Mask, xK_q), spawn "xmonad --recompile && xmonad --restart")
  ]

--import XMonad
--import XMonad.Util.EZConfig
-- import XMonad.Hooks.DynamicLog   -- <-- new import

--main = xmonad =<< xmobar def      -- <-- wrap with xmobar to get the pipe handle
  --{ terminal    = "alacritty"
  --, modMask     = mod4Mask
  --, borderWidth = 2
  --, logHook     = dynamicLogWithPP $ xmobarPP {   -- <-- add logHook
        --ppOutput = hPutStrLn xmobarProc           -- send to xmobar's pipe
      --, ppTitle  = xmobarColor "green" "" . shorten 60   -- format window title
        -- you can customize other fields like ppCurrent, ppVisible, etc.
    --}
  --} `additionalKeys`
  --[ ((mod4Mask, xK_Return), spawn "alacritty")
  --, ((mod4Mask .|. shiftMask, xK_p), spawn "rofi -show drun")
  --, ((mod4Mask .|. shiftMask, xK_c), kill)
  --, ((mod4Mask, xK_q), spawn "xmonad --recompile && xmonad --restart")
  --]

--import XMonad
---import XMonad.Util.EZConfig
--import XMonad.Hooks.DynamicLog
-- import System.IO (hPutStrLn)   -- needed for writing to the pipe

--main = do
    -- Obtain the handle that xmobar listens on
    --xmobarProc <- xmobar def
    -- Start xmonad with the handle used in the logHook
    --xmonad $ def
        --{ terminal    = "alacritty"
        --, modMask     = mod4Mask
        --, borderWidth = 2
        --, logHook     = dynamicLogWithPP $ xmobarPP
            --{ ppOutput = hPutStrLn xmobarProc
            --, ppTitle  = xmobarColor "green" "" . shorten 60
            --}
        --} `additionalKeys`
        --[ ((mod4Mask, xK_Return), spawn "alacritty")
        --, ((mod4Mask .|. shiftMask, xK_p), spawn "rofi -show drun")
        --, ((mod4Mask .|. shiftMask, xK_c), kill)
        --, ((mod4Mask, xK_q), spawn "xmonad --recompile && xmonad --restart")
        --]
