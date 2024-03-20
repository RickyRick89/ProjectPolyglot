#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Motor And Instrument List Rev 0.1.xlsx"

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
;~ _ArrayDisplay($aTagSheet)

	For $iRow = 1 To UBound($aMISheet) - 1
		ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)

		If $sMISheetName = 'Motor List' Then
			$sName = StringReplace($aMISheet[$iRow][1], '-', '')
			$sDesc = $aMISheet[$iRow][2]
			$sUnit = $aMISheet[$iRow][15]
			$sUnitDesc = $aMISheet[$iRow][16]
			$sLine = $aMISheet[$iRow][14]
			$sType = $aMISheet[$iRow][8]
		ElseIf $sMISheetName = 'Instrument List' Then
			$sName = StringReplace($aMISheet[$iRow][2], '-', '')
			$sDesc = $aMISheet[$iRow][6]
			$sUnit = $aMISheet[$iRow][22]
			$sUnitDesc = $aMISheet[$iRow][24]
			$sLine = $aMISheet[$iRow][21]
			$sType = $aMISheet[$iRow][23]
		EndIf

		$sPLCWinTitle = 'Logix Designer - FMR_Dock'

;~ If $sPLCWinTitle = 'Logix Designer - CA_PROC_5A' Then ContinueLoop
;~ If $sPLCWinTitle = 'Logix Designer - CA_PROC_5B' Then ContinueLoop

		If $sType = 'YaskawaVSD' Or $sType = 'Motor' Or $sType = 'PF52x' Then
			$sProgram = $sUnit & '_Motors'
		ElseIf $sType = 'AIn' Or $sType = 'AOut' Then
			$sProgram = $sUnit & '_Ana_Inst'
		ElseIf $sType = 'DIn' Or $sType = 'DOut' Or $sType = 'ValveSO' Then
			$sProgram = $sUnit & '_Dig_Inst'
		Else
			MsgBox(0, $sType, 'Invalid Type')
			Exit
		EndIf

		ConsoleWrite(@CRLF & '===========> $sType = ' & $sName)
		ConsoleWrite(@CRLF & '===========> $sType = ' & $sType)
		ConsoleWrite(@CRLF & '===========> $sProgram = ' & $sProgram)

		$sImportFilePath = 'X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Line' & $sLine & '\' & $sUnit & '\' & $sName & '.L5X'


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		WinActivate($sPLCWinTitle)
;~ 		Sleep(500)

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
		Sleep(1000)

		$iTreeIndex = _ArraySearch($aText, $sProgram)
		If $iTreeIndex < 0 Then
			MsgBox(0, $sProgram, 'Program Not Found')
			Exit
		EndIf
		_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$iTreeIndex])
		_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$iTreeIndex], 'right')
		Sleep(500)
		Send('{down}{right}{up}{enter}')

		If Not WinWait('Import Routine', '', 10) Then
			ConsoleWrite(@CRLF & '------->>>>>>>> Exit at Import Routine' & @CRLF)
			Exit
		EndIf
		ControlSetText('Import Routine', '', '[CLASS:Edit; INSTANCE:1]', $sImportFilePath)
		ControlClick('Import Routine', '', '[CLASS:Button; INSTANCE:2]')
		If Not WinWait('Import Configuration - ', '', 30) Then
			If WinExists('Logix Designer', 'Unable to parse the L5X content.') Then
				WinKill('Logix Designer', 'Unable to parse the L5X content.')
				Sleep(200)
				WinKill('Import Routine')
				ConsoleWrite(@CRLF & '>>>>>>>> Skipping Due to Error' & @CRLF)
				ContinueLoop
			EndIf
			ConsoleWrite(@CRLF & '------->>>>>>>> Exit at Import Configuration' & @CRLF)
			Exit
		EndIf
		Sleep(100)
		ControlClick('Import Configuration - ', '', '[CLASS:Button; INSTANCE:7]')
		WinWait('Online Options','',3)
		ControlClick('Online Options','','[CLASS:Button; INSTANCE:6]')
		ControlClick('Online Options','','[CLASS:Button; INSTANCE:1]')
		Sleep(500)
		WinWaitClose('Performing Import')


;~ 		Exit

	Next
EndFunc   ;==>_Routine_Import

Func _Exit()
	Exit
EndFunc   ;==>_Exit

