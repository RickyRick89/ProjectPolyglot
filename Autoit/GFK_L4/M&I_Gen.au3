#include <Array.au3>
#include <Excel.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


$sEquipmentListPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_Grand_Forks\Lists\2023-02-08 GF L4 PID Equipment List.xlsx"
$sInstrumentListPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_Grand_Forks\Lists\2023-02-08 GF L4 PID Instrumentation List.xlsx"
$sMotorListPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_Grand_Forks\Lists\2023-02-08 GF L4 PID Motor List.xlsx"
$sValveListPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_Grand_Forks\Lists\GF L4 Valve List-WSA modified Western States Automation 031423.xlsx"
$sMIListPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_Grand_Forks\Lists\Motor And Instrument List Rev 0.xlsx"

$sPIDPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_Grand_Forks\PIDs\2023-04-26 GF L4 PIDs - RBG.pdf"
$sPIDName = '2023-04-26 GF L4 PIDs - RBG.pdf'



;~~~~~~~~~~~~~~~~~~~~~~~ Equipment List~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$sWorkbookPath = $sEquipmentListPath
$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aEquipment = _Excel_RangeRead($oWorkbook)
;~ _ArrayDisplay($aEquipment)


;~~~~~~~~~~~~~~~~~~~~~~~ Instrument List~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$sWorkbookPath = $sInstrumentListPath
$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aInstruments = _Excel_RangeRead($oWorkbook)
;~ _ArrayDisplay($aInstruments)

;~~~~~~~~~~~~~~~~~~~~~~~ Valve List~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$sWorkbookPath = $sValveListPath
$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aValves = _Excel_RangeRead($oWorkbook)
;~ _ArrayDisplay($aValves)

;~~~~~~~~~~~~~~~~~~~~~~~ Motor List~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$sWorkbookPath = $sMotorListPath
$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aMotors = _Excel_RangeRead($oWorkbook)
;~ _ArrayDisplay($aMotors)


;~~~~~~~~~~~~~~~~~~~~~~~~ M & I List ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$sWorkbookPath = $sMIListPath
$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$sSheetName = 'Motor List'

Local $aFullIDList[1]

$iCount = 2
For $iRow = 1 To UBound($aMotors) - 1
	$sType = 'EC'
	$sTag = $aMotors[$iRow][0]
	$sHP = $aMotors[$iRow][1]
	$sFullID = $sType & '-' & $sTag
	$sEquipNum = Number($sTag)
	$sDrawing = StringReplace($aMotors[$iRow][3], '.dwg', '')
	$sLayer = $aMotors[$iRow][4]

	$sSearch = 'M ' & $sHP & ' ' & $sTag

	$iIndex = _ArraySearch($aFullIDList, $sFullID)
	If $iIndex >= 0 Then ContinueLoop
	$aFullIDList[0] = _ArrayAdd($aFullIDList, $sFullID)

	ConsoleWrite(@CRLF & '-->' & $sFullID & @CRLF & '$sEquipNum=' & $sEquipNum & @CRLF & '$sDrawing=' & $sDrawing & @CRLF & '$sLayer=' & $sLayer)

	$iInc = _ArraySearch($aEquipment, $sEquipNum, 0, 0, 0, 0, 1, 1)
	If $iInc < 0 Then
;~ 		$sDescription = InputBox('', $sEquipNum)
		ContinueLoop
	Else
		$sDescription = $aEquipment[$iInc][2]
	EndIf


	ControlSetText($sPIDName, '', '[CLASS:Edit; INSTANCE:2]', $sSearch)
	Sleep(1000)
	WinActivate($sPIDName)
	ControlSend($sPIDName, '', '', '^{f}')
	ControlSend($sPIDName, '', '[CLASS:Edit; INSTANCE:2]', '{enter}')

	$sFullID = InputBox($sFullID, $sFullID, $sFullID)
	$sControlType = InputBox($sFullID, $sDescription, 'VFD')

	_Excel_RangeWrite($oWorkbook, $sSheetName, $sFullID, 'B' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sDescription, 'C' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sDrawing, 'E' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sLayer, 'R' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sControlType, 'H' & $iCount)
	$iCount += 1


Next



Exit
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$sSheetName = 'Instrument List'

Local $aFullIDList[1]

