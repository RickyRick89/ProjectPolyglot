#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


$sMIWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\VFD_Sync\Motors.xlsx"

Local $aPLCs[4] = [3, 'CA_PROC_5A', 'CA_PROC_5B', 'CA_DIST_5']

$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
If Not IsObj($oMIWorkbook) Then
	$oExcel = _Excel_Open()
	$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
Else
	$oExcel = $oMIWorkbook.Application
EndIf

For $iInc = 6 To UBound($aPLCs) - 1
	$sPLCWinTitle = $aPLCs[$iInc]

	$aSheet = _Excel_RangeRead($oMIWorkbook, $sPLCWinTitle)

	_Excel_SheetAdd($oMIWorkbook, Default, False, 1, $sPLCWinTitle)
	_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, 'Name', 'A1')
	_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, 'IP', 'B1')
	_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, 'FLA', 'C1')
	_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, 'Type', 'D1')


	WinActivate($sPLCWinTitle)
	Sleep(500)

	Local $aText[1], $aHandles[1]


	$hTreeView = ControlGetHandle($sPLCWinTitle, '', '[CLASS:SysTreeView32; INSTANCE:3]')
	$hItem = _GUICtrlTreeView_GetFirstItem($hTreeView)
	Local $a
	While 1
		$sText = _GUICtrlTreeView_GetText($hTreeView, $hItem)
		ConsoleWrite(@CRLF & '-->' & $hItem & '####>' & $sText)
		$iHandleIndex = _ArraySearch($aHandles, $hItem)
		If $iHandleIndex >= 0 Then ExitLoop
		_ArrayAdd($aText, $sText)
		_ArrayAdd($aHandles, $hItem)
;~ 	MsgBox(0, '', $sText)
		$hItem = _GUICtrlTreeView_GetNext($hTreeView, $hItem)
	WEnd
