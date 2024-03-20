#include <array.au3>
#include <Excel.au3>
#include <File.au3>

$sPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Locations.xlsx"
$sGridTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Grid_Template.xml")
$sRoverZoneTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Zone_Template.xml")
$sStandZoneTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Stand_Template.xml")
$sStandLabelTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Zone_Label_Template.xml")
$sVBATemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Button_VBA_Template.vb")
$sMapTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\hbf_rover_map_Template.xml")

$sRootPath = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\'
$sNewFileName = 'hbf_rover_map_10.xml'    ;<<<<<<<<---------Change
$iRowLL = 65				;<<<<<<<<---------Change
$iRowUL = 82				;<<<<<<<<---------Change
$iColumnLL = 1             ;<<<<<<<<---------Change
$iColumnUL = 35         ;<<<<<<<<---------Change
$iStandMax = 109
$iGridInc = 45

$sMapName = 'New_Map_Lvl2' ;<<<<<<<<---------Change


Global $sNewGrids, $sNewRoverZones, $sNewStandZones, $sNewStandLabels, $sNewVBA

$oWorkbook = _Excel_BookAttach($sPath)
If Not IsObj($oWorkbook) Then
	$oConfigExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oConfigExcel, $sPath)
Else
	$oConfigExcel = $oWorkbook.Application
EndIf

$aMap = _Excel_RangeRead($oWorkbook, $sMapName)
;~ _ArrayDisplay($aMap)
;~ Exit

If $iRowLL = 1 Then
	For $iColumnIndex = $iColumnLL To $iColumnUL
		$iColumn = $iColumnIndex
		$vValue = $aMap[1][$iColumnIndex]
		If $vValue = '' Then ContinueLoop
		If Not IsNumber($vValue) Then
			_StandZoneLabel(1, $iColumn, $vValue)
		EndIf
	Next
EndIf


For $iRowIndex = $iRowLL + 1 To $iRowUL + 1
	$iRow = $iRowIndex - 1
	If $iRowLL Then
		_Grid($iRowIndex, 0, $iRow)
	Else
		_Grid($iRow, 0, $iRow)
	EndIf
	For $iColumnIndex = $iColumnLL To $iColumnUL
		$iColumn = $iColumnIndex
		$vValue = $aMap[$iRowIndex][$iColumnIndex]

		_Grid(0, $iColumn, $iColumn)

		If $vValue = '' Then ContinueLoop
		If Not IsNumber($vValue) Then
			If $iRowLL Then
				_StandZoneLabel($iRowIndex, $iColumn, $vValue)
			Else
				_StandZoneLabel($iRow, $iColumn, $vValue)
			EndIf
		ElseIf $vValue > $iStandMax Then
			If $iRowLL Then
				_RoverZone($iRowIndex, $iColumn, $vValue)
			Else
				_RoverZone($iRow, $iColumn, $vValue)
			EndIf
			_VBA($vValue)
		Else
			If $iRowLL Then
				_StandZone($iRowIndex, $iColumn, $vValue)
			Else
				_StandZone($iRow, $iColumn, $vValue)
			EndIf
			_VBA($vValue)
		EndIf
	Next
Next

$sNewFileText = $sMapTemplate
$sNewFileText = StringReplace($sNewFileText, '[Graphics_Insert]', $sNewGrids & $sNewStandLabels & $sNewStandZones & $sNewRoverZones)
$sNewFileText = StringReplace($sNewFileText, '[VBA_Insert]', $sNewVBA)


_FileCreate($sRootPath & $sNewFileName)

FileWrite($sRootPath & $sNewFileName, $sNewFileText)





Func _Grid($iRow, $iColumn, $vVariable)
	$sTemp = $sGridTemplate
	If $iColumn > 0 Then
		$iLeft = ($iColumn * $iGridInc) - (($iColumnLL - 1) * $iGridInc)
	Else
		$iLeft = 0
		$sIndex = '0' & $vVariable
	EndIf
	If $iRow > 0 Then
		$iTop = ($iRow * $iGridInc) - (($iRowLL - 1) * $iGridInc)
	Else
		$iTop = 0
		$sIndex = $vVariable & '0'
	EndIf

	If StringInStr($sNewGrids, 'grpGrid' & $iColumn & $iRow) Then Return

	$sTemp = StringReplace($sTemp, '[GroupID]', 'grpGrid' & $sIndex)
	$sTemp = StringReplace($sTemp, '[Index]', $sIndex)
	$sTemp = StringReplace($sTemp, '[Label]', $vVariable)
	$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
	$sTemp = StringReplace($sTemp, '[Top]', $iTop)
	$sNewGrids &= @CRLF & $sTemp
