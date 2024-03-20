#include <Array.au3>

Opt("WinTitleMatchMode", 1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

$sWinTitleImport = 'Import Routine'
$sWinTitleConf = 'Import Configuration'
$sWinTitleOptions = 'Online Options'

$sPath = "C:\Users\Triplex\Downloads\Exports\Rover33.L5X"

$sSearchText1 = 'Rover33'
WinKill('Performing Import')
For $x = 16 To 18
	If $x = 33 Then ContinueLoop
	$sIndex = StringFormat("%02i", $x)

	ConsoleWrite(@CRLF & '--->' & $sIndex)

	$sReplaceText1 = 'Rover' & $sIndex

	$sNewPath = StringReplace($sPath, $sSearchText1, $sReplaceText1)

	MouseClick('left', 140, 389, 1, 0)
	Send('{left}')
	Send('{space}')
	Sleep(100)
	Send('{down}')
	Send('{right}')
	Send('{up}')
	Send('{enter}')

	WinWait($sWinTitleImport)
	ConsoleWrite(@CRLF & '--->Debug1')

	ControlSetText($sWinTitleImport, '', '[CLASS:Edit; INSTANCE:1]', $sNewPath)
	ControlClick($sWinTitleImport, '', '[CLASS:Button; INSTANCE:2]')

	WinWait($sWinTitleConf)
	ConsoleWrite(@CRLF & '--->Debug2')

	ControlClick($sWinTitleConf, 'Find Within: Import Name, Final Name, Description,', '[CLASS:Button; INSTANCE:13]')

	WinWait($sWinTitleOptions, '', 2)
	ConsoleWrite(@CRLF & '--->Debug3')

	ControlClick($sWinTitleOptions, '', '[CLASS:Button; INSTANCE:6]')
	ControlClick($sWinTitleOptions, '', '[CLASS:Button; INSTANCE:1]')

	Sleep(5000)
	While WinExists('Performing Import')
		Sleep(100)
	WEnd
	Sleep(1000)
Next

MsgBox(0, '', "I'm done.")