;~ ReDim $aText[_ArraySearch($aText, 'Motion Groups')]
;~ _ArrayDisplay($aText)
;~ Exit


	WinActivate($sPLCWinTitle)
	$iExcelRow = UBound($aSheet) + 1
	For $x = 1 To UBound($aText) - 1
		$sItemText = $aText[$x]
		ClipPut('')

		$bFound = 0
		For $y = 1 To UBound($aSheet) - 1
			If StringInStr($sItemText, $aSheet[$y][0]) Then
				ConsoleWrite(@CRLF & '--> Already Found - ' & $aSheet[$y][0])
				$bFound = 1
				ExitLoop
			EndIf
		Next

		If $bFound Then ContinueLoop

		If StringInStr($sItemText, '193-ECM-ETR') Then
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$x])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$x], 'left', False, 2)
			While 1
				If StringInStr(ControlGetText($sPLCWinTitle, '', '[CLASS:AfxFrameOrView140u; INSTANCE:1]'), '193-ECM-ETR') Then ExitLoop
			WEnd
			Sleep(250)
			$sName = ControlGetText($sPLCWinTitle, '', '[CLASS:Edit; INSTANCE:1]')
			$sIP = ControlGetText($sPLCWinTitle, '', '[CLASS:SysIPAddress32; INSTANCE:1]')
			ConsoleWrite(@CRLF & '--> ' & $sName & ' - ' & $sIP)

			ControlSend($sPLCWinTitle, '', '[CLASS:SysTreeView32; INSTANCE:1]', '{Down 6}')
			Sleep(250)
			$sFLA = ControlGetText($sPLCWinTitle, '', '[CLASS:Edit; INSTANCE:19]')
			$sType = 'E300'
			WinActivate($sPLCWinTitle)
			ControlSend($sPLCWinTitle, '', '', '{Esc}')

			While 1
				If Not StringInStr(ControlGetText($sPLCWinTitle, '', '[CLASS:AfxFrameOrView140u; INSTANCE:1]'), '193-ECM-ETR') Then ExitLoop
			WEnd

			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sName, 'A' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sIP, 'B' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sFLA, 'C' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sType, 'D' & $iExcelRow)
			$iExcelRow += 1

		ElseIf StringInStr($sItemText, 'PowerFlex 525') Then
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$x])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$x], 'left', False, 2)
			While 1
				If StringInStr(ControlGetText($sPLCWinTitle, '', '[CLASS:AfxFrameOrView140u; INSTANCE:1]'), 'PowerFlex 525') Then ExitLoop
			WEnd
			Sleep(250)
			$sName = ControlGetText($sPLCWinTitle, '', '[CLASS:Edit; INSTANCE:1]')
			$sIP = ControlGetText($sPLCWinTitle, '', '[CLASS:SysIPAddress32; INSTANCE:1]')
			ConsoleWrite(@CRLF & '--> ' & $sName & ' - ' & $sIP)

			ControlSend($sPLCWinTitle, '', '[CLASS:SysTabControl32; INSTANCE:1]', '{Tab 8}')
			ControlSend($sPLCWinTitle, '', '[CLASS:SysTabControl32; INSTANCE:1]', '{Right 4}')
			MouseClick('left', 2512, 324, 1, 0)
			WinWait('Parameters -  Port 0')
			ControlSend('Parameters -  Port 0', '', '[NAME:textBoxParameterFilterValue]', 'FLA')
			Sleep(1000)
			ControlSend('Parameters -  Port 0', '', '[CLASS:WindowsForms10.Window.8.app.0.3c4abcc_r75_ad1; INSTANCE:8]', '^{c}')
			Sleep(1000)
			$sFLA = ClipGet()
			$aInfo = StringSplit($sFLA, @TAB)
			If IsArray($aInfo) And UBound($aInfo) > 4 Then
				$sFLA = $aInfo[4]
			Else
				$sFLA = InputBox('FLA', 'FLA')
			EndIf
			$sType = 'PF525'
			WinActivate($sPLCWinTitle)
			ControlSend($sPLCWinTitle, '', '', '{Esc}')
			While 1
				If Not StringInStr(ControlGetText($sPLCWinTitle, '', '[CLASS:AfxFrameOrView140u; INSTANCE:1]'), 'PowerFlex 525') Then ExitLoop
			WEnd

			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sName, 'A' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sIP, 'B' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sFLA, 'C' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sType, 'D' & $iExcelRow)
			$iExcelRow += 1
		ElseIf StringInStr($sItemText, 'PowerFlex 75') Then
			_GUICtrlTreeView_SelectItem($hTreeView, $aHandles[$x])
			_GUICtrlTreeView_ClickItem($hTreeView, $aHandles[$x], 'left', False, 2)
			While 1
				If StringInStr(ControlGetText($sPLCWinTitle, '', '[CLASS:AfxFrameOrView140u; INSTANCE:1]'), 'PowerFlex 75') Then ExitLoop
			WEnd
			Sleep(250)
			$sName = ControlGetText($sPLCWinTitle, '', '[CLASS:Edit; INSTANCE:1]')
			$sIP = ControlGetText($sPLCWinTitle, '', '[CLASS:SysIPAddress32; INSTANCE:1]')

			ConsoleWrite(@CRLF & '--> ' & $sName & ' - ' & $sIP)

			ControlSend($sPLCWinTitle, '', '[CLASS:SysTabControl32; INSTANCE:1]', '{Tab 8}')
			ControlSend($sPLCWinTitle, '', '[CLASS:SysTabControl32; INSTANCE:1]', '{Right 4}')
			MouseClick('left', 2361, 337, 2, 0)
			WinWait('Parameter List - PowerFlex 75')
			Sleep(10000)
			WinActivate('Parameter List - PowerFlex 75')
			ControlSend('Parameter List - PowerFlex 75', '', '', '{tab}')
			ControlSend('Parameter List - PowerFlex 75', '', '', '{tab}')
			ControlSend('Parameter List - PowerFlex 75', '', '', '{tab}')
			ControlSend('Parameter List - PowerFlex 75', '', '[CLASS:GXWND; INSTANCE:1]', '{down 23}')
			ControlSend('Parameter List - PowerFlex 75', '', '[CLASS:GXWND; INSTANCE:1]', '{right 2}')
			ControlSend('Parameter List - PowerFlex 75', '', '[CLASS:GXWND; INSTANCE:1]', '^{c}')
			Sleep(1000)
			$sFLA = ClipGet()
			If StringInStr(ControlGetText($sPLCWinTitle, '', '[CLASS:AfxFrameOrView140u; INSTANCE:1]'), 'PowerFlex 753') Then
				$sType = 'PF753'
			Else
				$sType = 'PF755'
			EndIf
			ControlSend('Parameter List - PowerFlex 75', '', '', '{esc}')
			WinActivate($sPLCWinTitle)
			ControlSend($sPLCWinTitle, '', '', '{Esc}')
			While 1
				If Not StringInStr(ControlGetText($sPLCWinTitle, '', '[CLASS:AfxFrameOrView140u; INSTANCE:1]'), 'PowerFlex 75') Then ExitLoop
			WEnd

			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sName, 'A' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sIP, 'B' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sFLA, 'C' & $iExcelRow)
			_Excel_RangeWrite($oMIWorkbook, $sPLCWinTitle, $sType, 'D' & $iExcelRow)
			$iExcelRow += 1
		EndIf


	Next
Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit

