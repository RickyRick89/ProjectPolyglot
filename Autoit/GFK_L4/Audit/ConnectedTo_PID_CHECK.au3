#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

Global $sLastSelected = 'CLXL4B_ASI01_JB01'
Global $aOptions[1] = [$sLastSelected]

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\Motor And Instrument List Rev 1.xlsx"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\2023-05-09 GF L4 PIDs - MarkedUp.pdf"
$sSheetName = 'Instrument List'
$sWinTitlePID = '2023-05-09 GF L4 PIDs - MarkedUp.pdf'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)


;~ _ArrayDisplay($aSheet)
;~ Exit
ShellExecute($sPIDPath)
WinWait($sWinTitlePID)
WinActivate($sWinTitlePID)
ControlSend($sWinTitlePID, '', '', '{alt}')
Sleep(100)
ControlSend($sWinTitlePID, '', '', '{k}{1}')
Sleep(100)
ControlSend($sWinTitlePID, '', '', '{b}')
Sleep(1000)

For $iInc = 1 To UBound($aSheet) - 1

	If StringInStr($sSheetName, 'Motor') Then
		$sType = $aSheet[$iInc][7]
		$sHP = $aSheet[$iInc][5]
		$sDesc = $aSheet[$iInc][2]
		$sSearch = 'EC ' & $sType & ' ' & StringReplace($aSheet[$iInc][1], 'EC-', '')
		$sStatus = $aSheet[$iInc][19]
		$sConnected = $aSheet[$iInc][9]
	Else
		$sType = $aSheet[$iInc][3]
		$sTag = $aSheet[$iInc][5]
		$sStatus = $aSheet[$iInc][25]

		$sSearch = $sType & ' ' & $sTag
		$sConnected = $aSheet[$iInc][9]
	EndIf

	If $sStatus = 'Deleted' Then ContinueLoop
	If $sConnected <> '' Then ContinueLoop


;~ 	If String(Number($sTag)) <> $sTag Then ContinueLoop


	$bFound = 0

	ConsoleWrite(@CRLF & '---->' & $sSearch)

	ControlSetText($sWinTitlePID, '', '[CLASS:Edit; INSTANCE:2]', $sSearch)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:16]')
	Sleep(100)

	For $x = 1 To 200
		$sResults = ControlGetText($sWinTitlePID, '', '[CLASS:Static; INSTANCE:11]')
		If $sResults <> '0 document(s) with 0 instance(s)' Then

			$bFound = 1
			ExitLoop
		ElseIf $x = 200 Then
			$bFound = 0
		EndIf

		Sleep(10)
	Next


	Sleep(1000)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:17]')
	Sleep(100)


	$sConnectedTo = ConnectedToPopup()

	If StringInStr($sSheetName, 'Motor') Then
		$oWorkbook.Sheets($sSheetName).Range('J' & $iInc + 1).Value = $sConnectedTo
	Else
		$oWorkbook.Sheets($sSheetName).Range('J' & $iInc + 1).Value = $sConnectedTo
	EndIf

	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
	Sleep(100)

	WinActivate($sWinTitlePID)

Next

Func ConnectedToPopup()
	; Create the popup window
	Local $hwnd = GUICreate("Select supply", 300, 100)

	; Create the dropdown list
	Local $combo = GUICtrlCreateCombo("", 10, 10, 280, 20)
	$sOptions = _ArrayToString($aOptions)
	GUICtrlSetData($combo, $sOptions, $sLastSelected) ; Set the options and default value

	; Add a "OK" button to close the window
	Local $okButton = GUICtrlCreateButton("OK", 120, 50, 60, 30)
	GUICtrlSetState($okButton, $GUI_FOCUS) ; Set the focus to the OK button

	; Show the window and wait for the user to close it
	GUISetState(@SW_SHOW, $hwnd)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $okButton
				ExitLoop
		EndSwitch
	WEnd

	; Get the selected option and return it
	Local $selectedOption = GUICtrlRead($combo)
	GUIDelete($hwnd)
	$sLastSelected = $selectedOption
	$iIndex = _ArraySearch($aOptions, $sLastSelected)
	If $iInc < 0 Then _ArrayAdd($aOptions, $sLastSelected)
	Return $selectedOption
EndFunc   ;==>ConnectedToPopup

Func _Exit()
	Exit
EndFunc   ;==>_Exit
