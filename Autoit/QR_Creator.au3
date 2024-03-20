
Opt("WinTitleMatchMode", 1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

$sWinTitle = 'QR-Code Studio'
$sWinTitleSaveFile = 'Save Image File'

$sWinTitleOpen = 'Open'
$sWintClassPaint = '[Class:MSPaintApp]'
$sWinTitleSaveAs = 'Save As'


For $x = 100 To 100
	$sIndex = StringFormat("%04i", $x)
	$sFileName = $sIndex & '.png'
	$sPath = 'C:\Users\Triplex\Downloads\' & $sIndex & '.png'

	$sWinTitlePaint = $sFileName & ' - Paint'
	WinActivate($sWintClassPaint)

	ControlSend($sWintClassPaint, '', '', '^{o}')
	WinWait($sWinTitleOpen, '', 5)
	ControlSetText($sWinTitleOpen, '', '[CLASS:Edit; INSTANCE:1]', $sPath)
	ControlClick($sWinTitleOpen, '', '[CLASS:Button; INSTANCE:1]')

	While Not WinExists($sWinTitlePaint)
		Sleep(100)
	WEnd
	Sleep(100)

	MouseClickDrag('left', 164, 470, 164, 550, 0)
	Sleep(100)
	Send('!{h}{t}')
	MouseClick('left', 115, 520, 1, 0)
	Send($sIndex)
	Send('{enter}')
	Send('^{s}')
	Sleep(1000)

;~ 	WinActivate($sWinTitle)
;~ 	MouseClick('left', 204, 781)
;~ 	Send('+{home}')
;~ 	Sleep(100)
;~ 	Send($sIndex)
;~ 	Sleep(100)
;~ 	Send('^{e}')
;~ 	WinWait($sWinTitleSaveFile, '', 5)
;~ 	ControlSend($sWinTitleSaveFile, '', '', '!{t}')
;~ 	ControlSend($sWinTitleSaveFile, '', '[CLASS:ComboBox; INSTANCE:2]', '{P}')
;~ 	Sleep(100)
;~ 	ControlSetText($sWinTitleSaveFile, '', '[CLASS:Edit; INSTANCE:1]', $sPath)
;~ 	ControlClick($sWinTitleSaveFile,'','[CLASS:Button; INSTANCE:2]')
;~ 	Sleep(250)
;~ 	Exit
Next
