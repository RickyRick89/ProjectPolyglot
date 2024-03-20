#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Global $bSkipExisting = True

$sTemplatePath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sZoneWorkbookPath = "X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Pallet_Conv_Layout.xlsx"

_Routine_Generator('Zones')

Func _Routine_Generator($sZoneSheetName)

	$oZoneWorkbook = _Excel_BookAttach($sZoneWorkbookPath)
	If Not IsObj($oZoneWorkbook) Then
		$oExcel = _Excel_Open()
		$oZoneWorkbook = _Excel_BookOpen($oExcel, $sZoneWorkbookPath)
	Else
		$oExcel = $oZoneWorkbook.Application
	EndIf

	$aZoneSheet = _Excel_RangeRead($oZoneWorkbook, $sZoneSheetName)

	For $iRow = UBound($aZoneSheet) - 1 To 0 Step -1
		For $iCol = 0 To UBound($aZoneSheet, 2) - 1
			$sCell = $aZoneSheet[$iRow][$iCol]
			If $sCell = '' Or Not StringInStr($sCell, 'Zone') Then ContinueLoop

			$sZone = _GetZone($sCell)
			ConsoleWrite('--->Zone = ' & $sZone & @CRLF)

			$sPLCWinTitle = 'Logix Designer - MOS_PCK_CLX'


			$sImportFilePath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Zones\' & $sZone & '.L5X'

			$sProgram = 'PALLET_CONV_Track'

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

			If _ArraySearch($aText, $sZone) >= 0 And $bSkipExisting Then
				ConsoleWrite('++++++> ' & $sZone & ' Already Exists' & @CRLF)
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
				MsgBox(0, '', 'Error')
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
			Sleep(500)
			WinWaitClose('Performing Import')

;~ 		Exit

		Next
	Next
EndFunc   ;==>_Routine_Generator


Func _GetZone($sCell)
	$sZone = StringLeft($sCell, StringInStr($sCell, '[') - 1)
	Return ($sZone)
EndFunc   ;==>_GetZone

Func _GetDirections($sCell, $sZone)
	$sDirections = StringReplace(StringReplace(StringReplace($sCell, $sZone, ''), '[', ''), ']', '')
	Return ($sDirections)
EndFunc   ;==>_GetDirections

Func _Exit()
	Exit
EndFunc   ;==>_Exit

