#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\Instrument_List\Motor And Instrument List Rev 0.6.xlsx"
$sSheetName = 'Instrument List'
$sSheetName2 = 'New Control Panel Connection'
$sWinTitle = 'Presentation1 - PowerPoint'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)
$aPanelSheet = _Excel_RangeRead($oWorkbook, $sSheetName)

_ArrayDelete($aSheet, 0)
;~ _ArraySort($aSheet, 0, 0, 0, 9)
;~ _ArrayDisplay($aSheet)


$sLastWiredTo = ''
$iInstCount = 0
For $iRow = 0 To UBound($aSheet) - 1
	$sStatus = $aSheet[$iRow][21]
	$sWiredTo = $aSheet[$iRow][9]
	$sID = $aSheet[$iRow][2]
	$sSigType = $aSheet[$iRow][8]

	If $sStatus <> 'Active' Or $sWiredTo = '' Then ContinueLoop
	WinActivate($sWinTitle)
	Sleep(100)

	If $sWiredTo <> $sLastWiredTo Then
		$iInstCount = 0

		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{n}{s}{i}')
		Sleep(250)
		ControlSend($sWinTitle, '', '', '{down 2}{enter}')
		Sleep(250)
		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{n}{s}{h}')
		Sleep(250)
		ControlSend($sWinTitle, '', '', '{down 3}{enter}')
		Sleep(250)

		MouseClick('left', -824, 182, 2, 0)
		Sleep(250)
		ControlSend($sWinTitle, '', '', $sWiredTo)
		Sleep(250)
		ControlSend($sWinTitle, '', '', '{esc}')
		Sleep(250)
		ControlSend($sWinTitle, '', '', '{alt}')
		ControlSend($sWinTitle, '', '', '{j}{d}{w}')
		Send('{3}{enter}')
		Sleep(250)
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


	Sleep(250)
	ControlSend($sWinTitle, '', '', '{alt}')
	ControlSend($sWinTitle, '', '', '{n}{s}{h}')
	Sleep(250)
	ControlSend($sWinTitle, '', '', '{down 3}{enter}')
	Sleep(250)

	MouseClickDrag('left', -865, 138, $iLeft, $iTop, 2)
	Sleep(250)
;~ 	MouseClick('left', -824, 182, 2, 0)
;~ 	Sleep(250)
	ControlSend($sWinTitle, '', '', $sID)
;~ 	Sleep(250)
;~ 	ControlSend($sWinTitle, '', '', '{esc}')
	Sleep(500)
	ControlSend($sWinTitle, '', '', '{alt}')
	ControlSend($sWinTitle, '', '', '{j}{d}{s}{s}')
	Sleep(500)
	For $iInc = 1 To $iStyle
		Send('{right}')
	Next
	ControlSend($sWinTitle, '', '', '{enter}')
	Sleep(250)
	ControlSend($sWinTitle, '', '', '{alt}')
	ControlSend($sWinTitle, '', '', '{j}{d}{w}')
	Send('1.5{enter}')
	Sleep(250)
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