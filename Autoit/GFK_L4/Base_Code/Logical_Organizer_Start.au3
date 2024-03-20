#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


Global $aUnits[1]

$sTemplatePath = 'X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "W:\My_Scripts\GFK_L4\Base_Code\Motor And Instrument List Rev 1.xlsx"

_Routine_Import('Motor List')
_Routine_Import('Instrument List')

Func _Routine_Import($sMISheetName, $bSkipExisting = True)
	$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
	If Not IsObj($oMIWorkbook) Then
		$oExcel = _Excel_Open()
		$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
	Else
		$oExcel = $oMIWorkbook.Application
	EndIf

	$aMISheet = _Excel_RangeRead($oMIWorkbook, $sMISheetName)


;~ _ArrayDisplay($aMISheet)
;~ Return

	For $iRow = 1 To UBound($aMISheet) - 1
		ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)

		If $sMISheetName = 'Motor List' Then
			$sName = StringReplace($aMISheet[$iRow][1], '-', '')
			$sDesc = $aMISheet[$iRow][2]
			$sUnit = $aMISheet[$iRow][16]
			$sUnitDesc = $aMISheet[$iRow][17]
			$sLine = $aMISheet[$iRow][15]
			$sType = $aMISheet[$iRow][8]
		ElseIf $sMISheetName = 'Instrument List' Then
			$sName = StringReplace($aMISheet[$iRow][2], '-', '')
			$sDesc = $aMISheet[$iRow][6]
			$sUnit = $aMISheet[$iRow][22]
			$sUnitDesc = $aMISheet[$iRow][24]
			$sLine = $aMISheet[$iRow][21]
			$sType = $aMISheet[$iRow][23]
		EndIf
		If _ArraySearch($aUnits, $sUnit) >= 0 Then ContinueLoop
		If $sUnit = 'OEM' Or $sUnit = '' Or $sType = 'OEM' Or $sType = 'EXISTING' Then ContinueLoop

		Switch $sLine
			Case '4'
				$sPLCWinTitle = 'Logix Designer - GFK_L04_CLX'
			Case Else
				MsgBox(0, '', 'Invalid Line')
				Exit
		EndSwitch

;~ If $sPLCWinTitle = 'Logix Designer - CA_PROC_5A' Then ContinueLoop
;~ If $sPLCWinTitle = 'Logix Designer - CA_PROC_5B' Then ContinueLoop

		If $sType = 'PF52x' Or $sType = 'MotorE300' Or $sType = 'PF755' Or $sType = 'MotorRev' Then
			$sProgram = $sUnit & '_Motors'
		ElseIf $sType = 'AIn' Or $sType = 'AOut' Then
			$sProgram = $sUnit & '_Ana_Inst'
		ElseIf $sType = 'DIn' Or $sType = 'DOut' Or $sType = 'ValveSO' Then
			$sProgram = $sUnit & '_Dig_Inst'
		Else
			MsgBox(0, $sType, 'Invalid Type')
			Exit
		EndIf

		ConsoleWrite(@CRLF & '===========> $sType = ' & $sType)
		ConsoleWrite(@CRLF & '===========> $sProgram = ' & $sProgram)

		$sImportFilePath = 'X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\' & $sLine & '\' & $sUnit & '\' & $sName & '.L5X'


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		WinActivate($sPLCWinTitle)
		Sleep(500)
