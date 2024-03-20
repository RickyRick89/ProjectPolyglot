#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


$sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\HBF_Files\System_Integrator\ConfigTool_20230130.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Cutting_ConfigTool_20220718.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Dist_ConfigTool_20220718.xls"



$oConfigToolWorkbook = _Excel_BookAttach($sConfigToolWorkbookPath)
If Not IsObj($oConfigToolWorkbook) Then
	$oExcel = _Excel_Open()
	$oConfigToolWorkbook = _Excel_BookOpen($oExcel, $sConfigToolWorkbookPath)
Else
	$oExcel = $oConfigToolWorkbook.Application
EndIf

$aSheetList = _Excel_SheetList($oConfigToolWorkbook)

Local $aDesc[1][3] = [['Tag', 'Eq', 'Desc']]

For $iSheet = 2 To UBound($aSheetList) - 1
	ConsoleWrite(@CRLF & '++>' & $aSheetList[$iSheet][0])
;~ _ArrayDisplay($aSheetList)
	$aSheet = _Excel_RangeRead($oConfigToolWorkbook, $aSheetList[$iSheet][0])

	$iDvcCollumn = 0
	$iDescCollumn = 0
	For $iCollumn = 4 To UBound($aSheet, 2) - 1
		If $aSheet[7][$iCollumn] = 'Label' Then
			$iDvcCollumn = $iCollumn
		EndIf
		If $aSheet[7][$iCollumn] = 'Desc' Then
			$iDescCollumn = $iCollumn
		EndIf
	Next
	If $iDescCollumn = 0 And $iDvcCollumn = 0 Then
		ContinueLoop
	EndIf
	ConsoleWrite(@CRLF & '$iDvcCollumn= ' & $iDvcCollumn & @CRLF & '$iDescCollumn= ' & $iDescCollumn)

	For $iRow = 9 To UBound($aSheet) - 1
		If $aSheet[$iRow][2] = '' Then ExitLoop
		ConsoleWrite(@CRLF & '-->' & $aSheet[$iRow][2])
		_ArrayAdd($aDesc, $aSheet[$iRow][2] & '|' & StringRegExp($aSheet[$iRow][2],'/d') & '|' & $aSheet[$iRow][$iDescCollumn])
	Next


Next
_ArrayDisplay($aDesc)

;OPC_Control.cmdReadFromCLX


Func _Exit()
	Exit
EndFunc   ;==>_Exit

