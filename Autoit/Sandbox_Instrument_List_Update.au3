#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

$sMasterFile1 = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\My_Work\Instrument_Source.xlsx"
$sMasterFile2 = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\PIDs\CA Line-5 PID Instrument Tags.xlsx"

$oMasterWorkbook = _Excel_BookAttach($sMasterFile2)
If Not IsObj($oMasterWorkbook) Then
	$oExcel = _Excel_Open()
	$oMasterWorkbook = _Excel_BookOpen($oExcel, $sMasterFile2)
Else
	$oExcel = $oMasterWorkbook.Application
EndIf

$aOriginalSheet = _Excel_RangeRead($oMasterWorkbook)


$oMasterWorkbook = _Excel_BookAttach($sMasterFile1)
If Not IsObj($oMasterWorkbook) Then
	$oExcel = _Excel_Open()
	$oMasterWorkbook = _Excel_BookOpen($oExcel, $sMasterFile1)
Else
	$oExcel = $oMasterWorkbook.Application
EndIf

$aNewSheet = _Excel_RangeRead($oMasterWorkbook)

;~ _ArrayDisplay($aOriginalSheet)
;~ _ArrayDisplay($aNewSheet)

For $iRowOrig = 1 To UBound($aOriginalSheet) - 1

	$sOrignalTag = $aOriginalSheet[$iRowOrig][0] & '-' & $aOriginalSheet[$iRowOrig][1]
	$sOrignalNumber = Number($aOriginalSheet[$iRowOrig][1])

	For $iRowNew = 1 To UBound($aNewSheet) - 1
		If $sOrignalTag = $aNewSheet[$iRowNew][0] Then
			ExitLoop
		EndIf
		If $iRowNew = UBound($aNewSheet) - 1 Then
			_ArrayAdd($aNewSheet, $sOrignalTag)
;~ 			_ArrayDisplay($aNewSheet)

			_Excel_RangeWrite($oMasterWorkbook, Default, $sOrignalTag, 'A' & $iRowNew + 2)
			_Excel_RangeWrite($oMasterWorkbook, Default, $aOriginalSheet[$iRowOrig][0], 'B' & $iRowNew + 2)
			_Excel_RangeWrite($oMasterWorkbook, Default, $sOrignalNumber, 'C' & $iRowNew + 2)
			_Excel_RangeWrite($oMasterWorkbook, Default, $aOriginalSheet[$iRowOrig][1], 'D' & $iRowNew + 2)
			_Excel_RangeWrite($oMasterWorkbook, Default, $aOriginalSheet[$iRowOrig][3], 'Y' & $iRowNew + 2)
			_Excel_RangeWrite($oMasterWorkbook, Default, $aOriginalSheet[$iRowOrig][4], 'Z' & $iRowNew + 2)
			_Excel_RangeWrite($oMasterWorkbook, Default, $aOriginalSheet[$iRowOrig][5], 'AA' & $iRowNew + 2)
			_Excel_RangeWrite($oMasterWorkbook, Default, $aOriginalSheet[$iRowOrig][6], 'AB' & $iRowNew + 2)
		EndIf


	Next
Next
