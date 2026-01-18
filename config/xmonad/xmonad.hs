import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Ungrab (unGrab)

main = xmonad $ def
	{ modMask = mod4Mask
	, terminal = "alacritty"
	}
	`additionalKeysP`
	[ ("M-S-<Return>", spawn $ terminal def)
	, ("M-p", spawn "demenu_run")
	]