;~ 		ControlSend($sPLCWinTitle, '', '', '{alt down}{4}{alt up}')
		Local $aText[1], $aHandles[1], $hTreeView
		_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)

		If _ArraySearch($aText, $sUnit) < 0 Then
			_ArrayAdd($aUnits, $sUnit)
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[1])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[1], 'right')
			Sleep(500)
			Send('{down}{right}{down 3}{enter}')

			WinWait('New Program')
			ControlSetText('New Program', '', '[CLASS:Edit; INSTANCE:1]', $sUnit)
			ControlClick('New Program', '', '[CLASS:Button; INSTANCE:5]')

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit)
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{enter}')

			WinWait('New Program')
			ControlSetText('New Program', '', '[CLASS:Edit; INSTANCE:1]', $sUnit & '_Motors')
			ControlClick('New Program', '', '[CLASS:Button; INSTANCE:5]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit & '_Motors')
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{down 4}{enter}')

			WinWait('New Routine')
			ControlSetText('New Routine', '', '[CLASS:Edit; INSTANCE:1]', 'Main')
			ControlSetText('New Routine', '', '[CLASS:ComboBox; INSTANCE:1]', 'Ladder Diagram')
			ControlClick('New Routine', '', '[CLASS:Button; INSTANCE:2]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit)
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{enter}')

			WinWait('New Program')
			ControlSetText('New Program', '', '[CLASS:Edit; INSTANCE:1]', $sUnit & '_Control')
			ControlClick('New Program', '', '[CLASS:Button; INSTANCE:5]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit & '_Control')
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{down 4}{enter}')

			WinWait('New Routine')
			ControlSetText('New Routine', '', '[CLASS:Edit; INSTANCE:1]', 'Main')
			ControlClick('New Routine', '', '[CLASS:Button; INSTANCE:2]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit)
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{enter}')

			WinWait('New Program')
			ControlSetText('New Program', '', '[CLASS:Edit; INSTANCE:1]', $sUnit & '_Dig_Inst')
			ControlClick('New Program', '', '[CLASS:Button; INSTANCE:5]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit & '_Dig_Inst')
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{down 4}{enter}')

			WinWait('New Routine')
			ControlSetText('New Routine', '', '[CLASS:Edit; INSTANCE:1]', 'Main')
			ControlClick('New Routine', '', '[CLASS:Button; INSTANCE:2]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit)
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{enter}')

			WinWait('New Program')
			ControlSetText('New Program', '', '[CLASS:Edit; INSTANCE:1]', $sUnit & '_Ana_Inst')
			ControlClick('New Program', '', '[CLASS:Button; INSTANCE:5]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit & '_Ana_Inst')
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{down 4}{enter}')

			WinWait('New Routine')
			ControlSetText('New Routine', '', '[CLASS:Edit; INSTANCE:1]', 'Main')
			ControlClick('New Routine', '', '[CLASS:Button; INSTANCE:2]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit)
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{enter}')

			WinWait('New Program')
			ControlSetText('New Program', '', '[CLASS:Edit; INSTANCE:1]', $sUnit & '_PIDs')
			ControlClick('New Program', '', '[CLASS:Button; INSTANCE:5]')
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sleep(500)
			_GetTree($sPLCWinTitle, $aText, $aHandles, $hTreeView)
			$iHandleIndex = _ArraySearch($aText, $sUnit & '_PIDs')
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iHandleIndex])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iHandleIndex], 'right')
			Sleep(500)
			Send('{down}{right}{down 4}{enter}')

			WinWait('New Routine')
			ControlSetText('New Routine', '', '[CLASS:Edit; INSTANCE:1]', 'Main')
			ControlClick('New Routine', '', '[CLASS:Button; INSTANCE:2]')

		EndIf

	Next
EndFunc   ;==>_Routine_Import


Func _GetTree($sPLCWinTitle, ByRef $aText, ByRef $aHandles, ByRef $hTreeView)
	Local $aTemp[1]
	$aText = $aTemp
	$aHandles = $aTemp

	$hTreeView = ControlGetHandle($sPLCWinTitle, '', '[CLASS:SysTreeView32; INSTANCE:1]')
	$hItem = _GUICtrlTreeView_GetFirstItem($hTreeView)

	$bFirst = 0
	$sFirst = '|Ignore|'
	While 1
		$sText = _GUICtrlTreeView_GetText($hTreeView, $hItem)
		If $sText = $sFirst Then ExitLoop
		If Not $bFirst Then
			$sFirst = $sText
			$bFirst = 1
		EndIf
		_ArrayAdd($aText, $sText)
		_ArrayAdd($aHandles, $hItem)
;~ 	MsgBox(0, '', $sText)
		$hItem = _GUICtrlTreeView_GetNext($hTreeView, $hItem)
	WEnd
;~ 		_ArrayDisplay($aText)
EndFunc   ;==>_GetTree

Func _Exit()
	Exit
EndFunc   ;==>_Exit

