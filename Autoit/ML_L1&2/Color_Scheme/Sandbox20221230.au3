#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


$sPLP2WorkbookPath = "Y:\My_Scripts\ML_L1&2\Color_Scheme\Exports\PLP_Colors2.xlsx"

$oPLP2Workbook = _Excel_BookAttach($sPLP2WorkbookPath)
If Not IsObj($oPLP2Workbook) Then
	$oExcel = _Excel_Open()
	$oPLP2Workbook = _Excel_BookOpen($oExcel, $sPLP2WorkbookPath)
Else
	$oExcel = $oPLP2Workbook.Application
EndIf

$aPLP2Sheets2D = _Excel_SheetList($oPLP2Workbook)


$sPLPWorkbookPath = "Y:\My_Scripts\ML_L1&2\Color_Scheme\Exports\PLP_Colors.xlsx"

$oPLPWorkbook = _Excel_BookAttach($sPLPWorkbookPath)
If Not IsObj($oPLPWorkbook) Then
	$oExcel = _Excel_Open()
	$oPLPWorkbook = _Excel_BookOpen($oExcel, $sPLPWorkbookPath)
Else
	$oExcel = $oPLPWorkbook.Application
EndIf

$aPLPSheets2D = _Excel_SheetList($oPLPWorkbook)

Local $aPLPSheets[UBound($aPLPSheets2D)], $aPLP2Sheets[UBound($aPLP2Sheets2D)]

For $x = 0 To UBound($aPLPSheets2D) - 1
	$aPLPSheets[$x] = $aPLPSheets2D[$x][0]
Next
For $x = 0 To UBound($aPLP2Sheets2D) - 1
	$aPLP2Sheets[$x] = $aPLP2Sheets2D[$x][0]
Next


For $sPLP2Sheet In $aPLP2Sheets
	ConsoleWrite(@CRLF & '---->' & $sPLP2Sheet)
	$iPLPSheetIndex = _ArraySearch($aPLPSheets, $sPLP2Sheet)
	If $iPLPSheetIndex < 0 Then
		MsgBox(0, '', $sPLP2Sheet & ' - Not Found')
		$vReturn = _InputCombo($aPLPSheets, $sPLP2Sheet)
		$iPLPSheetIndex = _ArraySearch($aPLPSheets, $vReturn)
	EndIf
	$sPLPSheet = $aPLPSheets[$iPLPSheetIndex]
	$aPLP2Values = _Excel_RangeRead($oPLP2Workbook, $sPLP2Sheet)
	$aPLPValues = _Excel_RangeRead($oPLPWorkbook, $sPLPSheet)

	For $iPLP2Col = 0 To UBound($aPLP2Values, 2) - 2
		If $aPLP2Values[0][$iPLP2Col] <> '' And $aPLP2Values[1][$iPLP2Col] = 'Description' Then
			$sItem = $aPLP2Values[0][$iPLP2Col]
			$sExpression = $aPLP2Values[0][$iPLP2Col + 1]
			ConsoleWrite(@CRLF & '~~~~>' & $sItem)
			For $iPLPCol = 0 To UBound($aPLPValues, 2) - 2

				If $aPLPValues[0][$iPLPCol] = $sItem And $aPLPValues[0][$iPLPCol + 1] = $sExpression Then
					$vResponse = $IDYES
				ElseIf $aPLPValues[0][$iPLPCol + 1] = $sExpression Then

					$iColIndex = _ArraySearch($aPLPValues, $sItem, 0, 0, 0, 0, 1, 0, True)
					If $iColIndex >= 0 Then
						$vResponse = $IDNO
					Else

						For $iPLP2Row = 2 To UBound($aPLP2Values) - 1
							$iValue = String($aPLP2Values[$iPLP2Row][$iPLP2Col + 1])
							If StringLen($iValue) = 0 Then ExitLoop
							$iPLP2Rows = $iPLP2Row
						Next
						For $iPLPRow = 2 To UBound($aPLPValues) - 1
							$iValue = String($aPLPValues[$iPLPRow][$iPLPCol + 1])
							If StringLen($iValue) = 0 Then ExitLoop
							$iPLPRows = $iPLPRow
						Next

						If $iPLPRows = $iPLP2Rows Then
							$vResponse = $IDYES
						Else
							$vResponse = $IDNO
						EndIf

					EndIf
				Else
					$vResponse = $IDNO
				EndIf

				If $vResponse = $IDYES Then
					ConsoleWrite(@CRLF & '-->' & $aPLPValues[0][$iPLPCol] & ' = ' & $sItem)
					For $iPLP2Row = 2 To UBound($aPLP2Values) - 1
						$sDesc = String($aPLP2Values[$iPLP2Row][$iPLP2Col])
						$iValue = String($aPLP2Values[$iPLP2Row][$iPLP2Col + 1])
						ConsoleWrite(@CRLF & '++>' & $sDesc & '++>' & $iValue)
;~ 						If $sDesc = '' Then ContinueLoop
						If StringLen($iValue) = 0 Then ExitLoop
						ConsoleWrite(@CRLF & '**>' & $sDesc)

						For $iPLPRow = 2 To UBound($aPLPValues) - 1
							$sPLPDesc = $aPLPValues[$iPLPRow][$iPLPCol]
							$iPLPValue = $aPLPValues[$iPLPRow][$iPLPCol + 1]
							If $iPLPValue = $iValue Then
								_Excel_RangeWrite($oPLP2Workbook, $sPLP2Sheet, $sPLPDesc, _Excel_ColumnToLetter($iPLP2Col + 1) & ($iPLP2Row + 1))
								$sCopyText = ''
								For $iCopyOffset = 2 To 16
									$sCopyText &= $aPLPValues[$iPLPRow][$iPLPCol + $iCopyOffset] & '|'
								Next
								$sCopyText = StringTrimRight($sCopyText, 1)
								$aCopyText = StringSplit($sCopyText, '|', $STR_NOCOUNT)
								_ArrayTranspose($aCopyText)
								_Excel_RangeWrite($oPLP2Workbook, $sPLP2Sheet, $aCopyText, _Excel_ColumnToLetter($iPLP2Col + 3) & ($iPLP2Row + 1))
;~ 								_ArrayDisplay($aCopyText)
;~ 								_ArrayDisplay($aPLP2Values)
								For $iInc = 0 To UBound($aCopyText, 2) - 1
									$oPLP2Workbook.Sheets($sPLP2Sheet).Range(_Excel_ColumnToLetter($iPLP2Col + 3 + $iInc) & ($iPLP2Row + 1)).Style = 'Good'
								Next
								ExitLoop

							EndIf
						Next
					Next
					ExitLoop
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

