#include <FileConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <Excel.au3>
#include <String.au3>


HotKeySet('{esc}', '_Exit')
Global $oWorkbook, $oExcel
$sWorkbookPath = "C:\Users\rgrov\Triplex Automation LLC\Triplex Automation - Shared\Clients\RJX_Automation\TimeReports\Richards_TimeCard_2023.xlsx"
$bSummarizeCurrentWeek = False

$iRate = 104
$sName = 'Richard Groves'

$bStart = 0

Local $aResults[1][16] = [['NAME', 'RATE', 'WEEK START', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY', 'WEEK END', 'HOURS', 'LABOR COST	', 'EXPENSES', 'TOTAL COST', 'PROJECT']]

$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheetList = _Excel_SheetList($oWorkbook)
_ArrayColDelete($aSheetList, 1)
;~ _ArrayDisplay($aSheetList)



$aSummary = _Excel_RangeRead($oWorkbook, 'Summary')
;~ _ArrayDisplay($aSummary)

$iStartRow = 3
For $iSummaryRow = 2 To UBound($aSummary) - 1
	$sSumInvoice = $aSummary[$iSummaryRow][16]

	If $sSumInvoice <> '' Then
		$iStartRow = $iSummaryRow + 2
	EndIf

Next

For $iSheet = 0 To UBound($aSheetList) - 1
	ConsoleWrite(@CRLF & '-->' & $aSheetList[$iSheet][0])
	If $aSheetList[$iSheet][0] = 'Jan' Then $bStart = 1

	If Not $bStart Then
		ContinueLoop
	EndIf
	$aSheet = _Excel_RangeRead($oWorkbook, $aSheetList[$iSheet][0])
;~ 	_ArrayDisplay($aSheet)

	For $iCol = 1 To 40 Step 7
		$sWeekStart = $aSheet[51][$iCol]
		If StringLen($sWeekStart) < 14 Then ExitLoop
		$sWeekStart = _StringInsert($sWeekStart, ':', 12)
		$sWeekStart = _StringInsert($sWeekStart, ':', 10)
		$sWeekStart = _StringInsert($sWeekStart, ' ', 8)
		$sWeekStart = _StringInsert($sWeekStart, '/', 6)
		$sWeekStart = _StringInsert($sWeekStart, '/', 4)
		$sWeekEnd = _DateAdd('d', 6, $sWeekStart)
		$iDateDiff = _DateDiff('D', $sWeekEnd, _NowCalc())
		If $iDateDiff < 0 And Not $bSummarizeCurrentWeek Then ContinueLoop
;~ 		MsgBox(0, '', $sWeekStart)
		For $iRow = 53 To 61
			$sProject = $aSheet[$iRow][0]

			$bSkip = False
			For $iSummaryRow = 2 To UBound($aSummary) - 1
				$sSumWeekStart = $aSummary[$iSummaryRow][2]
				$sSumProject = $aSummary[$iSummaryRow][15]
				$sSumInvoice = $aSummary[$iSummaryRow][16]

				If $sSumWeekStart = $aSheet[51][$iCol] And $sSumProject = $sProject And $sSumInvoice <> '' Then
					$bSkip = True
					ExitLoop
				EndIf

			Next
			If $bSkip Then ContinueLoop


			$iTotHours = 0
			Local $aTemp[1]
			For $iDays = 0 To 6
				_ArrayAdd($aTemp, $aSheet[$iRow][$iCol + $iDays])
				$iTotHours += $aSheet[$iRow][$iCol + $iDays]
			Next
			If $iTotHours = 0 Then ContinueLoop
			$iLaborCost = $iTotHours * $iRate

			_ArrayDelete($aTemp, 0)
			$sDays = _ArrayToString($aTemp)
			$iTotExp = _GetExpenses($sWeekStart, $sProject)
			$iTotCost = $iTotExp + $iLaborCost
			$sAddString = $sName & '|' & $iRate & '|' & $sWeekStart & '|' & $sDays & '|' & $sWeekEnd & '|' & $iTotHours & '|' & $iLaborCost & '|' & $iTotExp & '|' & $iTotCost & '|' & $sProject

			_ArrayAdd($aResults, $sAddString)


		Next
	Next


Next
;~ _ArrayDisplay($aResults)

_ArrayDelete($aResults, 0)
_Excel_RangeWrite($oWorkbook, 'Summary', $aResults, 'B' & $iStartRow)
_Excel_BookSave($oWorkbook)

FileCopy($sWorkbookPath, 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Clients\RJX_Automation\TimeReports\Archive\Richards_TimeCard_' & StringReplace(_NowCalcDate(), '/', '') & '.xlsx', $FC_OVERWRITE + $FC_CREATEPATH)
FileCopy($sWorkbookPath, 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Clients\RJX_Automation\TimeReports\Richards_TimeCard_' & @YEAR & '.xlsx', $FC_OVERWRITE + $FC_CREATEPATH)




_Exit()

Func _GetExpenses($sWeekStart, $sProject)
	$iTotExp = 0
	Local $aSheet = _Excel_RangeRead($oWorkbook, 'Expenses')
	$sWeekEnd = _DateAdd('d', 6, $sWeekStart)

;~ 	_ArrayDisplay($aSheet)
	For $iRow = 1 To UBound($aSheet) - 1
		$sExpenseProject = $aSheet[$iRow][4]
		$sExpense = $aSheet[$iRow][5]

		$sDate = $aSheet[$iRow][0]
		If StringLen($sDate) < 14 Then ExitLoop
		$sDate = _StringInsert($sDate, ':', 12)
		$sDate = _StringInsert($sDate, ':', 10)
		$sDate = _StringInsert($sDate, ' ', 8)
		$sDate = _StringInsert($sDate, '/', 6)
		$sDate = _StringInsert($sDate, '/', 4)

		$iDateDiff = _DateDiff('d', $sWeekStart, $sDate)


		If $iDateDiff < 7 And $iDateDiff >= 0 And $sExpenseProject = $sProject Then
			$iTotExp += $sExpense
		EndIf


	Next
	If $iTotExp > 0 Then
		ConsoleWrite(@CRLF & '>>>' & $sProject)
		ConsoleWrite(@CRLF & '>>' & $sWeekStart)
		ConsoleWrite(@CRLF & '>' & $iTotExp)
	EndIf

	Return ($iTotExp)

EndFunc   ;==>_GetExpenses

Func _Exit()
	Exit
EndFunc   ;==>_Exit
