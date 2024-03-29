#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\Instrument_List\Motor And Instrument List Rev 0.6.xlsx"
$sSheetName = 'Instrument List'
$sSheetName2 = 'New Control Panel Connection'
$sWinTitle = 'Sandbox.odg - LibreOffice Draw'
$sWinTitleArea = 'Area'
$sWinTitleSize = 'Position and Size'


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

For $iRow = 0 To UBound($aSheet) - 1
	$sStatus = $aSheet[$iRow][21]
	$sWiredTo = $aSheet[$iRow][9]
	$sID = $aSheet[$iRow][2]
	$sSigType = $aSheet[$iRow][8]

	If $sStatus <> 'Active' Or $sWiredTo = '' Then ContinueLoop

	$iWiredToIndex = _ArraySearch($aAddedPanels, $sWiredTo, 0, 0, 0, 0, 1, 0)
	$iPanelIndex = _ArraySearch($aAddedPanels, $sID, 0, 0, 0, 0, 1, 0)
	MouseClick('left', -195, 614, 1, 0)
	WinActivate($sWinTitle)
	Sleep(250)


	Switch $sSigType
		Case 'AS-I'
			$iStyleR = 255
			$iStyleG = 255
			$iStyleB = 0
		Case 'AI'
			$iStyleR = 255
			$iStyleG = 128
			$iStyleB = 0
		Case 'DO'
			$iStyleR = 129
			$iStyleG = 212
			$iStyleB = 26
		Case 'DI'
			$iStyleR = 129
			$iStyleG = 212
			$iStyleB = 26
		Case 'DI/DO'
			$iStyleR = 129
			$iStyleG = 212
			$iStyleB = 26
		Case 'OEM Provided'
			$iStyleR = 178
			$iStyleG = 178
			$iStyleB = 178
		Case 'Ethernet'
			$iStyleR = 128
			$iStyleG = 0
			$iStyleB = 128
		Case 'Load Cell'
			$iStyleR = 178
			$iStyleG = 178
			$iStyleB = 178
		Case 'AI/24VDC'
			$iStyleR = 255
			$iStyleG = 128
			$iStyleB = 0
		Case 'AI/AO'
			$iStyleR = 255
			$iStyleG = 128
			$iStyleB = 0
		Case 'AI(RTD)'
			$iStyleR = 255
			$iStyleG = 128
			$iStyleB = 0
		Case '?'
			$iStyleR = 178
			$iStyleG = 178
			$iStyleB = 178
		Case 'RTD'
			$iStyleR = 255
			$iStyleG = 128
			$iStyleB = 0
	EndSwitch

	If $iWiredToIndex < 0 Then
		$iLeft = -1618 + Mod($iPanelCount, 20) * 50
		$iTop = -245 + Floor($iPanelCount / 20) * 30

		MouseClick('left', -1898, -153, 1, 0)
		Sleep(100)
		MouseClickDrag('left', $iLeft, $iTop, $iLeft + 25, $iTop + 10, 1)
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{enter}')

		ClipPut($sWiredTo)
		While ClipGet() <> $sWiredTo
			Sleep(10)
		WEnd

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{e}{p}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{f4}')
		WinWait($sWinTitleSize)
		Sleep(100)
		ControlSend($sWinTitleSize, '', '', '!{d}')
		ControlSend($sWinTitleSize, '', '', 0.38)
		Sleep(100)
		ControlSend($sWinTitleSize, '', '', '!{e}')
		ControlSend($sWinTitleSize, '', '', 0.13)
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')

		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')
		$iWiredToIndex = _ArrayAdd($aAddedPanels, $sWiredTo & '|' & $iLeft & '|' & $iTop)
		$iPanelCount += 1
	EndIf
	Sleep(100)

	If $iPanelIndex < 0 Then
		$iLeft = -1618 + Mod($iPanelCount, 20) * 50
		$iTop = -245 + Floor($iPanelCount / 20) * 30

		MouseClick('left', -1898, -153, 1, 0)
		Sleep(100)
		MouseClickDrag('left', $iLeft, $iTop, $iLeft + 25, $iTop + 10, 1)
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{enter}')

		ClipPut($sID)
		While ClipGet() <> $sID
			Sleep(10)
		WEnd
		Sleep(100)

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{e}{p}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{f4}')
		WinWait($sWinTitleSize)
		Sleep(100)
		ControlSend($sWinTitleSize, '', '', '!{d}')
		ControlSend($sWinTitleSize, '', '', 0.38)
		Sleep(100)
		ControlSend($sWinTitleSize, '', '', '!{e}')
		ControlSend($sWinTitleSize, '', '', 0.13)
		Sleep(100)
		ControlSend($sWinTitleSize, '', '', '!{o}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{o}{r}')
		WinWait($sWinTitleArea)
		Sleep(100)
		ControlSend($sWinTitleArea, '', '', '!{r}')
		ControlSend($sWinTitleArea, '', '', $iStyleR)
		Sleep(100)
		ControlSend($sWinTitleArea, '', '', '!{g}')
		ControlSend($sWinTitleArea, '', '', $iStyleG)
		Sleep(100)
		ControlSend($sWinTitleArea, '', '', '!{b}')
		ControlSend($sWinTitleArea, '', '', $iStyleB)
		Sleep(100)
		ControlSend($sWinTitle, '', '', '!{o}')
		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')

		Sleep(100)
		ControlSend($sWinTitle, '', '', '{esc}')
		$iPanelIndex = _ArrayAdd($aAddedPanels, $sID & '|' & $iLeft & '|' & $iTop)

		$iPanelCount += 1
		$iInstCount += 1
	EndIf


;~ 	Exit
Next

ControlSend($sWinTitle, '', '', '{alt}')
ControlSend($sWinTitle, '', '', '{e}{a}')
For $iShrink = 1 To 15
	ControlSend($sWinTitle, '', '', '^[')
Next



For $iRow = 0 To UBound($aSheet) - 1
	$sStatus = $aSheet[$iRow][21]
	$sWiredTo = $aSheet[$iRow][9]
	$sID = $aSheet[$iRow][2]
	$sSigType = $aSheet[$iRow][8]

	$iWiredToIndex = _ArraySearch($aAddedPanels, $sWiredTo, 0, 0, 0, 0, 1, 0)
	$iPanelIndex = _ArraySearch($aAddedPanels, $sID, 0, 0, 0, 0, 1, 0)
	Sleep(100)
	MouseClick('left', -1901, -4, 1, 0)
	Sleep(100)
	MouseClickDrag('left', $aAddedPanels[$iPanelIndex][1] + 25, $aAddedPanels[$iPanelIndex][2], $aAddedPanels[$iWiredToIndex][1] + 25, $aAddedPanels[$iWiredToIndex][2] + 25, 1)
Next

Exit

Func _Exit()
	Exit
EndFunc   ;==>_Exit
