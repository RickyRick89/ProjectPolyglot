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
		$vReturn = _InputCombo($aPLPSheets, $sMLSheet)
		$iPLPSheetIndex = _ArraySearch($aPLPSheets, $vReturn)
	EndIf
	$sPLPSheet = $aPLPSheets[$iPLPSheetIndex]
	$aMLValues = _Excel_RangeRead($oMLWorkbook, $sMLSheet)
	$aPLPValues = _Excel_RangeRead($oPLPWorkbook, $sPLPSheet)

	For $iMLCol = 0 To UBound($aMLValues, 2) - 1
		If $aMLValues[0][$iMLCol] <> '' And $aMLValues[1][$iMLCol] = 'Description' Then
			$sItem = $aMLValues[0][$iMLCol]
			ConsoleWrite(@CRLF & '~~~~>' & $sItem)
			For $iMLRow = 2 To UBound($aMLValues) - 1
				$sDesc = $aMLValues[$iMLRow][$iMLCol]
				$iValue = $aMLValues[$iMLRow][$iMLCol + 1]
				ConsoleWrite(@CRLF & '++>' & $sDesc & '++>' & $iValue)
				If $sDesc = '' Then ContinueLoop
				If $iValue = Null Then ExitLoop
				ConsoleWrite(@CRLF & '**>' & $sDesc)

				$iColor = $oMLWorkbook.Sheets($sMLSheet).Range(_Excel_ColumnToLetter($iMLCol + 3) & $iMLRow + 1).interior.color
				If $iColor <> 13561798 Then
					ClipPut($iColor)
					$oMLWorkbook.Sheets($sMLSheet).Activate()
					$oMLWorkbook.Sheets($sMLSheet).Range(_Excel_ColumnToLetter($iMLCol + 3) & $iMLRow + 1).Select()
					MsgBox(0, _Excel_ColumnToLetter($iMLCol + 3) & $iMLRow + 1, $oMLWorkbook.Sheets($sMLSheet).Range(_Excel_ColumnToLetter($iMLCol + 3) & $iMLRow + 1).interior.color)
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

