#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')
$iPID = Run("C:\Program Files (x86)\AutoIt3\AutoIt3.exe W:\My_Scripts\GFK_L4\PopupCloser.au3")

$sConfigToolWorkbookPath = "X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\ConfigTools\GFK_L4_ConfigTool_20230517.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Cutting_ConfigTool_20220718.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Dist_ConfigTool_20220718.xls"

$oConfigToolWorkbook = _Excel_BookAttach($sConfigToolWorkbookPath)
If Not IsObj($oConfigToolWorkbook) Then
	$oExcel = _Excel_Open()
	$oConfigToolWorkbook = _Excel_BookOpen($oExcel, $sConfigToolWorkbookPath)
Else
	$oExcel = $oConfigToolWorkbook.Application
EndIf

$aSheets = _Excel_SheetList($oConfigToolWorkbook)

For $iSheet = 4 To UBound($aSheets) - 1
;~ _ArrayDisplay($aSheets)
	$oConfigToolWorkbook.Sheets($iSheet + 1).Select()

	$oConfigToolWorkbook.Sheets($iSheet + 1).Range('E10').Select()

	If $oConfigToolWorkbook.Sheets($iSheet + 1).Range('C10').Value = '' Then ContinueLoop

	$oExcel.Run('OPC_Control.cmdSendToCLX')

Next

_Exit()

Func _Exit()
	ProcessClose($iPID)
	Exit
EndFunc   ;==>_Exit

