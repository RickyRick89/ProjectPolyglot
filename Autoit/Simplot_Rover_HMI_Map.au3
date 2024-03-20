#include <array.au3>
#include <Excel.au3>

$sPath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\My_Rover_Work\dbo_Locations.xlsx"
$sCoordTemplate = FileRead("C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\My_Rover_Work\Use_Files\Coord_Template.xml")
$sRoverZoneTemplate = FileRead("C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\My_Rover_Work\Use_Files\Rover_Zone_Template.xml")
Local $aMap[200][200]

$oWorkbook = _Excel_BookAttach($sPath)
If Not IsObj($oWorkbook) Then
	$oConfigExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oConfigExcel, $sPath)
Else
	$oConfigExcel = $oWorkbook.Application
EndIf

$aFileLines = _Excel_RangeRead($oWorkbook, 'Map')

;~ _ArrayDisplay($aFileLines)
$sNewText = ''

;~~~~~~~~~~~~~~~~~~ Coordinates ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For $x = 1 To UBound($aFileLines, 2) - 1
	$iTop = 0
	$iLeft = $x * 25
	$sCoordName = 'Group_X' & $x
	$iCoord = $x
	$sTemp = StringReplace($sCoordTemplate, '[CoordName]', $sCoordName)
	$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
	$sTemp = StringReplace($sTemp, '[Top]', $iTop)
	$sTemp = StringReplace($sTemp, '[Coord]', $iCoord)

	$sNewText &= @CRLF & $sTemp
Next
For $y = 1 To UBound($aFileLines) - 1
	$iTop = $y * 25
	$iLeft = 0
	$sCoordName = 'Group_Y' & $y
	$iCoord = $y
	$sTemp = StringReplace($sCoordTemplate, '[CoordName]', $sCoordName)
	$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
	$sTemp = StringReplace($sTemp, '[Top]', $iTop)
	$sTemp = StringReplace($sTemp, '[Coord]', $iCoord)

	$sNewText &= @CRLF & $sTemp
Next


;~~~~~~~~~~~~~~~~~~ Zones ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For $x = 1 To UBound($aFileLines, 2) - 1
	For $y = 1 To UBound($aFileLines) - 1
		If $aFileLines[$y][$x] <> '' Then
			$iLeft = $x * 25
			$iTop = $y * 25
			$iIndex = $aFileLines[$y][$x]
			$iRoverZone = 'RoverZone' & $iIndex

			$sTemp = StringReplace($sRoverZoneTemplate, '[RoverZone]', $iRoverZone)
			$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
			$sTemp = StringReplace($sTemp, '[Top]', $iTop)
			$sTemp = StringReplace($sTemp, '[ZoneIndex]', $iIndex)
			$sNewText &= @CRLF & $sTemp
		EndIf
	Next
Next

ClipPut($sNewText)


