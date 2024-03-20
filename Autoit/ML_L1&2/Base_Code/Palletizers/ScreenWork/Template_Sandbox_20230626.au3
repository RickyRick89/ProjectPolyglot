#include <File.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sFilePath = "W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\PopupValve.xml"

$sText = FileRead($sFilePath)

$iTop = 10
;~ $iTop = _GetSmallestValue($sText, ' top="')
ConsoleWrite('-->Top = ' & $iTop & @CRLF)
$sText = StringReplace($sText, ' top="' & $iTop & '"', ' top="[TOP]"')
For $iInc = -20 To 200
	ConsoleWrite($iInc & '/' & 200 & @CRLF)
	$sText = StringReplace($sText, ' top="' & $iTop + $iInc & '"', ' top="[TOP+' & $iInc & ']"')
Next

$iLeft = 35
;~ $iLeft = _GetSmallestValue($sText, ' left="')
ConsoleWrite('-->Left = ' & $iLeft & @CRLF)
$sText = StringReplace($sText, ' left="' & $iLeft & '"', ' left="[LEFT]"')
For $iInc = -20 To 200
	ConsoleWrite($iInc & '/' & 200 & @CRLF)
	$sText = StringReplace($sText, ' left="' & $iLeft + $iInc & '"', ' left="[LEFT+' & $iInc & ']"')
Next

FileDelete($sFilePath)
FileWrite($sFilePath, $sText)

Func _GetSmallestValue($sText, $sSearch)
	$iLowestValue = 100000000000000000000000000000000000000000000000
	$iStart = 1
	$iOldStart = 0
	While 1
		$iFoundValue = _GetValue($sText, $sSearch, $iStart)
		If $iFoundValue <> '' And Number($iFoundValue) < $iLowestValue Then
			$iLowestValue = Number($iFoundValue)
		EndIf


		If $iStart < $iOldStart Then ExitLoop
		$iOldStart = $iStart
	WEnd
	Return ($iLowestValue)
EndFunc   ;==>_GetSmallestValue

Func _GetValue($sText, $sSearch, ByRef $iStart)
	ConsoleWrite('_GetValue(Text, ' & $sSearch & ', ' & $iStart & ')' & @CRLF)
	$iBeginning = StringInStr($sText, $sSearch, 0, 1, $iStart) + StringLen($sSearch)
	$iEnd = StringInStr($sText, '"', 0, 1, $iBeginning)

	If $iEnd < $iStart Then

		$sValue = ''
	Else
		$sValue = StringMid($sText, $iBeginning, $iEnd - $iBeginning)
	EndIf
	$iStart = $iEnd

	ConsoleWrite('->New Start = ' & $iStart & @CRLF)
	ConsoleWrite('->Value = ' & $sValue & @CRLF)
	Return ($sValue)
EndFunc   ;==>_GetValue


Func _Exit()
	Exit
EndFunc   ;==>_Exit
