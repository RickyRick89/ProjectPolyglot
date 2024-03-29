#include <Array.au3>
#include <Excel.au3>

$sModulesFilePath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\My_Work\My_Drawings\Modules.xlsx"
$sPanelFilePath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\My_Work\My_Drawings\Motor And Instrument List Rev 0.xlsb.xlsx"

$sMFR = 'BUD INDUSTRIES'
$sPNSmallEncl = 'SNB-3733-SS'
;~ $sPNSmallPNL = 'SCE-10P8'
$sPNLargeEncl = 'SNB-3733-SS'
;~ $sPNLargePNL = 'SCE-12P10'

$sPanelDESC = 'ENCLOSURE SUB-PANEL'
$sEnclDESC = 'WALL MOUNT ENCLOSURE TYPE 4X'

Local $aPLCENCL[2][5] = [['1', '1', 'SCE-36EL3010LP', 'WALL MOUNT ENCLOSURE TYPE 4, 12', 'SAGINAW'], ['2', '1', 'SCE-36P30', 'ENCLOSURE SUB-PANEL', 'SAGINAW']]
Local $aRMTPNLENCL[3][5] = [['1', '1', 'SCE-30EL2412LP', 'WALL MOUNT ENCLOSURE TYPE 4, 12', 'SAGINAW'], ['2', '1', 'SCE-30P24', 'ENCLOSURE SUB-PANEL', 'SAGINAW'], ['3', '1', 'CS01112604 ', 'AIR CONDITIONER, 1000 BTU', 'THERMAL EDGE']]

$oModuleWorkbook = _Excel_BookAttach($sModulesFilePath)
If Not IsObj($oModuleWorkbook) Then
	$oExcel = _Excel_Open()
	$oModuleWorkbook = _Excel_BookOpen($oExcel, $sModulesFilePath)
Else
	$oExcel = $oModuleWorkbook.Application
EndIf

$aModuleDta = _Excel_RangeRead($oModuleWorkbook, 'Sheet1')


$oPanelWorkbook = _Excel_BookAttach($sPanelFilePath)
If Not IsObj($oPanelWorkbook) Then
	$oExcel = _Excel_Open()
	$oPanelWorkbook = _Excel_BookOpen($oExcel, $sPanelFilePath)
Else
	$oExcel = $oPanelWorkbook
EndIf

$aPanelData = _Excel_RangeRead($oPanelWorkbook, 'New Control Panel Connection')


;~ _ArrayDisplay($aModuleDta)
;~ _ArrayDisplay($aPanelData)

;~ For $iRow = 1 To 92
;~ 	$nWidth = 0
;~ 	$nHeight = 0
;~ 	For $iColumn = 13 To 20
;~ 		$sModuleName = $aPanelData[0][$iColumn]
;~ 		For $iRowMod = 1 To UBound($aModuleDta) - 1
;~ 			If $sModuleName = $aModuleDta[$iRowMod][0] Then
;~ 				$nWidth += ($aModuleDta[$iRowMod][6] * $aPanelData[$iRow][$iColumn])
;~ 				If $aModuleDta[$iRowMod][5] > $nHeight And $aPanelData[$iRow][$iColumn] > 0 Then $nHeight = $aModuleDta[$iRowMod][5]
;~ 				ExitLoop
;~ 			EndIf
;~ 		Next
;~ 	Next
;~ 	_Excel_RangeWrite($oPanelWorkbook, 'New Control Panel Connection', $nHeight, 'V' & $iRow + 1)
;~ 	_Excel_RangeWrite($oPanelWorkbook, 'New Control Panel Connection', $nWidth, 'W' & $iRow + 1)
;~ Next

$oExcel2 = _Excel_Open()
$oBOMWorkbook = _Excel_BookNew($oExcel2)

For $iRow = 1 To 76
	$iBOMRow = 0
	$sPanelName = $aPanelData[$iRow][0]
	$sSheetname = $sPanelName & '_ENCL'
	_Excel_SheetAdd($oBOMWorkbook, Default, False, 1, $sSheetname)

	If $aPanelData[$iRow][22] >= 4 Then
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 1, 'A2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 1, 'B2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sPNLargeEncl, 'C2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sEnclDESC, 'D2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sMFR, 'E2')

;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 2, 'A3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 1, 'B3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sPNLargePNL, 'C3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sPanelDESC, 'D3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sMFR, 'E3')
	ElseIf $aPanelData[$iRow][22] > 0 Then
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 1, 'A2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 1, 'B2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sPNSmallEncl, 'C2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sEnclDESC, 'D2')
		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sMFR, 'E2')

;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 2, 'A3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 1, 'B3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sPNSmallPNL, 'C3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sPanelDESC, 'D3')
;~ 		_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $sMFR, 'E3')
	Else
		If StringInStr($sPanelName, 'F') Then
			_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $aRMTPNLENCL, 'A2')
		Else
			_Excel_RangeWrite($oBOMWorkbook, $sSheetname, $aPLCENCL, 'A2')
		EndIf

	EndIf
	_Excel_RangeWrite($oBOMWorkbook, $sSheetname, '#', 'A1')
	_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 'QTY', 'B1')
	_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 'PART #', 'C1')
	_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 'DESCRIPTION', 'D1')
	_Excel_RangeWrite($oBOMWorkbook, $sSheetname, 'MANUFACTURER', 'E1')
Next

