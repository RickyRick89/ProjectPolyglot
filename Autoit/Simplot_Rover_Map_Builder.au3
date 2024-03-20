#include <array.au3>
#include <Excel.au3>

$sPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_GF_Rovers\Locations_Table.xlsx"
;~ $sArea = 'Freezer'
$sArea = 'Grand_Forks'
Local $aMap1[200][200]
Local $aMap2[200][200]
Local $aMap3[200][200]
Local $aMap4[200][200]

$oWorkbook = _Excel_BookAttach($sPath)
If Not IsObj($oWorkbook) Then
	$oConfigExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oConfigExcel, $sPath)
Else
	$oConfigExcel = $oWorkbook.Application
EndIf

;~ $aFileLines = _Excel_RangeRead($oWorkbook, $sArea & '(Original)')
$aFileLines = _Excel_RangeRead($oWorkbook, '12_21')
;~ Exit
;~ _ArrayDisplay($aFileLines)
;~ Exit

For $x = 1 To 100
	For $y = 1 To 100
		$aMap1[$x + 1][0] = $x
		$aMap2[$x + 1][0] = $x
		$aMap3[$x + 1][0] = $x
		$aMap4[$x + 1][0] = $x

		$aMap1[0][$y + 1] = $y
		$aMap2[0][$y + 1] = $y
		$aMap3[0][$y + 1] = $y
		$aMap4[0][$y + 1] = $y
	Next
Next


For $x = 1 To UBound($aFileLines) - 1
	$iXCoord = $aFileLines[$x][4]
	$iYCoord = $aFileLines[$x][5]
	$iZCoord = $aFileLines[$x][3]
	$iIndex = $aFileLines[$x][18]
	$sName = $aFileLines[$x][2]


	Switch $iZCoord
		Case 1
			$aMap1[$iYCoord + 1][$iXCoord + 1] = $iIndex
			If $sName <> '' Then
				If $iXCoord = 1 Then
					$aMap1[$iYCoord + 1][$iXCoord] = $sName
				ElseIf $iYCoord = 1 Then
					$aMap1[$iYCoord][$iXCoord + 1] = $sName
				EndIf
			EndIf
		Case 2
			$aMap2[$iYCoord + 1][$iXCoord + 1] = $iIndex
			If $sName <> '' Then
				If $iXCoord = 1 Then
					$aMap2[$iYCoord + 1][$iXCoord] = $sName
				ElseIf $iYCoord = 1 Then
					$aMap2[$iYCoord][$iXCoord + 1] = $sName
				EndIf
			EndIf
		Case 3
			$aMap3[$iYCoord + 1][$iXCoord + 1] = $iIndex
			If $sName <> '' Then
				If $iXCoord = 1 Then
					$aMap3[$iYCoord + 1][$iXCoord] = $sName
				ElseIf $iYCoord = 1 Then
					$aMap3[$iYCoord][$iXCoord + 1] = $sName
				EndIf
			EndIf
		Case 4
			$aMap4[$iYCoord + 1][$iXCoord + 1] = $iIndex
			If $sName <> '' Then
				If $iXCoord = 1 Then
					$aMap4[$iYCoord + 1][$iXCoord] = $sName
				ElseIf $iYCoord = 1 Then
					$aMap4[$iYCoord][$iXCoord + 1] = $sName
				EndIf
			EndIf
	EndSwitch
Next


_Excel_SheetAdd($oWorkbook, Default, False, 1, $sArea & '_Map_LVL1')
_Excel_RangeWrite($oWorkbook, Default, $aMap1)
_Excel_SheetAdd($oWorkbook, Default, False, 1, $sArea & '_Map_LVL2')
_Excel_RangeWrite($oWorkbook, Default, $aMap2)
_Excel_SheetAdd($oWorkbook, Default, False, 1, $sArea & '_Map_LVL3')
_Excel_RangeWrite($oWorkbook, Default, $aMap3)
_Excel_SheetAdd($oWorkbook, Default, False, 1, $sArea & '_Map_LVL4')
_Excel_RangeWrite($oWorkbook, Default, $aMap4)

