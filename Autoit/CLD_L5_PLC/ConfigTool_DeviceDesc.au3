#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sMIWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Jeremys_M&I.xlsx"

$sTagWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Jeremys_Tag_Generator.xlsm"
$sTagSheetName = 'Tags'

$sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Drying_ConfigTool_20220712.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Cutting_ConfigTool_20220718.xls"
;~ $sConfigToolWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Dist_ConfigTool_20220718.xls"


$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
If Not IsObj($oMIWorkbook) Then
	$oExcel = _Excel_Open()
	$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
Else
	$oExcel = $oMIWorkbook.Application
EndIf

$aMotorsSheet = _Excel_RangeRead($oMIWorkbook, 'Motors')
For $x = 1 To UBound($aMotorsSheet) - 1
	$aMotorsSheet[$x][0] = StringReplace($aMotorsSheet[$x][0], '-', '')
Next

$aInstSheet = _Excel_RangeRead($oMIWorkbook, 'Instruments')
For $x = 1 To UBound($aInstSheet) - 1
	$aInstSheet[$x][0] = StringReplace($aInstSheet[$x][0], '-', '')
Next

$oTagWorkbook = _Excel_BookAttach($sTagWorkbookPath)
If Not IsObj($oTagWorkbook) Then
	$oExcel = _Excel_Open()
	$oTagWorkbook = _Excel_BookOpen($oExcel, $sTagWorkbookPath)
Else
	$oExcel = $oTagWorkbook.Application
EndIf

$aTagSheet = _Excel_RangeRead($oTagWorkbook, $sTagSheetName, Default, 1, True)

$oConfigToolWorkbook = _Excel_BookAttach($sConfigToolWorkbookPath)
If Not IsObj($oConfigToolWorkbook) Then
	$oExcel = _Excel_Open()
	$oConfigToolWorkbook = _Excel_BookOpen($oExcel, $sConfigToolWorkbookPath)
Else
	$oExcel = $oConfigToolWorkbook.Application
EndIf

$aSheetList = _Excel_SheetList($oConfigToolWorkbook)

For $iSheet = 2 To UBound($aSheetList) - 1
;~ _ArrayDisplay($aSheetList)
	$aSheet = _Excel_RangeRead($oConfigToolWorkbook, $aSheetList[$iSheet][0])

	$iDvcCollumn = 0
	$iDescCollumn = 0
	For $iCollumn = 5 To UBound($aSheet, 2) - 1
		If $aSheet[7][$iCollumn] = 'DvcID' Then
			$iDvcCollumn = $iCollumn
		EndIf
		If $aSheet[7][$iCollumn] = 'DvcDscrpt' Then
			$iDescCollumn = $iCollumn
		EndIf
	Next
	If $iDescCollumn = 0 And $iDvcCollumn = 0 Then
		ContinueLoop
	EndIf
	ConsoleWrite(@CRLF & '$iDvcCollumn= ' & $iDvcCollumn & @CRLF & '$iDescCollumn= ' & $iDescCollumn)


;~ _ArrayDisplay($aSheet)
;~ Exit
	For $iRow = 9 To UBound($aSheet) - 1
		$sTagName = StringReplace($aSheet[$iRow][2],'_FTAE','')
		ConsoleWrite(@CRLF & '++++++++> ' & $sTagName)
		If $sTagName = '' Then ExitLoop
		$iTagSheetIndex = _ArraySearch($aTagSheet, $sTagName, 0, 0, 0, 0, 1, 11)
		If $iTagSheetIndex < 0 Then
;~ 			MsgBox(0, '', $sTagName & ' Not Found')
			ConsoleWrite(@CRLF & '~~~~~~~~~~~> Not Found')
			ContinueLoop
		EndIf
		$sShortDeviceName = $aTagSheet[$iTagSheetIndex][6]
		$iDescIndex = _ArraySearch($aMotorsSheet, $sShortDeviceName, 0, 0, 0, 0, 1, 0)
		If $iDescIndex < 0 Then
			$iDescIndex = _ArraySearch($aInstSheet, $sShortDeviceName, 0, 0, 0, 0, 1, 0)
			If $iDescIndex < 0 Then
				ConsoleWrite(@CRLF & '~~~~~~~~~~~> Description Not Found')
				ContinueLoop
			Else
				$sDescription = $aInstSheet[$iDescIndex][4]
			EndIf
		Else
			$sDescription = $aMotorsSheet[$iDescIndex][3]
		EndIf

		If $iDvcCollumn <> 0 Then
			$aSheet[$iRow][$iDvcCollumn] = $sShortDeviceName
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

