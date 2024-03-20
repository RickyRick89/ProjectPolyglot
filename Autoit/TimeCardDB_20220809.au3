#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include "Access.au3"
#include <Excel.au3>
#include <Date.au3>
#include <String.au3>

; #CURRENT# =====================================================================================================================
; New in Rev 2.1
; _AccessErrCode()
; _AccessErrMsg()
;_AccessSelectQuery
;_AccessActionQuery
;_AccessRecordMove

; in Rev 2.0 and before -------------------
; _AccessOpen()
; _AccessClose()

; _AccessTableExists()
; _AccessTablesCount()
; _AccessTablesList()

; _AccessFieldExists
; _AccessFieldsList
; _AccessFieldsCount()

; _AccessRecordsCount()
; _AccessRecordList ()
; _AccessRecordAdd()
; _AccessRecordEdit()
; _AccessRecordDelete ()
; #CURRENT# =====================================================================================================================


$sDbFile = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\Richards_TnM.mdb"
$sWorkbookPath = "C:\Users\rgrov\Triplex Automation LLC\Triplex Automation - Shared\Clients\RJX_Automation\TimeReports\Richards_TimeCard_2022.xlsx"

$oTimeCard = _AccessOpen($sDbFile)
If $oTimeCard = 0 Then
	MsgBox(16, '', "Database File is not found " & @LF & $sDbFile)
	Exit
EndIf

$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheetList = _Excel_SheetList($oWorkbook)
;~ _ArrayDisplay($aSheetList)

For $iSheet = 0 To UBound($aSheetList) - 1
	$aSheet = _Excel_RangeRead($oWorkbook, $aSheetList[$iSheet][0])
;~ _ArrayDisplay($aSheet)




	For $iColumn = 1 To UBound($aSheet, 2) - 1
		If $aSheet[0][$iColumn] = '' Then
			ExitLoop
		EndIf
		For $iRow = 2 To UBound($aSheet) - 1
			If $aSheet[$iRow][0] = '' and $aSheet[$iRow][0] <> '0' Then
				ExitLoop
			EndIf


			$sDateRaw = $aSheet[1][$iColumn]
			$sDate = _StringInsert(_StringInsert(_StringInsert(_StringInsert(_StringInsert($sDateRaw, ':', 12), ':', 10), ' ', 8), '-', 6), '-', 4)


			$sDateTime = _DateAdd('n', ($iRow - 2) * 30, $sDate)

			If $aSheet[$iRow][$iColumn] <> '' Then
				Local $aInsert[2][2] = [['DateTime', $sDateTime], ['Project', $aSheet[$iRow][$iColumn]]]
				ConsoleWrite(@CRLF & '###> ' & $sDateTime & ' - ' & $aSheet[$iRow][$iColumn])
				_AccessRecordAdd($oTimeCard, 'AJs_Time', $aInsert)
			EndIf

		Next
	Next
Next


_AccessClose($oTimeCard)
