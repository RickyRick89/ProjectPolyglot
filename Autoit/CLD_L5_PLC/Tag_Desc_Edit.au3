#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sTagListPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Tags\Emulator_Dist_20220613-Controller-Tags.CSV"


$sMIWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_M&I.xlsx"
;~ $sMISheetName = 'Motors'
$sMISheetName = 'Instruments'
$sTagWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_Tag_Generator.xlsm"
$sTagSheetName = 'Tags'

Global $aText[1], $aHandles[1]

$oTagListWorkbook = _Excel_BookAttach($sTagListPath)
If Not IsObj($oTagListWorkbook) Then
	$oExcel = _Excel_Open()
	$oTagListWorkbook = _Excel_BookOpen($oExcel, $sTagListPath)
Else
	$oExcel = $oTagListWorkbook.Application
EndIf

$aTagListSheet = _Excel_RangeRead($oTagListWorkbook)


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

$aTagSheet = _Excel_RangeRead($oTagWorkbook, $sTagSheetName)

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
		Case 'L5_Waterknife'
			$sPLCWinTitle = 'Logix Designer - CA_PROC_5'
		Case 'L5_CGd'
			$sPLCWinTitle = 'Logix Designer - CA_DIST_5'
		Case Else
			MsgBox(0, '', 'Invalid Unit')
			Exit
	EndSwitch


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

	$iArrayIndex = _ArraySearch($aTagListSheet, $sCLXTagName,0,0,0,0,1,2)
	If $iArrayIndex >= 0 Then
;~ 		MsgBox(0, $sCLXTagName, $aTagListSheet[$iArrayIndex][2])
_Excel_RangeWrite($oTagListWorkbook,Default,$sDesc,'D'&$iArrayIndex+1)

	Else
;~ 		MsgBox(0, $sCLXTagName, 'Not Found')
		ContinueLoop
	EndIf


Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
