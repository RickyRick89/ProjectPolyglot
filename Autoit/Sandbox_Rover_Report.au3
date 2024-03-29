#include <Array.au3>
#include <File.au3>
#include <Excel.au3>

$sFilePath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\Reports\6AM Daily Report.xlsx"
$sOutFilePath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\Reports\AllStars-Duds.xlsx"
Local $a522Columns[1], $aJobCountColumns[1]
Local $aAllStars[1][2], $aDuds[1][2]

$oMasterWorkbook = _Excel_BookAttach($sFilePath)
If Not IsObj($oMasterWorkbook) Then
	$oExcel = _Excel_Open()
	$oMasterWorkbook = _Excel_BookOpen($oExcel, $sFilePath)
Else
	$oExcel = $oMasterWorkbook.Application
EndIf

$aReport = _Excel_RangeRead($oMasterWorkbook, "Daily 500 & Jobs Report")

;~ _ArrayDisplay($aReport)

For $iColumn = 1 To UBound($aReport, 2) - 1
	If $aReport[2][$iColumn] = '522' Then
		$a522Columns[0] = _ArrayAdd($a522Columns, $iColumn)
	ElseIf $aReport[2][$iColumn] = 'JobCount' Then
		$aJobCountColumns[0] = _ArrayAdd($aJobCountColumns, $iColumn)
	EndIf
Next


For $iRow = 3 To UBound($aReport) - 1
	$bAllStar = False
	$bDud = False

	$iRoverNumber = Number($aReport[$iRow][0])
	If $iRoverNumber = 0 Then
		ExitLoop
	EndIf
	For $iColumnIndex = 1 To $a522Columns[0]
		If $iColumnIndex = 1 Then
			If $aReport[$iRow][$a522Columns[$iColumnIndex]] = '' And $aReport[$iRow][$aJobCountColumns[$iColumnIndex]] <> '' Then
				$bAllStar = True
				$iAllStarIndex = _ArrayAdd($aAllStars, $iRoverNumber & '|' & Number($aReport[$iRow][$aJobCountColumns[$iColumnIndex]]))
			Else
				$bDud = True
				If $aReport[$iRow][$a522Columns[$iColumnIndex]] = '' Then
					_ArrayAdd($aDuds, $iRoverNumber & '|' & 'No Run')
				Else
					_ArrayAdd($aDuds, $iRoverNumber & '|' & $aReport[$iRow][$aJobCountColumns[$iColumnIndex]] / $aReport[$iRow][$a522Columns[$iColumnIndex]])
				EndIf
				ExitLoop
			EndIf
		Else
			If $aReport[$iRow][$a522Columns[$iColumnIndex]] <> '' Then ExitLoop
			$aAllStars[$iAllStarIndex][1] = $aAllStars[$iAllStarIndex][1] + Number($aReport[$iRow][$aJobCountColumns[$iColumnIndex]])

		EndIf

	Next
Next

$oWorkbook = _Excel_BookNew($oExcel)
_Excel_RangeWrite($oWorkbook, Default, $aAllStars, 'A2')
_Excel_RangeWrite($oWorkbook, Default, $aDuds, 'D2')
_Excel_BookSaveAs($oWorkbook, $sOutFilePath)


;~ _ArrayToClip($aAllStars, @TAB)
;~ _ArrayDisplay($aAllStars)

;~ _ArrayToClip($aDuds, @TAB)
;~ _ArrayDisplay($aDuds)
