#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\Instrument_List\Motor And Instrument List Rev 0.6.xlsx"
$sSheetName = 'Instrument List'
$sSheetName2 = 'New Control Panel Connection'
$sWinTitle = 'Sandbox.odg - LibreOffice Draw'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)
$aPanelSheet = _Excel_RangeRead($oWorkbook, $sSheetName2)

_ArrayDelete($aSheet, 0)
_ArrayDelete($aPanelSheet, 0)
;~ _ArraySort($aSheet, 0, 0, 0, 9)
;~ _ArrayDisplay($aSheet)
;~ _ArrayDisplay($aPanelSheet)
;~ Exit

$sLastWiredTo = ''
$iInstCount = 0
$iPanelCount = 0

Local $aAddedPanels[1][3]

For $iRow = 0 To UBound($aPanelSheet) - 1
	$sPanel = $aPanelSheet[$iRow][0]
	$sWiredTo = $aPanelSheet[$iRow][3]

	$iWiredToIndex = _ArraySearch($aAddedPanels, $sWiredTo, 0, 0, 0, 0, 1, 0)
	$iPanelIndex = _ArraySearch($aAddedPanels, $sPanel, 0, 0, 0, 0, 1, 0)
	MouseClick('left', -195, 614, 1, 0)
	WinActivate($sWinTitle)
	Sleep(250)


	If $iWiredToIndex < 0 Then
		$iLeft = -1618 + Mod($iPanelCount, 14) * 75
		$iTop = -245 + Floor($iPanelCount / 14) * 50

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{s}{t}')
		Sleep(100)
		MouseClickDrag('left', $iLeft, $iTop, $iLeft + 50, $iTop + 25, 2)
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{enter}')

		ClipPut($sWiredTo)
		While ClipGet() <> $sWiredTo
			Sleep(10)
		WEnd

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{e}{p}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')

		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')
		$iWiredToIndex = _ArrayAdd($aAddedPanels, $sWiredTo & '|' & $iLeft & '|' & $iTop)
		$iPanelCount += 1
	EndIf
	Sleep(100)

	If $iPanelIndex < 0 Then
		$iLeft = -1618 + Mod($iPanelCount, 14) * 75
		$iTop = -245 + Floor($iPanelCount / 14) * 50

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{s}{t}')
		Sleep(100)
		MouseClickDrag('left', $iLeft, $iTop, $iLeft + 50, $iTop + 25, 2)
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{enter}')

		ClipPut($sPanel)
		While ClipGet() <> $sPanel
			Sleep(10)
		WEnd
		Sleep(100)

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{e}{p}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')

		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')
		$iPanelIndex = _ArrayAdd($aAddedPanels, $sPanel & '|' & $iLeft & '|' & $iTop)

		$iPanelCount += 1
	EndIf


	Sleep(100)
	MouseClick('left', -1901, -4, 1, 0)
	Sleep(100)
	MouseClickDrag('left', $aAddedPanels[$iPanelIndex][1] + 25, $aAddedPanels[$iPanelIndex][2], $aAddedPanels[$iWiredToIndex][1] + 25, $aAddedPanels[$iWiredToIndex][2] + 25, 2)
;~ 	Exit
Next

ControlSend($sWinTitle, '', '', '{alt}')
ControlSend($sWinTitle, '', '', '{e}{a}')
For $iShrink = 1 To 15
	ControlSend($sWinTitle, '', '', '^[')
Next
Exit

$sWiredTo = ''
For $iRow = 0 To UBound($aSheet) - 1
	$sStatus = $aSheet[$iRow][21]
	$sWiredTo = $aSheet[$iRow][9]
	$sID = $aSheet[$iRow][2]
	$sSigType = $aSheet[$iRow][8]

;~ 	If $sStatus <> 'Active' Or $sWiredTo = '' Then ContinueLoop
	WinActivate($sWinTitle)
	Sleep(100)

	If $sWiredTo <> $sLastWiredTo Then
		$iInstCount = 0

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{n}{s}{i}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{down 2}{enter}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{n}{s}{h}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{down 3}{enter}')
		Sleep(100)

		MouseClick('left', -824, 182, 2, 0)
		Sleep(100)
		ControlSend($sWinTitle, '', '', $sWiredTo)
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{j}{d}{w}')
		Send('{3}{enter}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{j}{d}{a}{a}{c}')
		Sleep(500)
		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{j}{d}{a}{a}{t}')


	EndIf

	Switch $sSigType
		Case 'AS-I'
			$iStyle = 1
		Case 'AI'
			$iStyle = 5
		Case 'DO'
			$iStyle = 6
		Case 'DI'
			$iStyle = 6
		Case 'DI/DO'
			$iStyle = 6
		Case 'OEM Provided'
			$iStyle = 2
		Case 'Ethernet'
			$iStyle = 3
		Case 'Load Cell'
			$iStyle = 2
		Case 'AI/24VDC'
			$iStyle = 5
		Case 'AI/AO'
			$iStyle = 5
		Case 'AI(RTD)'
			$iStyle = 5
		Case '?'
			$iStyle = 2
		Case 'RTD'
			$iStyle = 5
	EndSwitch

	If $iStyle <> 1 And $iStyle <> 6 Then
		$sLastWiredTo = $sWiredTo
		ContinueLoop
	EndIf

	$iLeft = -1519 + Mod($iInstCount, 7) * 200
	$iTop = -82 + Floor($iInstCount / 7) * 80


	Sleep(100)
	ControlSend($sWinTitle, '', '', '{alt}')
	ControlSend($sWinTitle, '', '', '{n}{s}{h}')
	Sleep(100)
	ControlSend($sWinTitle, '', '', '{down 3}{enter}')
	Sleep(100)

	MouseClickDrag('left', -865, 138, $iLeft, $iTop, 2)
	Sleep(100)
;~ 	MouseClick('left', -824, 182, 2, 0)
;~ 	Sleep(100)
	ControlSend($sWinTitle, '', '', $sID)
;~ 	Sleep(100)
;~ 	ControlSend($sWinTitle, '', '', '{esc}')
	Sleep(500)
	ControlSend($sWinTitle, '', '', '{alt}')
	ControlSend($sWinTitle, '', '', '{j}{d}{s}{s}')
	Sleep(500)
	For $iInc = 1 To $iStyle
		Send('{right}')
	Next
	ControlSend($sWinTitle, '', '', '{enter}')
	Sleep(100)
	ControlSend($sWinTitle, '', '', '{alt}')
	ControlSend($sWinTitle, '', '', '{j}{d}{w}')
	Send('1.5{enter}')
	Sleep(100)
	ControlSend($sWinTitle, '', '', '{alt}')
	ControlSend($sWinTitle, '', '', '{j}{d}{h}')
	Send('.5{enter}')

;~ 	Exit

	$iInstCount += 1
	$sLastWiredTo = $sWiredTo
Next


Func _Exit()
	Exit
EndFunc   ;==>_Exit
