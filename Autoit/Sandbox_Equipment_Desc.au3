#include <Sound.au3>
#include <Array.au3>
#include <Excel.au3>


$sPath1 = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\PIDs\CA Line-5 PID Equip Tags.xlsx"
$sPath2 = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Motor And Instrument List Rev 0.5.xlsx"


$oWorkbook = _Excel_BookAttach($sPath1)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sPath1)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aEquipment = _Excel_RangeRead($oWorkbook)

$oWorkbook = _Excel_BookAttach($sPath2)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sPath2)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aInstruments = _Excel_RangeRead($oWorkbook)


For $iRow = 1 To UBound($aInstruments) - 1
	$iID = Number($aInstruments[$iRow][4])
	$sInstDesc = $aInstruments[$iRow][6]
	If $sInstDesc <> '' Then ContinueLoop
	For $iRow2 = 1 To UBound($aEquipment) - 1
		$iEquipID = Number($aEquipment[$iRow2][2])
		$sEquipDesc = $aEquipment[$iRow2][3]
		$sEquipPID = $aEquipment[$iRow2][5]
		If $iEquipID = $iID Then
			_Excel_RangeWrite($oWorkbook, Default, $sEquipDesc, 'G' & $iRow + 1)
			_Excel_RangeWrite($oWorkbook, Default, $sEquipPID, 'T' & $iRow + 1)
			ExitLoop
		EndIf
	Next
Next
