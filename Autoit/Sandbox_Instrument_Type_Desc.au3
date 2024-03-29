#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

$sKeyFile = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\My_Work\Instrument_Types.xlsx"
$sMasterFile = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\My_Work\Instrument_Source.xlsx"

$oKeyWorkbook = _Excel_BookAttach($sKeyFile)
If Not IsObj($oKeyWorkbook) Then
	$oExcel = _Excel_Open()
	$oKeyWorkbook = _Excel_BookOpen($oExcel, $sKeyFile)
Else
	$oExcel = $oKeyWorkbook.Application
EndIf

$aKey = _Excel_RangeRead($oKeyWorkbook)

$oMasterWorkbook = _Excel_BookAttach($sMasterFile)
If Not IsObj($oMasterWorkbook) Then
	$oExcel = _Excel_Open()
	$oMasterWorkbook = _Excel_BookOpen($oExcel, $sMasterFile)
Else
	$oExcel = $oMasterWorkbook.Application
EndIf

$aOriginalSheet = _Excel_RangeRead($oMasterWorkbook)


;~ _ArrayDisplay($aOriginalSheet)

For $iRowOrig = 1 To UBound($aOriginalSheet) - 1
	$sTypeCode = $aOriginalSheet[$iRowOrig][1]
	$sExistingDesc = $aOriginalSheet[$iRowOrig][_Excel_ColumnToNumber('J') - 1]

	If $sExistingDesc <> '' Then ContinueLoop

	$sTypeDesc = ''

	$aLetter = StringSplit($sTypeCode, '')
	For $iIndex = 1 To $aLetter[0]
		For $iRowKey = 1 To UBound($aKey) - 1
			If $aKey[$iRowKey][0] = $aLetter[$iIndex] Then
				If $iIndex = 1 Then
					$sTypeDesc &= $aKey[$iRowKey][1]
				Else
					For $iColumn = 3 To 5
						If $aKey[$iRowKey][$iColumn] <> '' Then
							$sTypeDesc &= ' ' & $aKey[$iRowKey][$iColumn]
							ExitLoop
						EndIf
					Next
				EndIf
				ExitLoop

			EndIf
		Next
	Next

	_Excel_RangeWrite($oMasterWorkbook, Default, $sTypeDesc, 'J' & $iRowOrig + 1)

Next
