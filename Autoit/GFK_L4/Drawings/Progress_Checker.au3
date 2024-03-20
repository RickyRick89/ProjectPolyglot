#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <String.au3>

;[INST_NAME],[DESCRIPTION],[JB_NAME],[NODE_NUM],[INPUT_NUM],[OUTPUT_NUM],[ASM_NAME],[TRUNK_NUM]

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Global $sLastSelected = 'CLXL4B_ASI01_JB01'
Global $aOptions[1] = [$sLastSelected]
Global $iSheetX = 29.9038
Global $iSheetY = 21.25
Global $iSheetXInc = 31.9038
Global $iSheetYInc = -22.25
Global $iSheetDeviceXOffset = 6.125
Global $iSheetDeviceXRange = 18.985

Global $aTrunkYStart[2] = [-66.75, -155.75]
Global $aSheetRowOffset[2] = [-1, -11]

Global $sFirstPageTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\First_Page.scr"
Global $sPLCPanelTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\PLC_Panel.scr"
Global $sUseFilesRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Sandbox\UseFiles\'

Global $sNewFilePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Sandbox\New_File.dwg"
Global $sFirstScriptPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\First_Page.scr"
Global $sRemotePanelPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\Remote_Panel.scr"
Global $sTempPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\Temporary\Temp.scr"

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Motor And Instrument List Rev 1.xlsx"

$sFileTime = FileGetTime($sNewFilePath, $FT_MODIFIED, $FT_STRING)
$dtFileTime = _StringInsert(_StringInsert(_StringInsert(_StringInsert(_StringInsert($sFileTime, ' ', -6), ':', -4), ':', -2), '/', 6), '/', 4)
;~ ConsoleWrite("-> File Time: " & $dtFileTime & @CRLF)
$iTimeDiff = _DateDiff('s', $dtFileTime, _NowCalc())
;~ ConsoleWrite("-> File Age: " & $iTimeDiff & " Seconds" & @CRLF)

While 1
	$sFileTime = FileGetTime($sNewFilePath, $FT_MODIFIED, $FT_STRING)
	$dtFileTime = _StringInsert(_StringInsert(_StringInsert(_StringInsert(_StringInsert($sFileTime, ' ', -6), ':', -4), ':', -2), '/', 6), '/', 4)
	$iTimeDiff = _DateDiff('s', $dtFileTime, _NowCalc())

	If $iTimeDiff > 600 Then
		MsgBox(0, '', 'Check on script progress')
	EndIf
	Sleep(1000)
WEnd

Func _Exit()
	Exit
EndFunc   ;==>_Exit
