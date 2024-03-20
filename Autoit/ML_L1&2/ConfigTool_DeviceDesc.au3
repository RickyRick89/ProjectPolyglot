#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sMIWorkbookPath = "X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Motor And Instrument List Rev 0.1.xlsx"

$sConfigToolWorkbookPath = "X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\ConfigTools\DIST_ConfigTool_20230407.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Cutting_ConfigTool_20220718.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Dist_ConfigTool_20220718.xls"


$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
If Not IsObj($oMIWorkbook) Then
	$oExcel = _Excel_Open()
	$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
Else
	$oExcel = $oMIWorkbook.Application
EndIf

$aMotorsSheet = _Excel_RangeRead($oMIWorkbook, 'Motor List')
For $x = 1 To UBound($aMotorsSheet) - 1
	$aMotorsSheet[$x][1] = StringReplace($aMotorsSheet[$x][1], '-', '')
Next

$aInstSheet = _Excel_RangeRead($oMIWorkbook, 'Instrument List')
For $x = 1 To UBound($aInstSheet) - 1
	$aInstSheet[$x][2] = StringReplace($aInstSheet[$x][2], '-', '')
Next

$oConfigToolWorkbook = _Excel_BookAttach($sConfigToolWorkbookPath)
If Not IsObj($oConfigToolWorkbook) Then
	$oExcel = _Excel_Open()
	$oConfigToolWorkbook = _Excel_BookOpen($oExcel, $sConfigToolWorkbookPath)
Else
	$oExcel = $oConfigToolWorkbook.Application
EndIf

$aSheetList = _Excel_SheetList($oConfigToolWorkbook)

For $iSheet = 4 To UBound($aSheetList) - 1
;~ _ArrayDisplay($aSheetList)
	$aSheet = _Excel_RangeRead($oConfigToolWorkbook, $aSheetList[$iSheet][0])
	ConsoleWrite(@CRLF & '===> Sheet Name = ' & $aSheetList[$iSheet][0])

	If $aSheet[9][2] = '' Then ContinueLoop

	$iDvcCollumn = 0
	$iTagCollumn = 0
	$iAreaCollumn = 0
	$iDescCollumn = 0
	For $iCollumn = 4 To UBound($aSheet, 2) - 1
		If $aSheet[6][$iCollumn] <> '.Cfg_' Then ContinueLoop

		If $aSheet[7][$iCollumn] = 'Label' Then
			$iDvcCollumn = $iCollumn
		EndIf
		If $aSheet[7][$iCollumn] = 'Tag' Then
			$iTagCollumn = $iCollumn
		EndIf
		If $aSheet[7][$iCollumn] = 'Area' Then
			$iAreaCollumn = $iCollumn
		EndIf
		If $aSheet[7][$iCollumn] = 'Desc' Then
			$iDescCollumn = $iCollumn
		EndIf
	Next
	If $iDescCollumn = 0 And $iDvcCollumn = 0 Then
		ContinueLoop
	EndIf
	ConsoleWrite(@CRLF & '$iDvcCollumn= ' & $iDvcCollumn & @CRLF & '$iTagCollumn= ' & $iTagCollumn & @CRLF & '$iAreaCollumn= ' & $iAreaCollumn & @CRLF & '$iDescCollumn= ' & $iDescCollumn)


;~ _ArrayDisplay($aSheet)
;~ Exit
	For $iRow = 9 To UBound($aSheet) - 1
		$sTagName = StringReplace($aSheet[$iRow][2], '_FTAE', '')
		$aTagSplit = StringSplit($aSheet[$iRow][2], '_')
		If IsArray($aTagSplit) Then
			$sTagName = $aTagSplit[1]
		Else
			MsgBox(0, '', 'Tag Issue')
			Exit
		EndIf
		ConsoleWrite(@CRLF & '++++++++> ' & $sTagName)
		If $sTagName = '' Then ExitLoop
		$iDescIndex = _ArraySearch($aMotorsSheet, $sTagName, 0, 0, 0, 0, 1, 1)
		If $iDescIndex < 0 Then
			$iDescIndex = _ArraySearch($aInstSheet, $sTagName, 0, 0, 0, 0, 1, 2)
			If $iDescIndex < 0 Then
				ConsoleWrite(@CRLF & '~~~~~~~~~~~> Description Not Found')
				ContinueLoop
			Else
				$sDescription = $aInstSheet[$iDescIndex][6]
			EndIf
		Else
			$sDescription = $aMotorsSheet[$iDescIndex][2]
		EndIf

		If $iDvcCollumn <> 0 Then
			$aSheet[$iRow][$iDvcCollumn] = $sTagName
		EndIf
		If $iTagCollumn <> 0 Then
			$aSheet[$iRow][$iTagCollumn] = $sTagName
		EndIf
		If $iAreaCollumn <> 0 Then
			$aSheet[$iRow][$iAreaCollumn] = 'Process'
		EndIf
		If $iDescCollumn <> 0 Then
			$aSheet[$iRow][$iDescCollumn] = $sDescription
		EndIf

	Next
	For $x = 0 To 3
		_ArrayColDelete($aSheet, 0)
	Next
	For $x = 0 To 8
		_ArrayDelete($aSheet, 0)
	Next

;~ 	_ArrayDisplay($aSheet)
	$aSheet = _Excel_RangeWrite($oConfigToolWorkbook, $aSheetList[$iSheet][0], $aSheet, 'E10')


Next

;OPC_Control.cmdReadFromCLX


Func _Exit()
	Exit
EndFunc   ;==>_Exit

