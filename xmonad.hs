import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.WorkspaceNames
import XMonad.Hooks.UrgencyHook
import XMonad.Prompt
import XMonad.Layout.NoBorders
import XMonad.Layout.MosaicAlt
import XMonad.Layout.Mosaic
import XMonad.Layout.Spiral
import XMonad.Layout.Grid
import XMonad.Layout.Combo
import XMonad.Layout.PerWorkspace
import qualified Data.Map as M
import System.IO
import Data.List

amWorkspaces = 
    [ "1:T1"
    , "2:T2"
    , "3:NT"
    , "4:CH"
    , "5:V1"
    , "6:V2"
    , "7:D1"
    , "8:D2"
    , "9:E1"
    ]


amManageHook = composeAll . concat $
    [ [ className =? net   --> doShift "3:NT"  | net <- amNetShifts ]
    , [ className =? chat  --> doShift "4:CH" | chat <- amChatShifts ]
    , [ title =? "Minecraft 1.7.4" --> doFloat ]
    , [ ( className =? "Firefox" <&&> resource =? "Dialog") --> doFloat ]
    , [ className =? fc    --> doFloat | fc <- amFloatClass ]
    , [ manageDocks ]
    ]
    where
        amNetShifts = 
            [ "Firefox"
            , "Thunderbird"
            ]
        amChatShifts = [ "Pidgin" ]
        amFloatClass = 
            [ "Wine"
            , "MPlayer"
            , "net-minecraft-bootstrap-Bootstrap"
            , "xv"
            , "XVroot"
            ]

amNoBorderFull = noBorders Full
amSpiral       = spiral (1/3)

amDefaultLayouts = tiled ||| Mirror tiled ||| noBorders Full  ||| spiral (1/4) ||| Grid
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = 2/3
        delta = 3/100

amLayoutHook = onWorkspace "1:T1" amNoBorderFull  $
               onWorkspace "2:T2" amSpiral  $
               onWorkspace "5:V1" amNoBorderFull $
               onWorkspace "6:V2" amNoBorderFull $
               amDefaultLayouts

main = do
    spawn "/usr/local/bin/xmobar"
    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
        { manageHook  = amManageHook
        , workspaces  = amWorkspaces
        , layoutHook  = avoidStruts $ amLayoutHook
        , logHook     = workspaceNamesPP xmobarPP 
            { ppUrgent = xmobarColor "#FF0000" ""
            } >>= dynamicLogString >>= xmonadPropLog 
        , borderWidth = 1
        , terminal    = "urxvtc" } `additionalKeys`
        [ ((mod4Mask    ,xK_l), spawn "xlock") 
        , ((mod4Mask    ,xK_n), spawn "mpc next")
        , ((mod4Mask .|. shiftMask  ,xK_n), spawn "mpc prev")
        , ((mod4Mask    ,xK_j), spawn "mpc volume -7")
        , ((mod4Mask    ,xK_k), spawn "mpc volume +7")
        , ((mod4Mask    ,xK_p), spawn "mpc toggle")
        , ((mod4Mask    ,xK_r), renameWorkspace defaultXPConfig)
        ]
