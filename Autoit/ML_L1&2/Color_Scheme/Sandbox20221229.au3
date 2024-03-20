#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


$sML2WorkbookPath = "Y:\My_Scripts\ML_L1&2\Color_Scheme\NewColors\ML_Colors2.xlsx"

$oML2Workbook = _Excel_BookAttach($sML2WorkbookPath)
If Not IsObj($oML2Workbook) Then
	$oExcel = _Excel_Open()
	$oML2Workbook = _Excel_BookOpen($oExcel, $sML2WorkbookPath)
Else
	$oExcel = $oML2Workbook.Application
EndIf

$aML2Sheets2D = _Excel_SheetList($oML2Workbook)


$sMLWorkbookPath = "Y:\My_Scripts\ML_L1&2\Color_Scheme\NewColors\ML_Colors.xlsx"

$oMLWorkbook = _Excel_BookAttach($sMLWorkbookPath)
If Not IsObj($oMLWorkbook) Then
	$oExcel = _Excel_Open()
	$oMLWorkbook = _Excel_BookOpen($oExcel, $sMLWorkbookPath)
Else
	$oExcel = $oMLWorkbook.Application
EndIf

$aMLSheets2D = _Excel_SheetList($oMLWorkbook)

Local $aMLSheets[UBound($aMLSheets2D)], $aML2Sheets[UBound($aML2Sheets2D)]

For $x = 0 To UBound($aMLSheets2D) - 1
	$aMLSheets[$x] = $aMLSheets2D[$x][0]
Next
For $x = 0 To UBound($aML2Sheets2D) - 1
	$aML2Sheets[$x] = $aML2Sheets2D[$x][0]
Next


For $sML2Sheet In $aML2Sheets
	ConsoleWrite(@CRLF & '---->' & $sML2Sheet)
	$iMLSheetIndex = _ArraySearch($aMLSheets, $sML2Sheet)
	If $iMLSheetIndex < 0 Then
		MsgBox(0, '', $sML2Sheet & ' - Not Found')
		$vReturn = _InputCombo($aMLSheets, $sML2Sheet)
		$iMLSheetIndex = _ArraySearch($aMLSheets, $vReturn)
	EndIf
	$sMLSheet = $aMLSheets[$iMLSheetIndex]
	$aML2Values = _Excel_RangeRead($oML2Workbook, $sML2Sheet)
	$aMLValues = _Excel_RangeRead($oMLWorkbook, $sMLSheet)

	For $iML2Col = 0 To UBound($aML2Values, 2) - 2
		If $aML2Values[0][$iML2Col] <> '' And $aML2Values[1][$iML2Col] = 'Description' Then
			$sItem = $aML2Values[0][$iML2Col]
			$sExpression = $aML2Values[0][$iML2Col + 1]
			ConsoleWrite(@CRLF & '~~~~>' & $sItem)
			For $iMLCol = 0 To UBound($aMLValues, 2) - 2

				If $aMLValues[0][$iMLCol] = $sItem And $aMLValues[0][$iMLCol + 1] = $sExpression Then
					$vResponse = $IDYES
				ElseIf $aMLValues[0][$iMLCol + 1] = $sExpression Then

					$iColIndex = _ArraySearch($aMLValues, $sItem, 0, 0, 0, 0, 1, 0, True)
					If $iColIndex >= 0 Then
						$vResponse = $IDNO
					Else

						For $iML2Row = 2 To UBound($aML2Values) - 1
							$iValue = String($aML2Values[$iML2Row][$iML2Col + 1])
							If StringLen($iValue) = 0 Then ExitLoop
							$iML2Rows = $iML2Row
						Next
						For $iMLRow = 2 To UBound($aMLValues) - 1
							$iValue = String($aMLValues[$iMLRow][$iMLCol + 1])
							If StringLen($iValue) = 0 Then ExitLoop
							$iMLRows = $iMLRow
						Next

						If $iMLRows = $iML2Rows Then
							$vResponse = $IDYES
						Else
							$vResponse = $IDNO
						EndIf

					EndIf
				Else
					$vResponse = $IDNO
				EndIf

				If $vResponse = $IDYES Then
					ConsoleWrite(@CRLF & '-->' & $aMLValues[0][$iMLCol] & ' = ' & $sItem)
					For $iML2Row = 2 To UBound($aML2Values) - 1
						$sDesc = String($aML2Values[$iML2Row][$iML2Col])
						$iValue = String($aML2Values[$iML2Row][$iML2Col + 1])
						ConsoleWrite(@CRLF & '++>' & $sDesc & '++>' & $iValue)
;~ 						If $sDesc = '' Then ContinueLoop
						If StringLen($iValue) = 0 Then ExitLoop
						ConsoleWrite(@CRLF & '**>' & $sDesc)

						For $iMLRow = 2 To UBound($aMLValues) - 1
							$sMLDesc = $aMLValues[$iMLRow][$iMLCol]
							$iMLValue = $aMLValues[$iMLRow][$iMLCol + 1]
							If $iMLValue = $iValue Then
								_Excel_RangeWrite($oML2Workbook, $sML2Sheet, $sMLDesc, _Excel_ColumnToLetter($iML2Col + 1) & ($iML2Row + 1))
								$sCopyText = ''
								For $iCopyOffset = 2 To 16
									$sCopyText &= $aMLValues[$iMLRow][$iMLCol + $iCopyOffset] & '|'
								Next
								$sCopyText = StringTrimRight($sCopyText, 1)
								$aCopyText = StringSplit($sCopyText, '|', $STR_NOCOUNT)
								_ArrayTranspose($aCopyText)
								_Excel_RangeWrite($oML2Workbook, $sML2Sheet, $aCopyText, _Excel_ColumnToLetter($iML2Col + 3) & ($iML2Row + 1))
;~ 								_ArrayDisplay($aCopyText)
;~ 								_ArrayDisplay($aML2Values)
								For $iInc = 0 To UBound($aCopyText, 2) - 1
									$oML2Workbook.Sheets($sML2Sheet).Range(_Excel_ColumnToLetter($iML2Col + 3 + $iInc) & ($iML2Row + 1)).Style = 'Good'
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

