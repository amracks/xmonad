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
import qualified Data.Map as M
import System.IO
import Data.List

amWorkspaces = 
    [ "1:Term"
    , "2:Net"
    , "3:Chat"
    , "4:Doc1"
    , "5:Doc2"
    , "6:VM1"
    , "7:VM2"
    , "8:VM3"
    , "9:EX1"
    ]


amManageHook = composeAll . concat $
    [ [ className =? net   --> doShift "2:Net"  | net <- amNetShifts ]
    , [ className =? chat  --> doShift "3:Chat" | chat <- amChatShifts ]
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

amLayoutHook = tiled ||| Mirror tiled ||| noBorders Full ||| mosaic 2 [3,2]||| MosaicAlt M.empty ||| spiral (1/4) ||| Grid
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = 2/3
        delta = 3/100

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
