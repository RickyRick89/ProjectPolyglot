#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')


$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\2023-02-08 GF L4 PID Instrumentation List - Provided by Others.xlsx"
$sOrderSheetName = 'GF L4 PID Instrumentation List'

$oOrderWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oOrderWorkbook) Then
	$oExcel = _Excel_Open()
	$oOrderWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oOrderWorkbook.Application
EndIf

$aOrderSheet = _Excel_RangeRead($oOrderWorkbook, $sOrderSheetName)


;~ _ArrayDisplay($aOrderSheet)
;~ Exit

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\Motor And Instrument List Rev 0.xlsx"
$sSheetName = 'Instrument List'

$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aMISheet = _Excel_RangeRead($oWorkbook, $sSheetName)



For $iRow = 1 To UBound($aOrderSheet) - 1
	$sID = $aOrderSheet[$iRow][0]
	$aTemp = StringSplit($sID, '-')
;~ 	_ArrayDisplay($aTemp)
	ConsoleWrite(@CRLF & '--->' & $sID)

	$iIndex = _ArraySearch($aMISheet, $sID, 0, 0, 0, 0, 1, 2)
	If $iIndex < 0 And $aTemp[2] = String(Number($aTemp[2])) Then

		$iIndex = _ArraySearch($aMISheet, $sID & 'A', 0, 0, 0, 0, 1, 2)
		If $iIndex >= 0 Then
			$oOrderWorkbook.Sheets($sOrderSheetName).Range('A' & $iRow + 1).Value = $sID & 'A'
		EndIf
	EndIf

	If $iIndex < 0 Then
		$oOrderWorkbook.Sheets($sOrderSheetName).Range('A' & $iRow + 1).Style = "Bad"
	Else
		If $aMISheet[$iIndex][10] = 'OEM' Or $aMISheet[$iIndex][10] = 'Others' Then
			$oOrderWorkbook.Sheets($sOrderSheetName).Range('A' & $iRow + 1).Style = "Bad"
			$oOrderWorkbook.Sheets($sOrderSheetName).Range('E' & $iRow + 1).Value = $aMISheet[$iIndex][10]
		Else
			$oOrderWorkbook.Sheets($sOrderSheetName).Range('A' & $iRow + 1).Style = "Good"
			$oWorkbook.Sheets($sSheetName).Range('C' & $iIndex + 1).Style = "Good"
		EndIf
	EndIf
Next





Func _Exit()
	Exit
EndFunc   ;==>_Exit
