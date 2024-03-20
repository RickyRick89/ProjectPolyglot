#include <Array.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


$sWinName = 'Logix Designer - Emulation in EMU_RoverSystemPLCTest_PLP.ACD'

$sErrorPane = '[CLASS:RICHEDIT50W; INSTANCE:2]'


WinActivate($sWinName)
ControlClick($sWinName,'',$sErrorPane)
Send('^{home}')

