#include <Array.au3>
#include <Excel.au3>

; Open the two spreadsheets with Excel UDF
Local $sFilePath1 = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\Ranier\22133-JRFML Project Rainier-Instruments List 12-15-23.xls"
Local $sFilePath2 = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\Ranier\22133-JRFML Project Rainier-Instrument List 2-7-24.xls"


$oWorkbook1 = _Excel_BookAttach($sFilePath1)
If Not IsObj($oWorkbook1) Then
	$oExcel1 = _Excel_Open()
	$oWorkbook1 = _Excel_BookOpen($oExcel1, $sFilePath1)
Else
	$oExcel1 = $oWorkbook1.Application
EndIf

$oWorkbook2 = _Excel_BookAttach($sFilePath2)
If Not IsObj($oWorkbook2) Then
	$oExcel2 = _Excel_Open()
	$oWorkbook2 = _Excel_BookOpen($oExcel2, $sFilePath2)
Else
	$oExcel2 = $oWorkbook2.Application
EndIf



; Write the headers to the first row of the new workbook
Local $aRowData[1][19] = [["New Tag", "Old Tag", "New Description", "Old Description", "New Connection Type", "Old Connection Type", "New Connection Size", "Old Connection Size", "New DWG Number", "Old DWG Number", "New Supplier", "Old Supplier", "New Comment", "Old Comment", "New PnPID", "Old PnPID", "PnPGuid", "New Device", "Deleted Device"]] ; Fill in the rest of your headers here

; Read the data into arrays
Local $aSheet1 = _Excel_RangeRead($oWorkbook1)
Local $aSheet2 = _Excel_RangeRead($oWorkbook2)

;~ _ArrayDisplay($aSheet1)
;~ _ArrayDisplay($aSheet2)

; Assuming PnPGuid is the last column in the range, i.e., column I
Local $iPnPGuidColumn = 8

; Function to find the row index for a given PnPGuid
Func _FindPnPGuidIndex($aArray, $sPnPGuid)
	For $i = 0 To UBound($aArray) - 1
		If $aArray[$i][$iPnPGuidColumn] == $sPnPGuid Then Return $i
	Next
	Return -1
EndFunc   ;==>_FindPnPGuidIndex

; Compare the PnPGuids and data
For $i = 1 To UBound($aSheet1) - 1
	Local $sPnPGuid = $aSheet1[$i][$iPnPGuidColumn]
	Local $iIndexInSheet2 = _FindPnPGuidIndex($aSheet2, $sPnPGuid)

	$iArrayIndex = _ArraySearch($aRowData, $sPnPGuid, 1, 0, 0, 0, 1, 16)
	If $iArrayIndex < 0 Then
		Local $aTemp[1][19]
		$aTemp[0][16] = $sPnPGuid
		_ArrayConcatenate($aRowData, $aTemp)
	Else
		MsgBox(0, $sPnPGuid, 'Duplicate Found')
	EndIf

	If $iIndexInSheet2 == -1 Then
		ConsoleWrite("PnPGuid deleted: " & $sPnPGuid & @CRLF)
		$iArrayIndex = _ArraySearch($aRowData, $sPnPGuid, 1, 0, 1, 2, 1, 16)
		For $j = 0 To UBound($aSheet1, $UBOUND_COLUMNS) - 2
			$aRowData[$iArrayIndex][($j * 2) + 1] = $aSheet1[$i][$j]
		Next
		$aRowData[$iArrayIndex][16] = $sPnPGuid
		$aRowData[$iArrayIndex][18] = 'x'
	Else
		For $j = 0 To UBound($aSheet1, $UBOUND_COLUMNS) - 1
			If $aSheet1[$i][$j] <> $aSheet2[$iIndexInSheet2][$j] Then
				ConsoleWrite("Change detected for PnPGuid " & $sPnPGuid & " in column " & $j & @CRLF)

				$iArrayIndex = _ArraySearch($aRowData, $sPnPGuid, 1, 0, 1, 2, 1, 16)
				$aRowData[$iArrayIndex][($j * 2)] = $aSheet2[$iIndexInSheet2][$j]
				$aRowData[$iArrayIndex][($j * 2) + 1] = $aSheet1[$i][$j]

			EndIf
		Next
	EndIf
Next

For $i = 0 To UBound($aSheet2) - 1
	Local $sPnPGuid = $aSheet2[$i][$iPnPGuidColumn]
	If _FindPnPGuidIndex($aSheet1, $sPnPGuid) == -1 Then
		ConsoleWrite("New PnPGuid: " & $sPnPGuid & @CRLF)

		Local $aTemp[1][19]

		For $j = 0 To UBound($aSheet1, $UBOUND_COLUMNS) - 1
			$aTemp[0][($j * 2)] = $aSheet2[$i][$j]
		Next
		$iArrayIndex = _ArrayConcatenate($aRowData, $aTemp) - 1

		$aRowData[$iArrayIndex][16] = $sPnPGuid
		$aRowData[$iArrayIndex][17] = 'x'

	EndIf
Next

; Close the workbooks and Excel instances
_Excel_BookClose($oWorkbook1)
_Excel_BookClose($oWorkbook2)

$oNewWorkbook = _Excel_BookNew($oExcel1)
_Excel_RangeWrite($oNewWorkbook, Default, $aRowData, "A1")


_Excel_Close($oExcel2)
