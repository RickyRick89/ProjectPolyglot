#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')
$iPID = Run("C:\Program Files (x86)\AutoIt3\AutoIt3.exe W:\My_Scripts\GFK_L4\PopupCloser.au3")

$sConfigToolWorkbookPath = "W:\My_Scripts\GFK_L4\Audit\ConfigTools\L4_PROCESS_20230909-ConfigTools.xls"
;~ $sConfigToolWorkbookPath = "X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\ConfigTools\GFK_L4_ConfigTool_20230517.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Drying_ConfigTool_20220712.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Cutting_ConfigTool_20220718.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Dist_ConfigTool_20220718.xls"

$oConfigToolWorkbook = _Excel_BookAttach($sConfigToolWorkbookPath)
If Not IsObj($oConfigToolWorkbook) Then
	$oExcel = _Excel_Open()
	$oConfigToolWorkbook = _Excel_BookOpen($oExcel, $sConfigToolWorkbookPath)
Else
	$oExcel = $oConfigToolWorkbook.Application
EndIf
ConsoleWrite(@CRLF & '**> Workbook Opened')
$aSheets = _Excel_SheetList($oConfigToolWorkbook)
ConsoleWrite(@CRLF & '**> Sheet List Read')

Local $aBlank[200][200]

For $iSheet = 4 To UBound($aSheets) - 1
;~ _ArrayDisplay($aSheets)
	$oConfigToolWorkbook.Sheets($iSheet + 1).Select()
	$oSheet = $oConfigToolWorkbook.Sheets($iSheet + 1)
	$oConfigToolWorkbook.Sheets($iSheet + 1).Range('E10').Select()
	_Excel_RangeWrite($oConfigToolWorkbook, $oSheet, $aBlank, 'E10')

	If $oConfigToolWorkbook.Sheets($iSheet + 1).Range('C10').Value = '' Then ContinueLoop

	$oExcel.Run('OPC_Control.cmdReadFromCLX')

Next

_Exit()

Func _Exit()
	ProcessClose($iPID)
	Exit
EndFunc   ;==>_Exit

