#include <GUIConstantsEx.au3>
#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


$sPLPWorkbookPath = "Y:\My_Scripts\ML_L1&2\Color_Scheme\Exports\PLP_Colors.xlsx"

$oPLPWorkbook = _Excel_BookAttach($sPLPWorkbookPath)
If Not IsObj($oPLPWorkbook) Then
	$oExcel = _Excel_Open()
	$oPLPWorkbook = _Excel_BookOpen($oExcel, $sPLPWorkbookPath)
Else
	$oExcel = $oPLPWorkbook.Application
EndIf

$aPLPSheets2D = _Excel_SheetList($oPLPWorkbook)


$sMLWorkbookPath = "Y:\My_Scripts\ML_L1&2\Color_Scheme\NewColors\ML_Colors.xlsx"

$oMLWorkbook = _Excel_BookAttach($sMLWorkbookPath)
If Not IsObj($oMLWorkbook) Then
	$oExcel = _Excel_Open()
	$oMLWorkbook = _Excel_BookOpen($oExcel, $sMLWorkbookPath)
Else
	$oExcel = $oMLWorkbook.Application
EndIf

$aMLSheets2D = _Excel_SheetList($oMLWorkbook)

Local $aMLSheets[UBound($aMLSheets2D)], $aPLPSheets[UBound($aPLPSheets2D)]

For $x = 0 To UBound($aMLSheets2D) - 1
	$aMLSheets[$x] = $aMLSheets2D[$x][0]
Next
For $x = 0 To UBound($aPLPSheets2D) - 1
	$aPLPSheets[$x] = $aPLPSheets2D[$x][0]
Next



For $sMLSheet In $aMLSheets
	ConsoleWrite(@CRLF & '---->' & $sMLSheet)
	$iPLPSheetIndex = _ArraySearch($aPLPSheets, $sMLSheet)
	If $iPLPSheetIndex < 0 Then
		MsgBox(0, '', $sMLSheet & ' - Not Found')
		Exit
	EndIf
	$sPLPSheet = $aPLPSheets[$iPLPSheetIndex]
	$aMLValues = _Excel_RangeRead($oMLWorkbook, $sMLSheet)
	$aPLPValues = _Excel_RangeRead($oPLPWorkbook, $sPLPSheet)

	For $iMLCol = 0 To UBound($aMLValues, 2) - 1
		If $aMLValues[0][$iMLCol] <> '' And $aMLValues[1][$iMLCol] = 'Description' Then
			$sItem = $aMLValues[0][$iMLCol]
			For $iPLPCol = 0 To UBound($aPLPValues, 2) - 1
				If $aPLPValues[0][$iPLPCol] = $sItem Then
					For $iMLRow = 2 To UBound($aMLValues) - 1
						$sDesc = $aMLValues[$iMLRow][$iMLCol]
						$iValue = $aMLValues[$iMLRow][$iMLCol + 1]
						If $sDesc = '' Then ContinueLoop
						If $iValue = '' Then ExitLoop

						Local $aPLPDescs[2]
						For $iPLPRow = 2 To UBound($aPLPValues) - 1
							$sPLPDesc = $aPLPValues[$iPLPRow][$iPLPCol]
							_ArrayAdd($aPLPDescs, $sPLPDesc)
							If $sDesc = $sPLPDesc Then
								$sCopyText = ''
								For $iCopyOffset = 2 To 16
									$sCopyText &= $aPLPValues[$iPLPRow][$iPLPCol + $iCopyOffset] & '|'
								Next
								$sCopyText = StringTrimRight($sCopyText, 1)
								$aCopyText = StringSplit($sCopyText, '|', $STR_NOCOUNT)
								_ArrayTranspose($aCopyText)
								_Excel_RangeWrite($oMLWorkbook, $sMLSheet, $aCopyText, _Excel_ColumnToLetter($iMLCol + 3) & ($iMLRow + 1))
								ExitLoop
							EndIf

							If $iPLPRow = UBound($aPLPValues) - 1 Then
								$vReturn = _InputCombo($aPLPDescs, $sDesc)
								$iArrayIndex = _ArraySearch($aPLPDescs, $vReturn)
								For $iPLPRow = 2 To UBound($aPLPValues) - 1
									$sPLPDesc = $aPLPValues[$iPLPRow][$iPLPCol]
									If $aPLPDescs[$iArrayIndex] = $sPLPDesc Then
										$sCopyText = ''
										For $iCopyOffset = 2 To 16
											$sCopyText &= $aPLPValues[$iPLPRow][$iPLPCol + $iCopyOffset] & '|'
										Next
										$sCopyText = StringTrimRight($sCopyText, 1)
										$aCopyText = StringSplit($sCopyText, '|', $STR_NOCOUNT)
										_ArrayTranspose($aCopyText)
										_Excel_RangeWrite($oMLWorkbook, $sMLSheet, $aCopyText, _Excel_ColumnToLetter($iMLCol + 3) & ($iMLRow + 1))
										ExitLoop
									EndIf
								Next
							EndIf
						Next
					Next
				EndIf
			Next
		EndIf
	Next

Next

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

Func _Exit()
	Exit
EndFunc   ;==>_Exit