$iCount = 2
For $iRow = 1 To UBound($aInstruments) - 1
	$sType = $aInstruments[$iRow][0]
	$sTag = $aInstruments[$iRow][1]
	$sFullID = $sType & '-' & $sTag
	$sEquipNum = Number($sTag)
	$sDrawing = StringReplace($aInstruments[$iRow][3], '.dwg', '')
	$sLayer = $aInstruments[$iRow][4]

	$iIndex = _ArraySearch($aFullIDList, $sFullID)
	If $iIndex >= 0 Then ContinueLoop
	$aFullIDList[0] = _ArrayAdd($aFullIDList, $sFullID)

	ConsoleWrite(@CRLF & '-->' & $sFullID & @CRLF & '$sEquipNum=' & $sEquipNum & @CRLF & '$sDrawing=' & $sDrawing & @CRLF & '$sLayer=' & $sLayer)
	$sTypeDescription = _TypeDecode($sType)
	$sTypeDescription = StringReplace($sTypeDescription, 'Speed Valve', 'Valve')

	$iInc = _ArraySearch($aEquipment, $sEquipNum, 0, 0, 0, 0, 1, 1)
	If $iInc < 0 Then
;~ 		$sDescription = InputBox('', $sEquipNum)
		ContinueLoop
	Else
		$sDescription = $aEquipment[$iInc][2]
	EndIf

	If StringInStr($sTypeDescription, 'Valve') Then
		$iInc = _ArraySearch($aValves, $sFullID, 0, 0, 0, 0, 1, 4)
		$sValveDesc = ''
		If $iInc >= 0 Then
			$sValveDesc = $aValves[$iInc][5]
		EndIf
		WinActivate($sPIDName)
		ControlSend($sPIDName, '', '', '^{f}')
		ControlSend($sPIDName, '', '', $sType & ' ' & $sTag)
		ControlSend($sPIDName, '', '', '{enter}')
		$sTypeDescription = InputBox($sFullID, $sValveDesc, $sTypeDescription)
	EndIf
	$sDescription &= ' ' & $sTypeDescription
	$sDescription = StringReplace(StringUpper($sDescription), '  ', ' ')
;~ 	MsgBox(0, '', $sDescription)

	_Excel_RangeWrite($oWorkbook, $sSheetName, $sFullID, 'C' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sType, 'D' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sEquipNum, 'E' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sTag, 'F' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sDescription, 'G' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sDrawing, 'T' & $iCount)
	_Excel_RangeWrite($oWorkbook, $sSheetName, $sLayer, 'U' & $iCount)
	$iCount += 1
Next





;############################### Functions #########################################

Func _TypeDecode($sType)
	Local $aFirstLetter[26][2] = [["A", "Analysis"], _
			["B", "Burner"], _
			["C", ""], _
			["D", ""], _
			["E", "Voltage"], _
			["F", "Flow"], _
			["G", ""], _
			["H", "Hand"], _
			["I", "Current"], _
			["J", "Power"], _
			["K", "Time"], _
			["L", "Level"], _
			["M", ""], _
			["N", ""], _
			["O", ""], _
			["P", "Pressure"], _
			["Q", "Quantity"], _
			["R", "Radiation"], _
			["S", "Speed"], _
			["T", "Temperature"], _
			["U", "Multivariable"], _
			["V", "Vibration"], _
			["W", "Weight"], _
			["X", ""], _
			["Y", "State"], _
			["Z", "Position"]]

	Local $aSucceedingLetters[26][2] = [["A", "Alarm"], _
			["B", ""], _
			["C", "Control"], _
			["D", ""], _
			["E", "Sensor"], _
			["F", ""], _
			["G", "Gauge"], _
			["H", "High"], _
			["I", "Indicator"], _
			["J", "Scan"], _
			["K", "Control Station"], _
			["L", "Light"], _
			["M", ""], _
			["N", ""], _
			["O", "Orifice"], _
			["P", "Point"], _
			["Q", "Totalizer"], _
			["R", "Recorder"], _
			["S", "Switch"], _
			["T", "Transmitter"], _
			["U", "Multifunction"], _
			["V", "Valve"], _
			["W", "Well"], _
			["X", "Accessory"], _
			["Y", "Auxiliary"], _
			["Z", "Actuator"]]

	$aLetters = StringSplit($sType, '')
	$sDescription = ''
	$iInc = _ArraySearch($aFirstLetter, $aLetters[1], 0, 0, 0, 0, 1, 0)
	$sDescription &= $aFirstLetter[$iInc][1]

	For $x = 2 To $aLetters[0]
		$iInc = _ArraySearch($aSucceedingLetters, $aLetters[$x], 0, 0, 0, 0, 1, 0)
		If $aSucceedingLetters[$iInc][1] <> '' Then
			$sDescription &= ' ' & $aSucceedingLetters[$iInc][1]
		EndIf
	Next
	Return ($sDescription)

EndFunc   ;==>_TypeDecode

Func _Exit()
	Exit
EndFunc   ;==>_Exit
