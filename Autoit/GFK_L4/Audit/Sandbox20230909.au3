#include <File.au3>
#include <Array.au3>
#include <Excel.au3>

Local $sInputFile = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\Report\L4_PROCESS.csv"
$sNewFilePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\Report\L4_PROCESS_Cleaned.csv"
ConsoleWrite("Initializing..." & @CRLF)

Global $oWorkbook = _Excel_BookAttach($sInputFile)
If Not IsObj($oWorkbook) Then
	Global $oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sInputFile)
	ConsoleWrite("Opened workbook: " & $sInputFile & @CRLF)
Else
	Global $oExcel = $oWorkbook.Application
	ConsoleWrite("Workbook already attached: " & $sInputFile & @CRLF)
EndIf

Global $aConfigSheet = _Excel_RangeRead($oWorkbook)
ConsoleWrite("Read data from workbook." & @CRLF)

_Clean()

_FileCreate($sNewFilePath)

$oExcel = _Excel_Open()
$oWorkbook = _Excel_BookNew($oExcel)
_Excel_BookSaveAs($oWorkbook, $sNewFilePath, $xlCSV)

_Excel_RangeWrite($oWorkbook,Default, $aConfigSheet)
_Excel_BookSave($oWorkbook)
_Excel_BookClose($oWorkbook)

Func _Clean()
	ConsoleWrite("Cleaning data..." & @CRLF)
	For $iRow = UBound($aConfigSheet) - 1 To 1 Step -1
		$aTemp = StringSplit($aConfigSheet[$iRow][0], '.')
		$sBase = $aTemp[1]
		$sDesc = $aConfigSheet[$iRow][1]
		$sLogic = $aConfigSheet[$iRow][2]
		If $sDesc = '' And $sLogic = '' Then
			ConsoleWrite($aConfigSheet[$iRow][0] & @CRLF)
			$iLastRow = $iRow
			For $iSearchRow = $iRow To 1 Step -1
				$aTemp = StringSplit($aConfigSheet[$iSearchRow][0], '.')
				$sSearchBase = $aTemp[1]
				$sSearchDesc = $aConfigSheet[$iSearchRow][1]
				$sSearchLogic = $aConfigSheet[$iSearchRow][2]

				If $sSearchBase <> $sBase Then
					$iLastRow = $iSearchRow + 2
					ExitLoop
				EndIf

				If $sSearchDesc <> '' Or $sSearchLogic <> '' Then
					$iLastRow = $iSearchRow + 1
					ExitLoop
				EndIf
			Next
			For $iDelRow = $iRow To $iLastRow Step -1
				_ArrayDelete($aConfigSheet, $iDelRow)
				$iRow = $iDelRow
				ConsoleWrite("Deleted row: " & $iDelRow & @CRLF)
			Next
		EndIf
	Next
	ConsoleWrite("Data cleaning completed." & @CRLF)
EndFunc   ;==>_Clean
