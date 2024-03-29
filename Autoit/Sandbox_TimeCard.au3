#include <Array.au3>
#include <Excel.au3>
#include <String.au3>
#include <Date.au3>

_AJ_Time('January')



Func _AJ_Time($sSheetName)
	$sTimePath = "C:\Users\rgrov\Triplex Automation LLC\Triplex Automation - Shared\Clients\RJX_Automation\TimeReports\AJ_PO_TimeRecord_2022.xlsx"

	$iDateRow = 1
	Local $aWeeklyTime[1][8] = [['StartDate', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']]
	Local $aWeeklyTimePotRoast[1][8] = [['StartDate', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']]
	Local $aWeeklyTimeRover[1][8] = [['StartDate', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']]
	Local $aWeeklyTimeRoverGF[1][8] = [['StartDate', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']]
	Local $aWeeklyTimeRoverPLP[1][8] = [['StartDate', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']]
	Local $aWeeklyTimeL5[1][8] = [['StartDate', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']]

	$sPotRoastSearch = 'Potroast'
	$sRoverSearch = 'Rover'
	$sRoverGFSearch = 'Rover - GF'
	$sRoverPLPSearch = 'Rover - PLP'
	$sL5Search = 'Line 5'

	$iPotRoastRow = 0
	$iRoverRow = 0
	$iRoverGFRow = 0
	$iRoverPLPRow = 0
	$iL5Row = 0


	$oWorkbook = _Excel_BookAttach($sTimePath)
	If Not IsObj($oWorkbook) Then
		$oTimeExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oTimeExcel, $sTimePath)
	Else
		$oTimeExcel = $oWorkbook.Application
	EndIf

	$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)

;~ 	_ArrayDisplay($aSheet)
;~ 	_ArrayDisplay($aWeeklyTime)

	For $iRow = 1 To UBound($aSheet) - 1
		Switch $aSheet[$iRow][0]
			Case $sPotRoastSearch
				$iPotRoastRow = $iRow
			Case $sRoverGFSearch
				$iRoverGFRow = $iRow
			Case $sRoverPLPSearch
				$iRoverPLPRow = $iRow
			Case $sRoverSearch
				$iRoverRow = $iRow
			Case $sL5Search
				$iL5Row = $iRow
		EndSwitch
	Next

	For $iColumn = 1 To UBound($aSheet, 2) - 1
		Local $aDatePart[1], $aTimePart[1]
		$sDateRaw = StringLeft($aSheet[$iDateRow][$iColumn], 8)
		$sDate = _StringInsert(_StringInsert($sDateRaw, '/', -4), '/', -2)
		_DateTimeSplit($sDate, $aDatePart, $aTimePart)

;~ 		_ArrayDisplay($aDatePart)
;~ 		MsgBox(0, $sDate,_DateToDayOfWeek($aDatePart[1],$aDatePart[2],$aDatePart[3]))
		$iDayofWeek = _DateToDayOfWeek($aDatePart[1], $aDatePart[2], $aDatePart[3])

		If $iDayofWeek <> 2 Then
			If $iDayofWeek > 2 Then
				$sStartDate = _DateAdd('D', 2 - $iDayofWeek, $sDate)
			Else
				$sStartDate = _DateAdd('D', -2, $sDate)
			EndIf
		Else
			$sStartDate = $sDate
		EndIf
		MsgBox(0, '', $sStartDate)

		$iArrayIndex = _ArraySearch($aWeeklyTime, $sStartDate, Default, Default, Default, Default, Default, 0)

		If $iArrayIndex < 0 Then
			$iArrayIndex = _ArrayAdd($aWeeklyTime, '')
		EndIf

		$aWeeklyTime[$iArrayIndex][0] = $sStartDate
		$aWeeklyTime[$iArrayIndex][$iDayofWeek] = $aSheet[$iPotRoastRow][$iColumn]

		_ArrayDisplay($aWeeklyTime)

		Exit

	Next



EndFunc   ;==>_AJ_Time

