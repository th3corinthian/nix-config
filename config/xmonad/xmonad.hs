{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Util.Loggers
import XMonad.Actions.CycleWS
import XMonad.Prompt
import XMonad.Prompt.Shell

import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- ### Transparency Settings ###
import XMonad.Hooks.SetWMName

-- Use picom for transparency
myTransparencyRules = "--blur-method dual_kawase --blur-strength 8 \
                     \ --inactive-opacity 0.92 --active-opacity 0.95 \
                     \ --opacity-rule '90:class_g = \"Alacritty\"' \
                     \ --opacity-rule '90:class_g = \"Emacs\"'"

-- ### Xmobar PP (Pretty Printer) Configuration ###
myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = xmobarColor "#88C0D0" "" . wrap "[" "]"
    , ppVisible         = xmobarColor "#EBCB8B" "" . wrap "(" ")"
    , ppHidden          = xmobarColor "#D8DEE9" "" . wrap " " " "
    , ppHiddenNoWindows = xmobarColor "#4C566A" ""
    , ppUrgent          = xmobarColor "#BF616A" "" . wrap "!" "!"
    , ppSep             = "  "
    , ppTitle           = xmobarColor "#B48EAD" "" . shorten 40
    , ppLayout          = xmobarColor "#A3BE8C" ""
    , ppOrder           = \(ws:l:t:_) -> [ws, l, t]
    }

-- ### Main Configuration ###
main :: IO ()
main = do
    -- Start xmobar
    xmproc <- spawnPipe "xmobar ~/.config/xmonad/xmobarrc"

    -- Start picom for transparency
    spawnOnce $ "picom " ++ myTransparencyRules

    -- Set background image (change path to your image)
    spawnOnce "feh --bg-scale ~/Pictures/wallpaper.jpg"

    -- Start xmonad with config
    xmonad $ ewmhFullscreen . ewmh . docks $ def
        { modMask            = mod4Mask
        , terminal           = "alacritty"
        , borderWidth        = 2
        , normalBorderColor  = "#2E3440"
        , focusedBorderColor = "#88C0D0"

        -- ### Workspaces ###
        , workspaces         = myWorkspaces

        -- ### Key Bindings ###
        , keys               = myKeys

        -- ### Layouts ###
        , layoutHook         = myLayout

        -- ### Window Rules ###
        , manageHook         = myManageHook

        -- ### Startup Applications ###
        , startupHook        = myStartupHook

        -- ### Event Handling ###
        , handleEventHook    = fullscreenEventHook <+> docksEventHook

        -- ### Xmobar Log Hook ###
        , logHook            = dynamicLogWithPP $ myXmobarPP
            { ppOutput = hPutStrLn xmproc
            }
        }

-- ### Workspace Configuration ###
myWorkspaces = ["1:term", "2:web", "3:code", "4:docs", "5:media", "6:chat", "7:sys", "8:emacs", "9:tmp"]

-- ### Custom Key Bindings (with xmobar toggle) ###
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {modMask = modm}) = M.fromList $
    -- Basic Xmonad controls
    [ ((modm, xK_Return), spawn $ terminal conf)
    , ((modm, xK_p), spawn "dmenu_run -fn 'Fira Code:size=10' -nb '#2E3440' -nf '#D8DEE9' -sb '#5E81AC' -sf '#ECEFF4'")
    , ((modm, xK_q), spawn "xmonad --recompile && xmonad --restart")
    , ((modm .|. shiftMask, xK_q), io exitSuccess)

    -- Application launchers
    , ((modm, xK_e), spawn "emacsclient -c -a ''")
    , ((modm, xK_f), spawn "firefox")
    , ((modm, xK_b), spawn "brave")

    -- Xmobar control
    , ((modm, xK_x), spawn "killall xmobar && xmobar ~/.config/xmonad/xmobarrc &")
    , ((modm .|. shiftMask, xK_x), spawn "pkill xmobar")

    -- Workspace navigation
    , ((modm, xK_Tab), moveTo Next NonEmptyWS)
    , ((modm .|. shiftMask, xK_Tab), moveTo Prev NonEmptyWS)

    -- Window management
    , ((modm .|. shiftMask, xK_c), kill)
    , ((modm, xK_space), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space), setLayout $ layoutHook conf)

    -- Screen brightness (X220 specific)
    , ((0, 0x1008FF02), spawn "brightnessctl set +10%")  -- Brightness up
    , ((0, 0x1008FF03), spawn "brightnessctl set 10%-")  -- Brightness down

    -- Volume control
    , ((0, 0x1008FF12), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, 0x1008FF13), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0, 0x1008FF11), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")

    -- Screenshots
    , ((modm, xK_Print), spawn "flameshot gui")
    , ((0, xK_Print), spawn "flameshot screen -c")

    -- Mullvad VPN control
    , ((modm .|. controlMask, xK_v), spawn "mullvad connect")
    , ((modm .|. controlMask .|. shiftMask, xK_v), spawn "mullvad disconnect")

    -- Toggle xmobar (docks)
    , ((modm, xK_b), sendMessage ToggleStruts)
    ]
    ++
    -- Workspace keys (1-9)
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

-- ### Layout Configuration (adjusted for xmobar) ###
myLayout = avoidStruts $ smartBorders $ spacingRaw False (Border 5 5 5 5) True (Border 5 5 5 5) True $
    tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    tiled   = Tall nmaster delta ratio
    threeCol = ThreeColMid nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

-- ### Window Management Rules ###
myManageHook = composeAll
    [ className =? "Emacs"        --> doShift "8:emacs"
    , className =? "firefox"      --> doShift "2:web"
    , className =? "brave-browser" --> doShift "2:web"
    , className =? "discord"      --> doShift "6:chat"
    , className =? "TelegramDesktop" --> doShift "6:chat"
    , className =? "spotify"      --> doShift "5:media"
    , className =? "mpv"          --> doShift "5:media"
    , className =? "Gimp"         --> doFloat
    , className =? "feh"          --> doFloat
    , className =? "Pavucontrol"  --> doFloat
    , isDialog                    --> doFloat
    , isFullscreen                --> doFullFloat
    ]

-- ### Startup Applications ###
myStartupHook = do
    spawnOnce "nm-applet"
    spawnOnce "blueman-applet"
    spawnOnce "pasystray"
    spawnOnce "redshift-gtk -l 55.7:12.6"
    spawnOnce "xset r rate 200 30"
    setWMName "LG3D"  -- Fix for Java applications
    -- Start xmobar if not already running
    spawnOnce "sleep 1 && xmobar ~/.config/xmonad/xmobarrc &"
