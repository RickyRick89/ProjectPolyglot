#include <array.au3>
#include <Excel.au3>

$sPath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\My_Rover_Work\dbo_Locations.xlsx"
$sConfigToolPath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\My_Rover_Work\Rover_ConfigTool_CALD.xls"

$oWorkbook = _Excel_BookAttach($sPath)
If Not IsObj($oWorkbook) Then
	$oConfigExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oConfigExcel, $sPath)
Else
	$oConfigExcel = $oWorkbook.Application
EndIf

$aConfig = _Excel_RangeRead($oWorkbook, 'Configuration')
$aLocations = _Excel_RangeRead($oWorkbook, 'dbo_Locations')
$aMap = _Excel_RangeRead($oWorkbook, 'Map')

$oWorkbook = _Excel_BookAttach($sConfigToolPath)
If Not IsObj($oWorkbook) Then
	$oConfigExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oConfigExcel, $sConfigToolPath)
Else
	$oConfigExcel = $oWorkbook.Application
EndIf

$aZones = _Excel_RangeRead($oWorkbook, 'Zones')

;~ _ArrayDisplay($aZones)

For $iRow = 1 To UBound($aConfig)
	$iIndex = $aConfig[$iRow][0]
	$iID = $aConfig[$iRow][1]
	$iCoordX = $aConfig[$iRow][5]
	$iCoordY = $aConfig[$iRow][6]
	$iType = $aConfig[$iRow][2]


	; Area determination
	$iArea = 0
	If $iCoordX > 35 Then
		$iArea = 4
	ElseIf $iCoordY > 63 Then
		$iArea = 1
	ElseIf $iCoordX > 5 And $iCoordX <= 35 Then
		$iArea = 3
	ElseIf $iCoordX <= 5 And $iCoordY <= 63 Then
		$iArea = 2
	EndIf

	; Entrance Zone Determination
	$iEntranceZone = 0
	$sEntranceDirection = ''
	$iEntranceCoordX = 0
	$iEntranceCoordY = 0
	$iUOpt00 = 0
	$iUOpt01 = 0
	$iUOpt02 = 0
	$iUOpt03 = 0
	$iUOpt04 = 0
	$iUOpt05 = 0
	$iUOpt06 = 0
	$iUOpt07 = 0
	$iUOpt11 = 0
	$iUOpt12 = 0
	$iUOpt13 = 0
	$iUOpt14 = 0
	$iROpt00 = 0
	$iROpt01 = 0
	$iROpt02 = 0
	$iROpt03 = 0
	$iROpt04 = 0
	$iROpt05 = 0
	$iROpt06 = 0
	$iROpt07 = 0
	$iROpt11 = 0
	$iROpt12 = 0
	$iROpt13 = 0
	$iROpt14 = 0
	$iDOpt00 = 0
	$iDOpt01 = 0
	$iDOpt02 = 0
	$iDOpt03 = 0
	$iDOpt04 = 0
	$iDOpt05 = 0
	$iDOpt06 = 0
	$iDOpt07 = 0
	$iDOpt11 = 0
	$iDOpt12 = 0
	$iDOpt13 = 0
	$iDOpt14 = 0
	$iLOpt00 = 0
	$iLOpt01 = 0
	$iLOpt02 = 0
	$iLOpt03 = 0
	$iLOpt04 = 0
	$iLOpt05 = 0
	$iLOpt06 = 0
	$iLOpt07 = 0
	$iLOpt11 = 0
	$iLOpt12 = 0
	$iLOpt13 = 0
	$iLOpt14 = 0


	If $iType = 14 Or $iType = 15 Or $iType = 17 Then
		For $iColumn = 11 To 14
			If $aConfig[$iRow][$iColumn] <> 0 Then
				Switch $iColumn
					Case 11
						$sEntranceDirection = 'Up'

						$iEntranceCoordX = $iCoordX
						$iEntranceCoordY = $iCoordY - 1
						$iUOpt00 = 1
						$iUOpt01 = 1
						$iUOpt02 = 1
						$iUOpt03 = 1
						$iUOpt04 = 1
						$iUOpt05 = 1
						$iUOpt06 = 1
						$iUOpt07 = 1
						$iUOpt11 = 1
						$iUOpt12 = 1
						$iUOpt13 = 1
						$iUOpt14 = 1
					Case 12
						$sEntranceDirection = 'Right'

						$iEntranceCoordX = $iCoordX + 1
						$iEntranceCoordY = $iCoordY
						$iROpt00 = 1
						$iROpt01 = 1
						$iROpt02 = 1
						$iROpt03 = 1
						$iROpt04 = 1
						$iROpt05 = 1
						$iROpt06 = 1
						$iROpt07 = 1
						$iROpt11 = 1
						$iROpt12 = 1
						$iROpt13 = 1
						$iROpt14 = 1
					Case 13
						$sEntranceDirection = 'Down'

						$iEntranceCoordX = $iCoordX
						$iEntranceCoordY = $iCoordY + 1
						$iDOpt00 = 1
						$iDOpt01 = 1
						$iDOpt02 = 1
						$iDOpt03 = 1
						$iDOpt04 = 1
						$iDOpt05 = 1
						$iDOpt06 = 1
						$iDOpt07 = 1
						$iDOpt11 = 1
						$iDOpt12 = 1
						$iDOpt13 = 1
						$iDOpt14 = 1
					Case 14
						$sEntranceDirection = 'Left'

						$iEntranceCoordX = $iCoordX - 1
						$iEntranceCoordY = $iCoordY
						$iLOpt00 = 1
						$iLOpt01 = 1
						$iLOpt02 = 1
						$iLOpt03 = 1
						$iLOpt04 = 1
						$iLOpt05 = 1
						$iLOpt06 = 1
						$iLOpt07 = 1
						$iLOpt11 = 1
						$iLOpt12 = 1
						$iLOpt13 = 1
						$iLOpt14 = 1
				EndSwitch
				ExitLoop
			EndIf
		Next
		$iEntranceZone = $aMap[$iEntranceCoordY][$iEntranceCoordX]
	EndIf

	For $iRow2 = 1 To UBound($aLocations) - 1
		If $iID = $aLocations[$iRow2][0] Then
			$iBarCode = $aLocations[$iRow2][18]
			If $iBarCode <> '' Then
				$sZoneDesc = 'LOC=' & $iID & ';BC=' & $iBarCode
			Else
				$sZoneDesc = 'LOC=' & $iID
			EndIf

			ExitLoop
		EndIf
	Next

	ConsoleWrite(@CRLF & '...>' & $iIndex)
	For $iRow2 = 9 To UBound($aZones) - 1
		$iConfigIndex = $aZones[$iRow2][3] - 1
		If $iConfigIndex = $iIndex Then
			$aZones[$iRow2][_Excel_ColumnToNumber('B') - 1] = $sZoneDesc
			$aZones[$iRow2][_Excel_ColumnToNumber('I') - 1] = $iArea
			$aZones[$iRow2][_Excel_ColumnToNumber('H') - 1] = $iEntranceZone

			$aZones[$iRow2][_Excel_ColumnToNumber('K') - 1] = $iUOpt00
			$aZones[$iRow2][_Excel_ColumnToNumber('L') - 1] = $iUOpt01
			$aZones[$iRow2][_Excel_ColumnToNumber('M') - 1] = $iUOpt02
			$aZones[$iRow2][_Excel_ColumnToNumber('N') - 1] = $iUOpt03
			$aZones[$iRow2][_Excel_ColumnToNumber('O') - 1] = $iUOpt04
			$aZones[$iRow2][_Excel_ColumnToNumber('P') - 1] = $iUOpt05
			$aZones[$iRow2][_Excel_ColumnToNumber('Q') - 1] = $iUOpt06
			$aZones[$iRow2][_Excel_ColumnToNumber('R') - 1] = $iUOpt07
			$aZones[$iRow2][_Excel_ColumnToNumber('S') - 1] = $iUOpt11
			$aZones[$iRow2][_Excel_ColumnToNumber('T') - 1] = $iUOpt12
			$aZones[$iRow2][_Excel_ColumnToNumber('U') - 1] = $iUOpt13
			$aZones[$iRow2][_Excel_ColumnToNumber('V') - 1] = $iUOpt14
			$aZones[$iRow2][_Excel_ColumnToNumber('W') - 1] = $iROpt00
			$aZones[$iRow2][_Excel_ColumnToNumber('X') - 1] = $iROpt01
			$aZones[$iRow2][_Excel_ColumnToNumber('Y') - 1] = $iROpt02
			$aZones[$iRow2][_Excel_ColumnToNumber('Z') - 1] = $iROpt03
			$aZones[$iRow2][_Excel_ColumnToNumber('AA') - 1] = $iROpt04
			$aZones[$iRow2][_Excel_ColumnToNumber('AB') - 1] = $iROpt05
			$aZones[$iRow2][_Excel_ColumnToNumber('AC') - 1] = $iROpt06
			$aZones[$iRow2][_Excel_ColumnToNumber('AD') - 1] = $iROpt07
			$aZones[$iRow2][_Excel_ColumnToNumber('AE') - 1] = $iROpt11
			$aZones[$iRow2][_Excel_ColumnToNumber('AF') - 1] = $iROpt12
			$aZones[$iRow2][_Excel_ColumnToNumber('AG') - 1] = $iROpt13
			$aZones[$iRow2][_Excel_ColumnToNumber('AH') - 1] = $iROpt14
			$aZones[$iRow2][_Excel_ColumnToNumber('AI') - 1] = $iDOpt00
			$aZones[$iRow2][_Excel_ColumnToNumber('AJ') - 1] = $iDOpt01
			$aZones[$iRow2][_Excel_ColumnToNumber('AK') - 1] = $iDOpt02
			$aZones[$iRow2][_Excel_ColumnToNumber('AL') - 1] = $iDOpt03
			$aZones[$iRow2][_Excel_ColumnToNumber('AM') - 1] = $iDOpt04
			$aZones[$iRow2][_Excel_ColumnToNumber('AN') - 1] = $iDOpt05
			$aZones[$iRow2][_Excel_ColumnToNumber('AO') - 1] = $iDOpt06
			$aZones[$iRow2][_Excel_ColumnToNumber('AP') - 1] = $iDOpt07
			$aZones[$iRow2][_Excel_ColumnToNumber('AQ') - 1] = $iDOpt11
			$aZones[$iRow2][_Excel_ColumnToNumber('AR') - 1] = $iDOpt12
			$aZones[$iRow2][_Excel_ColumnToNumber('AS') - 1] = $iDOpt13
			$aZones[$iRow2][_Excel_ColumnToNumber('AT') - 1] = $iDOpt14
			$aZones[$iRow2][_Excel_ColumnToNumber('AU') - 1] = $iLOpt00
			$aZones[$iRow2][_Excel_ColumnToNumber('AV') - 1] = $iLOpt01
			$aZones[$iRow2][_Excel_ColumnToNumber('AW') - 1] = $iLOpt02
			$aZones[$iRow2][_Excel_ColumnToNumber('AX') - 1] = $iLOpt03
			$aZones[$iRow2][_Excel_ColumnToNumber('AY') - 1] = $iLOpt04
			$aZones[$iRow2][_Excel_ColumnToNumber('AZ') - 1] = $iLOpt05
			$aZones[$iRow2][_Excel_ColumnToNumber('BA') - 1] = $iLOpt06
			$aZones[$iRow2][_Excel_ColumnToNumber('BB') - 1] = $iLOpt07
			$aZones[$iRow2][_Excel_ColumnToNumber('BC') - 1] = $iLOpt11
			$aZones[$iRow2][_Excel_ColumnToNumber('BD') - 1] = $iLOpt12
			$aZones[$iRow2][_Excel_ColumnToNumber('BE') - 1] = $iLOpt13
			$aZones[$iRow2][_Excel_ColumnToNumber('BF') - 1] = $iLOpt14
			ExitLoop
		EndIf
	Next

Next
$aZonesWrite = $aZones
For $iRow = 8 To 0 Step -1
	_ArrayDelete($aZonesWrite, $iRow)
Next
For $iColumn = 3 To 0 Step -1
	_ArrayColDelete($aZonesWrite, $iColumn)
Next
_Excel_RangeWrite($oWorkbook, 'Zones', $aZonesWrite, 'E10')