EndFunc   ;==>_Grid

Func _RoverZone($iRow, $iColumn, $vVariable)
	$sTemp = $sRoverZoneTemplate
	$iLeft = ($iColumn * $iGridInc) - (($iColumnLL - 1) * $iGridInc)
	$iTop = ($iRow * $iGridInc) - (($iRowLL - 1) * $iGridInc)
	$iLeft2 = $iLeft + 6
	$iTop2 = $iTop + 5
	$iLeft3 = $iLeft + 11
	$iTop3 = $iTop + 15
	$iLeft4 = $iLeft + 6
	$iTop4 = $iTop + 30

	$sZone = StringFormat('%04d', $vVariable)

	$sTemp = StringReplace($sTemp, '[Index]', $vVariable)
	$sTemp = StringReplace($sTemp, '[Label]', $sZone)
	$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
	$sTemp = StringReplace($sTemp, '[Top]', $iTop)
	$sTemp = StringReplace($sTemp, '[Left2]', $iLeft2)
	$sTemp = StringReplace($sTemp, '[Top2]', $iTop2)
	$sTemp = StringReplace($sTemp, '[Left3]', $iLeft3)
	$sTemp = StringReplace($sTemp, '[Top3]', $iTop3)
	$sTemp = StringReplace($sTemp, '[Left4]', $iLeft4)
	$sTemp = StringReplace($sTemp, '[Top4]', $iTop4)
	$sNewRoverZones &= @CRLF & $sTemp

EndFunc   ;==>_RoverZone

Func _StandZone($iRow, $iColumn, $vVariable)
	$sTemp = $sStandZoneTemplate
	$iLeft = ($iColumn * $iGridInc) - (($iColumnLL - 1) * $iGridInc)
	$iTop = ($iRow * $iGridInc) - (($iRowLL - 1) * $iGridInc)
	$iLeft2 = $iLeft + 6
	$iTop2 = $iTop + 5
	$iLeft3 = $iLeft + 11
	$iTop3 = $iTop + 15
	$iLeft4 = $iLeft + 6
	$iTop4 = $iTop + 30

	$sZone = StringFormat('%03d', $vVariable)

	$sTemp = StringReplace($sTemp, '[Index]', $vVariable)
	$sTemp = StringReplace($sTemp, '[Label]', $sZone)
	$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
	$sTemp = StringReplace($sTemp, '[Top]', $iTop)
	$sTemp = StringReplace($sTemp, '[Left2]', $iLeft2)
	$sTemp = StringReplace($sTemp, '[Top2]', $iTop2)
	$sTemp = StringReplace($sTemp, '[Left3]', $iLeft3)
	$sTemp = StringReplace($sTemp, '[Top3]', $iTop3)
	$sTemp = StringReplace($sTemp, '[Left4]', $iLeft4)
	$sTemp = StringReplace($sTemp, '[Top4]', $iTop4)
	$sNewStandZones &= @CRLF & $sTemp

EndFunc   ;==>_StandZone

Func _StandZoneLabel($iRow, $iColumn, $vVariable)
	$sTemp = $sStandLabelTemplate
	$iLeft = ($iColumn * $iGridInc) - (($iColumnLL - 1) * $iGridInc)
	$iTop = ($iRow * $iGridInc) - (($iRowLL - 1) * $iGridInc)

	If $iColumn = 1 Then
		$iTop += 15
	ElseIf $iRow = 1 Then
		$iTop += 30
	EndIf


	$vName = StringReplace(StringReplace($vVariable, ' ', ''), '-', '')

	$sTemp = StringReplace($sTemp, '[GroupID]', 'grpStandLbl' & $vName)
	$sTemp = StringReplace($sTemp, '[Index]', $vName)
	$sTemp = StringReplace($sTemp, '[Label]', $vVariable)
	$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
	$sTemp = StringReplace($sTemp, '[Top]', $iTop)
	$sNewStandLabels &= @CRLF & $sTemp
EndFunc   ;==>_StandZoneLabel

Func _VBA($vVariable)
	$sTemp = $sVBATemplate

	$sTemp = StringReplace($sTemp, '[Index]', $vVariable)
	$sNewVBA &= @CRLF & $sTemp
EndFunc   ;==>_VBA
