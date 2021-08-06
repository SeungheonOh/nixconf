import System.IO
import System.Exit
-- import System.Taffybar.Hooks.PagerHints (pagerHints)

import qualified Data.List as L

import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.UpdatePointer

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops (ewmh)

import XMonad.Layout.Gaps
import XMonad.Layout.Fullscreen
import XMonad.Layout.BinarySpacePartition as BSP
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.ZoomRow

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Cursor

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

mTerminal = "xterm"
mLauncher = "rofi -show"

mWorkspaces = map show [1..9]

mManageHook = composeAll
        [ className =? "Google-chrome" --> doShift "1"
        ]
        

        
mNav2DConf = def
    { defaultTiledNavigation    = centerNavigation
    , floatNavigation           = centerNavigation
    , screenNavigation          = lineNavigation
    , layoutNavigation          = [("Full",          centerNavigation)
    -- line/center same results   ,("Tabs", lineNavigation)
    --                            ,("Tabs", centerNavigation)
                                  ]
    , unmappedWindowRect        = [("Full", singleWindowRect)
    -- works but breaks tab deco  ,("Tabs", singleWindowRect)
    -- doesn't work but deco ok   ,("Tabs", fullScreenRect)
                                  ]
    }
    
mLayout = avoidStruts $
        tiled
        ||| Mirror tiled
        ||| Full
        ||| tabbed shrinkText def
        ||| threeCol
--           ||| spiral (4/3)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     threeCol = ThreeCol nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 2/100
        

mKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList $
        [ ((modMask .|. shiftMask, xK_Return),
           spawn $ XMonad.terminal conf)

        -- "Standard" xmonad key bindings
          --

          -- Close focused window.
          , ((modMask .|. shiftMask, xK_c),
             kill)

          -- Cycle through the available layout algorithms.
          , ((modMask, xK_space),
             sendMessage NextLayout)

          --  Reset the layouts on the current workspace to default.
          , ((modMask .|. shiftMask, xK_space),
             setLayout $ XMonad.layoutHook conf)

          -- Resize viewed windows to the correct size.
          , ((modMask, xK_n),
             refresh)

          -- Move focus to the next window.
          , ((modMask, xK_j),
             windows W.focusDown)

          -- Move focus to the previous window.
          , ((modMask, xK_k),
             windows W.focusUp  )

          -- Move focus to the master window.
          , ((modMask, xK_m),
             windows W.focusMaster  )

          -- Swap the focused window and the master window.
          , ((modMask, xK_Return),
             windows W.swapMaster)

          -- Swap the focused window with the next window.
          , ((modMask .|. shiftMask, xK_j),
             windows W.swapDown  )

          -- Swap the focused window with the previous window.
          , ((modMask .|. shiftMask, xK_k),
             windows W.swapUp    )

          -- Shrink the master area.
          , ((modMask, xK_h),
             sendMessage Shrink)

          -- Expand the master area.
          , ((modMask, xK_l),
             sendMessage Expand)

          -- Push window back into tiling.
          , ((modMask, xK_t),
             withFocused $ windows . W.sink)

          -- Increment the number of windows in the master area.
          , ((modMask, xK_comma),
             sendMessage (IncMasterN 1))

          -- Decrement the number of windows in the master area.
          , ((modMask, xK_period),
             sendMessage (IncMasterN (-1)))

          -- Quit xmonad.
          , ((modMask .|. shiftMask, xK_q),
             io exitSuccess)

          -- Restart xmonad.
          , ((modMask, xK_q),
             restart "xmonad" True)
        ]
        ++ -- view workspace
        [ ((modMask, k), windows $ W.greedyView  i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        ]
        ++ -- send to workspace
        [ ((shiftMask .|. modMask, k), windows $ W.shift i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        ]
        ++ -- tabs
        [ ((modMask .|. controlMask, k), sendMessage $ pullGroup s)
        | (k, s) <- zip [xK_h, xK_l, xK_k, xK_j] [L, R, U, D]
        ]
        ++
        [ ((modMask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
        -- Group the current tabbed windows
        , ((modMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
        -- Toggle through tabes from the right
        , ((modMask, xK_Tab), onGroup W.focusDown')
        ]

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

mMouseBindings XConfig {XMonad.modMask = modMask} = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     \w -> focus w >> mouseMoveWindow w)

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       \w -> focus w >> windows W.swapMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       \w -> focus w >> mouseResizeWindow w)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

main = do
  xmproc <- spawnPipe "xmobar ~/.xmobarrc"
  -- xmproc <- spawnPipe "taffybar"
  xmonad $ docks
         $ withNavigation2DConfig mNav2DConf
         $ additionalNav2DKeys (xK_Up, xK_Left, xK_Down, xK_Right)
                               [
                                  (mod4Mask,               windowGo  )
                                , (mod4Mask .|. shiftMask, windowSwap)
                               ]
                               False
         $ ewmh
         $ defaults {
         logHook = dynamicLogWithPP xmobarPP {
                  ppCurrent = xmobarColor "#FFFFFF" "" . wrap "[" "]"
                , ppTitle = xmobarColor "#AAAAAA" "" . shorten 50
                , ppSep = "   "
                , ppOutput = hPutStrLn xmproc
         } >> updatePointer (0.75, 0.75) (0.75, 0.75)
      }

------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
    -- simple stuff
    terminal           = mTerminal,
    focusFollowsMouse  = True,
    borderWidth        = 0,
    modMask            = mod1Mask,
    workspaces         = mWorkspaces,
    normalBorderColor  = "#000000",
    focusedBorderColor = "#333333",

    -- key bindings
    keys               = mKeys,
    mouseBindings      = mMouseBindings,

    -- hooks, layouts
    layoutHook         = mLayout,
    -- handleEventHook    = E.fullscreenEventHook,
    handleEventHook    = fullscreenEventHook,
    manageHook         = manageDocks <+> mManageHook
}
