import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.WorkspaceCompare
import XMonad.Util.Loggers
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.SpawnOn
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
    [ "Term"
    , "Net"
    , "Chat"
    , "Dash"
    , "VM1"
    , "VM2"
    , "7"
    , "8"
    , "9"
    ]


amManageHook = composeAll . concat $
    [ [ className =? net   --> doShift "Net"  | net <- amNetShifts ]
    , [ className =? chat  --> doShift "Chat" | chat <- amChatShifts ]
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

amLayoutHook = onWorkspace "Term" amNoBorderFull  $
               onWorkspace "Dash" amSpiral  $
               onWorkspace "VM1" amNoBorderFull $
               onWorkspace "VM2" amNoBorderFull $
               amDefaultLayouts

amPPExtras = [ logCmd "mpc current"
             , date  "%A %B %d, %Y - %H:%M:%S"
             ]
        
amXmobarPP = workspaceNamesPP xmobarPP { ppUrgent = xmobarColor "#FF0000" ""
                      }

amXmobar = "/usr/local/bin/xmobar"

main = do
    spawn amXmobar
    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
        { --startupHook = do
            -- spawnOn "1:T1" "urxvtc -e tmux"
            -- spawnOn "2:T2" "urxvtc"
            -- spawnOn "2:T2" "urxvtc -e tmux"
            -- spawnOn "2:T2" "urxvtc"
            -- spawnOn "2:T2" "urxvtc"
            -- spawnOn "3:NT" "firefox"
            -- spawnOn "3:NT" "thunderbird"
            -- spawnOn "4:CH" "pidgin"
            -- spawnOn "4:CH" "urxvtc -e weechat"
        manageHook  = amManageHook
        , workspaces  = amWorkspaces
        , layoutHook  = avoidStruts $ amLayoutHook
        , logHook     = amXmobarPP >>= dynamicLogString >>= xmonadPropLog 
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
