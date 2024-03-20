#include <array.au3>
#include <Excel.au3>
#include <File.au3>

$sPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Locations.xlsx"

$sPath2 = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Zone_Config\Rover_ConfigTool_PLP.xls"

$oWorkbook = _Excel_BookAttach($sPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aLocations = _Excel_RangeRead($oWorkbook, 'New_Table')


$oConfigWorkbook = _Excel_BookAttach($sPath2)
If Not IsObj($oConfigWorkbook) Then
	$oConfigExcel = _Excel_Open()
	$oConfigWorkbook = _Excel_BookOpen($oConfigExcel, $sPath2)
Else
	$oConfigExcel = $oConfigWorkbook.Application
EndIf

$aConfig = _Excel_RangeRead($oConfigWorkbook, 'Zones')

_ArrayDisplay($aLocations)
_ArrayDisplay($aConfig)
Exit

For $iRowLoc = 1 To UBound($aLocations) - 1
	$iDirections = 0
	$sDirection = ''

Next
