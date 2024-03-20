#include <array.au3>

Local $sBaseIP = '10.84.77.'
Local $aIPs[1]

For $x = 2 To 254
	$sIP = $sBaseIP & $x
	If Ping($sIP, 100) Then
		_ArrayAdd($aIPs, $sIP)
	EndIf
Next


;~ Local $sBaseIP = '192.168.20.'
;~ For $x = 2 To 254
;~ 	$sIP = $sBaseIP & $x
;~ 	If Ping($sIP, 100) Then
;~ 		_ArrayAdd($aIPs, $sIP)
;~ 	EndIf
;~ Next


ShellExecute('Notepad.exe')
WinWait('[Class:Notepad]')
ControlSend('[Class:Notepad]', '', '[CLASS:Edit; INSTANCE:1]', _ArrayToString($aIPs))
_ArrayToClip($aIPs, @TAB)

