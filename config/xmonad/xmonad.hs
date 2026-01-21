import XMonad

main = xmonad $ def
    { modMask    = mod4Mask  -- Use Super/Windows key as mod
    , terminal   = "alacritty" -- Change to your terminal (xterm, kitty, etc.)
    }
