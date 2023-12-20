import XMonad

import System.Exit (exitSuccess)

import XMonad.Actions.CycleWS (nextScreen, prevScreen, swapNextScreen, swapPrevScreen)

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
import XMonad.Layout.IndependentScreens

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

myWorkspaces :: [[Char]]
myWorkspaces = [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]

----------------
-- entrypoint --
----------------
main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
--     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     . dynamicEasySBs myStatusBarSpawner
     . docks
     $ myConfig

myConfig = def
    { modMask    = myModMask    -- Rebind Mod
    , layoutHook = myLayout     -- Use custom layouts
    , manageHook = myManageHook -- Match on certain windows
    , workspaces = withScreens 2 myWorkspaces
    , keys       = myKeys

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
    [ ("M-q", spawn "xmonad --recompile; xmonad --restart")

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

    -- Screens
    , ("M-w", prevScreen)
    , ("M-e", nextScreen)
    , ("M-r", nextScreen)
    , ("M-S-w", swapPrevScreen)
    , ("M-S-r", swapNextScreen)

    -- Toggle float
    , ("M-S-f", toggleFloat)

    -- Resize the master/slave ratio
    , ("M-h", sendMessage Shrink)
    , ("M-l", sendMessage Expand)
    ]

-----------------------
-- Multiple Monitors --
-----------------------
-- Change workspace script using independent monitors
myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $
 [((m .|. modm, k), windows $ onCurrentScreen f i)
 | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
 , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
 ]

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , className =? "Peek" --> doFloat
    , className =? "Gnome-calculator" --> doFloat
    , isDialog            --> doFloat
    , manageDocks
    ]

myLayout = smartBorders $ spacingRaw True myBorder True myBorder True $ myLayouts

myLayouts = toggleLayouts (noBorders Full) (tiled ||| Mirror tiled ||| Full)
  where
    tiled    = reflectHoriz $ Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

-----------------
-- Status Bars --
-----------------

-- xmobarTop    = statusBarPropTo "_XMONAD_LOG_1" "xmobar -x 0 ~/.config/xmobar/xmobarrc" (pure myXmobarPP)
--xmobarPrimary = statusBarPropTo "_XMONAD_LOG_1" "xmobar -x 0 ~/.config/xmobar/xmobarrc_primary" (pure $ myXmobarPP (0))
--xmobarOthers  = statusBarPropTo "_XMONAD_LOG_2" "xmobar -x 1 ~/.config/xmobar/xmobarrc_others" (pure $ myXmobarPP (1))
--
--barSpawner :: ScreenId -> IO StatusBarConfig
--barSpawner 0 = pure $ xmobarPrimary -- two bars on the main screen
--barSpawner _ = pure $ xmobarOthers
-- barSpawner _ = mempty -- nothing on the rest of the screens

myStatusBarSpawner :: Applicative f => ScreenId -> f StatusBarConfig
myStatusBarSpawner (S s) = do
                    pure $ statusBarPropTo ("_XMONAD_LOG_" ++ show s)
                          ("xmobar -x " ++ show s ++ " ~/.config/xmobar/xmobarrc_" ++ show s)
                          (pure $ myXmobarPP (S s))

myXmobarPP :: ScreenId -> PP
myXmobarPP s = marshallPP s $ def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap "" "" . xmobarBorder "Full" "yellow" 2 . wrap " " " "
    , ppVisible         = wrap "" "" . xmobarBorder "Full" "lowWhite" 2 . wrap " " " "
    , ppHidden          = lowWhite . wrap " " " "
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

myXmobarOtherPP :: PP
myXmobarOtherPP = def
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
    magenta  = xmobarColor "#0f79c6" ""
    blue     = xmobarColor "#0d93f9" ""
    white    = xmobarColor "#08f8f2" ""
    yellow   = xmobarColor "#01fa8c" ""
    red      = xmobarColor "#0f5555" ""
    lowWhite = xmobarColor "#0bbbbb" ""

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
