#include <array.au3>
#include <Excel.au3>
#include <File.au3>

$sPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_Rover_HMI_Build\RoverZonesIndex.xlsx"

$sPath2 = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_Zone_Config\Rover_ConfigTool_CALD.xls"

$oWorkbook = _Excel_BookAttach($sPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aLocations = _Excel_RangeRead($oWorkbook, 'Locations_Updated')


$oConfigWorkbook = _Excel_BookAttach($sPath2)
If Not IsObj($oConfigWorkbook) Then
	$oConfigExcel = _Excel_Open()
	$oConfigWorkbook = _Excel_BookOpen($oConfigExcel, $sPath2)
Else
	$oConfigExcel = $oConfigWorkbook.Application
EndIf

$aConfig = _Excel_RangeRead($oConfigWorkbook, 'Zones')

;~ _ArrayDisplay($aLocations)
;~ _ArrayDisplay($aConfig)

For $iRowLoc = 1 To UBound($aLocations) - 1
	$iIndex = $aLocations[$iRowLoc][6]
	$iXCoord = $aLocations[$iRowLoc][4]
	$iYCoord = $aLocations[$iRowLoc][5]
	$iZCoord = $aLocations[$iRowLoc][3]
	$iType = $aLocations[$iRowLoc][1]
	$iDistU = $aLocations[$iRowLoc][9]
	$iDistD = $aLocations[$iRowLoc][11]
	$iDistL = $aLocations[$iRowLoc][12]
	$iDistR = $aLocations[$iRowLoc][10]
	$iBC = $aLocations[$iRowLoc][18]

	$iRowConfig = 10 + $iIndex

;~ 	MsgBox(0, '', $iIndex & @CRLF & $iBC)

	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iType, 'E' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iBC, 'F' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iXCoord, 'BF' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iYCoord, 'BG' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iZCoord, 'BH' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iDistU, 'BI' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iDistD, 'BJ' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iDistR, 'BK' & $iRowConfig)
	_Excel_RangeWrite($oConfigWorkbook, 'Zones', $iDistL, 'BL' & $iRowConfig)

Next
