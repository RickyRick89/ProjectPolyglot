#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_M&I.xlsx"

$sTagWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_Tag_Generator.xlsm"
$sTagSheetName = 'Tags'

_Routine_Import('Motors', False)
;~ _Routine_Import('Instruments', True)

Func _Routine_Import($sMISheetName, $bSkipExisting = True)
	$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
	If Not IsObj($oMIWorkbook) Then
		$oExcel = _Excel_Open()
		$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
	Else
		$oExcel = $oMIWorkbook.Application
	EndIf

	$aMISheet = _Excel_RangeRead($oMIWorkbook, $sMISheetName)

	$oTagWorkbook = _Excel_BookAttach($sTagWorkbookPath)
	If Not IsObj($oTagWorkbook) Then
		$oExcel = _Excel_Open()
		$oTagWorkbook = _Excel_BookOpen($oExcel, $sTagWorkbookPath)
	Else
		$oExcel = $oTagWorkbook.Application
	EndIf

	$aTagSheet = _Excel_RangeRead($oTagWorkbook, $sTagSheetName, Default, 1, True)

;~ _ArrayDisplay($aMISheet)
;~ _ArrayDisplay($aTagSheet)

	For $iRow = 1 To UBound($aMISheet) - 1
		ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)


		If $sMISheetName = 'Motors' Then
			$sName = StringReplace($aMISheet[$iRow][0], '-', '')
			$sDesc = $aMISheet[$iRow][3]
			$sUnit = $aMISheet[$iRow][4]
			$sLine = $aMISheet[$iRow][5]
			$sArea = $aMISheet[$iRow][6]
			$sType = $aMISheet[$iRow][11]
		ElseIf $sMISheetName = 'Instruments' Then
			$sName = StringReplace($aMISheet[$iRow][0], '-', '')
			$sDesc = $aMISheet[$iRow][4]
			$sUnit = $aMISheet[$iRow][8]
			$sLine = $aMISheet[$iRow][9]
			$sArea = $aMISheet[$iRow][10]
			$sType = $aMISheet[$iRow][7]
		EndIf
		$iTagIndex = _ArraySearch($aTagSheet, $sName, 0, 0, 0, 0, 1, 6)
		If $iTagIndex < 0 Then
			MsgBox(0, '', 'Device not found on TagList: ' & $sName)
			ContinueLoop
;~ 		Exit
		EndIf

		$sCLXTagName = $aTagSheet[$iTagIndex][11]
		Switch $sUnit
			Case 'L5_Blancher1'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_Blancher2'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_BlnDschPmpLoop'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_SAPP'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5B'
			Case 'L5_Tote'
				$sPLCWinTitle = 'Logix Designer - CA_DIST_5'
			Case 'L5_WaterKnife'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_CGd'
				$sPLCWinTitle = 'Logix Designer - CA_DIST_5'
			Case Else
				MsgBox(0, '', 'Invalid Unit')
				Exit
		EndSwitch

;~ If $sPLCWinTitle = 'Logix Designer - CA_PROC_5A' Then ContinueLoop
;~ If $sPLCWinTitle = 'Logix Designer - CA_PROC_5B' Then ContinueLoop

		If $sType = 'VFD' Or $sType = 'M2S' Then
			$sProgram = $sUnit & '_Motors'
		ElseIf $sType = 'AIn' Or $sType = 'AOut' Then
			$sProgram = $sUnit & '_Ana_Inst'
		ElseIf $sType = 'DIn' Or $sType = 'DOut' Or $sType = 'V2S' Then
			$sProgram = $sUnit & '_Dig_Inst'
		Else
			MsgBox(0, '', 'Invalid Type')
			Exit
		EndIf

		ConsoleWrite(@CRLF & '===========> $sType = ' & $sType)
		ConsoleWrite(@CRLF & '===========> $sProgram = ' & $sProgram)

		$sImportFilePath = 'X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\' & $sUnit & '\' & $sName & '.L5X'


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		WinActivate($sPLCWinTitle)
		Sleep(500)

		Local $aText[1], $aHandles[1]

		$hTreeView = ControlGetHandle($sPLCWinTitle, '', '[CLASS:SysTreeView32; INSTANCE:3]')
		$hItem = _GUICtrlTreeView_GetFirstItem($hTreeView)
		While 1
			$sText = _GUICtrlTreeView_GetText($hTreeView, $hItem)
			If StringLen($sText) < 3 Then ExitLoop
			_ArrayAdd($aText, $sText)
			_ArrayAdd($aHandles, $hItem)
;~ 	MsgBox(0, '', $sText)
			$hItem = _GUICtrlTreeView_GetNext($hTreeView, $hItem)
		WEnd
		ReDim $aText[_ArraySearch($aText, 'Motion Groups')]
;~ 	_ArrayDisplay($aText)

		If _ArraySearch($aText, $sName) >= 0 And $bSkipExisting Then
			ConsoleWrite(@CRLF & '++++++> ' & $sName & ' Already Exists')
			ContinueLoop
		EndIf

		$iTreeIndex = _ArraySearch($aText, $sProgram)
		If $iTreeIndex < 0 Then
			MsgBox(0, $sProgram, 'Program Not Found')
			Exit
		EndIf
		_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iTreeIndex])
		_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iTreeIndex], 'right')
		Sleep(500)
		Send('{down}{right}{up}{enter}')

		WinWait('Import Routine')
		ControlSetText('Import Routine', '', '[CLASS:Edit; INSTANCE:1]', $sImportFilePath)
		ControlClick('Import Routine', '', '[CLASS:Button; INSTANCE:2]')
		WinWait('Import Configuration - ')
		Sleep(100)
		ControlClick('Import Configuration - ', '', '[CLASS:Button; INSTANCE:13]')
		Sleep(500)
		WinWaitClose('Performing Import')

;~ 		Exit

	Next
EndFunc   ;==>_Routine_Import

Func _Exit()
	Exit
EndFunc   ;==>_Exit

