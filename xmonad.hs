import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.WorkspaceNames
import XMonad.Prompt
import System.IO

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
            ]



main = do
    spawn "/usr/local/bin/xmobar"
    xmonad $ defaultConfig
        { manageHook  = amManageHook
        , workspaces  = amWorkspaces
        , layoutHook  = avoidStruts $ layoutHook defaultConfig
        , logHook     = workspaceNamesPP xmobarPP >>= dynamicLogString >>= xmonadPropLog
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
