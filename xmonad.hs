import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.WorkspaceNames
import XMonad.Prompt
import System.IO

main = do
--    xmproc  <- spawnPipe "/usr/local/bin/xmobar"
    spawn "/usr/local/bin/xmobar"
    xmonad $ defaultConfig
        { manageHook  = manageDocks <+> manageHook defaultConfig
        , layoutHook  = avoidStruts $ layoutHook defaultConfig
        , logHook     = workspaceNamesPP xmobarPP >>= dynamicLogString >>= xmonadPropLog
--         , logHook     = dynamicLogWithPP xmobarPP
--             { ppOutput = hPutStrLn xmproc
--             , ppTitle = xmobarColor "green" "" . shorten 50
--             } -- >>= dynamicLogString >>= xmonadPropLog
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
