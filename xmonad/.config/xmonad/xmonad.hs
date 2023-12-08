import XMonad

import System.Exit (exitSuccess)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Layout.NoBorders (noBorders, smartBorders) -- for fullscreen
import XMonad.Layout.Spacing (spacingRaw, smartSpacing, Border(..))
import XMonad.Layout.Reflect (reflectHoriz)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.EwmhDesktops

---------------
-- Variables --
---------------

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "firefox"

myModMask :: KeyMask
myModMask = mod4Mask -- super

myBorder :: Border
myBorder = (Border 5 5 5 5)

----------------
-- entrypoint --
----------------
main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myConfig = def
    { modMask    = myModMask    -- Rebind Mod
    , layoutHook = myLayout     -- Use custom layouts
    , manageHook = myManageHook -- Match on certain windows

    , focusFollowsMouse = False -- Whether focusu follows the mouse pointer.
    , clickJustFocuses = False  -- Pass the initial click through to the window.
    , terminal          = myTerminal
    }
  `additionalKeysP` myKeybinds

-----------------
-- keybindings --
-----------------

myKeybinds :: [(String, X ())]
myKeybinds =
    -- XMonad
    [ ("M-S-r", spawn "xmonad --recompile; xmonad --restart")

    -- System
    , ("M-<Escape>", spawn "xscreensaver-command -lock" ) -- lock screen
    , ("M-S-<Escape>", io exitSuccess)                    -- logout

    -- Applications
    , ("M-<Return>", spawn myTerminal )
    , ("M-S-<Return>", spawn myBrowser )
    , ("M-<Space>", spawn "rofi -show drun -show-icons" )

    -- Windows
    , ("M-S-q", kill)                      -- kill window
    , ("M-t", sendMessage NextLayout)      -- rotate layouts
    , ("M-f", sendMessage (Toggle "Full")) -- toggle full screen
    , ("M-m", windows W.focusMaster)
    , ("M-S-m", windows W.swapMaster)
    , ("M-j", windows W.focusDown)
    , ("M-k", windows W.focusUp)

    -- Toggle float
    , ("M-S-f", toggleFloat)

    -- Resize the master/slave ratio
    , ("M-h", sendMessage Shrink)
    , ("M-l", sendMessage Expand)
    ]

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    , manageDocks
    ]

myLayout = smartBorders $ spacingRaw True myBorder True myBorder True $ myLayouts

myLayouts = toggleLayouts (noBorders Full) (tiled ||| Mirror tiled ||| Full)
  where
    tiled    = reflectHoriz $ Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 3/4    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Bottom" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    --, ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

-------------------------
-- Utilities           --
-------------------------

--
-- Floating window stuff
--

-- If the window is floating then (f), if tiled then (n)
floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats -- if the current window is floating...
       then f
       else n

-- Centre and float a window (retain size)
centreFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

-- Float a window in the centre
centreFloat' w = windows $ W.float w (W.RationalRect 0.75 0.75 0.5 0.5)

-- Make a window my 'standard size' (half of the screen) keeping the centre of the window fixed
standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()

-- Float and centre a tiled window, sink a floating window
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused centreFloat')
