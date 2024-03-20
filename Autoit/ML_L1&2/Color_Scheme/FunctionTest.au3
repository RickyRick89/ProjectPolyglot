#include <GUIConstantsEx.au3>
#include <Excel.au3>
#include <Array.au3>
#include <File.au3>


Local $aPLPDescs[3]

$aPLPDescs[0] = "This"
$aPLPDescs[1] = "Is"
$aPLPDescs[2] = "Me"

$vReturn = _InputCombo($aPLPDescs, 'Test')
MsgBox(0, '', $vReturn)


Func _InputCombo($aOptions, $sTitle)
	$sOptions = _ArrayToString($aOptions)
	GUICreate($sTitle)
	$_Combo = GUICtrlCreateCombo($aOptions[0], 10, 10)
	_ArrayDelete($aOptions, 0)
	GUICtrlSetData(-1, $sOptions)
	$_OK = GUICtrlCreateButton('OK', 10, 50)
	GUISetState()
	$_ReadOld = ''

	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Or $msg = $_OK Then ExitLoop
		$_Read = GUICtrlRead($_Combo)
		If $_Read <> $_ReadOld Then
			ConsoleWrite("-->-- $_Read : " & $_Read & @CRLF)
			$_ReadOld = $_Read
		EndIf
	WEnd
	GUIDelete()
	Return ($_Read)
EndFunc   ;==>_InputCombo
