#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\AJs_M&I.xlsx"
$sTagGenPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\AJs_Tag_Generator.xlsm"
$sPIDPath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\PIDs\2022-05-18 Line 5 PIDs.pdf"
;~ $sSheetName = 'Motors'
$sSheetName = 'Instruments'
$sWinTitlePID = '2022-05-18 Line 5 PIDs.pdf'

$iTagCount = 0
$Desc1Prev = ''
$Desc2Prev = ''
$Desc3Prev = ''


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)


$oTagsWorkbook = _Excel_BookAttach($sTagGenPath)
If Not IsObj($oTagsWorkbook) Then
	$oTagsExcel = _Excel_Open()
	$oTagsWorkbook = _Excel_BookOpen($oTagsExcel, $sTagGenPath)
Else
	$oTagsExcel = $oTagsWorkbook.Application
EndIf

$aTags = _Excel_RangeRead($oTagsWorkbook, 'Tags', Default, 1, True)

$iTagCount = UBound($aTags) - 1

If $iTagCount < 0 Then
	MsgBox(0, '', 'Excel Error')
EndIf

;~ _ArrayDisplay($aTags)
;~ Exit

ShellExecute($sPIDPath)
WinWait($sWinTitlePID)
WinActivate($sWinTitlePID)
ControlSend($sWinTitlePID, '', '', '{alt}')
Sleep(100)
ControlSend($sWinTitlePID, '', '', '{k}{1}')
Sleep(100)
ControlSend($sWinTitlePID, '', '', '{b}')
Sleep(1000)

For $iInc = 1 To UBound($aSheet) - 1
	If $sSheetName = 'Instruments' Then
		$sTag = $aSheet[$iInc][0]
		$sDesc = $aSheet[$iInc][4]
		$sLine = $aSheet[$iInc][9]
		$sArea = $aSheet[$iInc][10]
	ElseIf $sSheetName = 'Motors' Then
		$sTag = $aSheet[$iInc][0]
		$sDesc = $aSheet[$iInc][3]
		$sLine = $aSheet[$iInc][5]
		$sArea = $aSheet[$iInc][6]
	EndIf

	$sTagPLC = StringReplace($sTag, '-', '')

	$iTagIndex = _ArraySearch($aTags, $sTagPLC, 0, 0, 0, 0, 1, 6)

	If $iTagIndex >= 0 Then ContinueLoop

	$sSearch = StringReplace($sTag, '-', ' ')

	$bFound = 0

	ConsoleWrite(@CRLF & '---->' & $sSearch)

	ControlSetText($sWinTitlePID, '', '[CLASS:Edit; INSTANCE:2]', $sSearch)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:16]')
	Sleep(100)

	For $x = 1 To 200
		$sResults = ControlGetText($sWinTitlePID, '', '[CLASS:Static; INSTANCE:11]')
		If $sResults <> '0 document(s) with 0 instance(s)' Then
			$bFound = 1
			ExitLoop
		ElseIf $x = 200 Then
			$bFound = 0
			MsgBox(0, '', 'Not Found: ' & $sTag)
		EndIf

		Sleep(10)
	Next

	Sleep(1000)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:17]')
	Sleep(250)
	ControlClick($sWinTitlePID, '', '[CLASS:Static; INSTANCE:16]')
	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
	Sleep(100)


	If $bFound Then
;~ 		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Good"
		$iTagCount += 1
		_Excel_RangeWrite($oTagsWorkbook, 'Tags', $sLine, 'A' & $iTagCount + 1)
		_Excel_RangeWrite($oTagsWorkbook, 'Tags', $sArea, 'B' & $iTagCount + 1)
		$Desc1 = InputBox($sTagPLC, $sDesc, $Desc1Prev)
		$Desc2 = InputBox($sTagPLC, $sDesc, $Desc2Prev)
		$Desc3 = InputBox($sTagPLC, $sDesc, $Desc3Prev)

		$Desc1Prev = $Desc1
		$Desc2Prev = $Desc2
		$Desc3Prev = $Desc3

		_Excel_RangeWrite($oTagsWorkbook, 'Tags', $Desc1, 'C' & $iTagCount + 1)
		_Excel_RangeWrite($oTagsWorkbook, 'Tags', $Desc2, 'D' & $iTagCount + 1)
		_Excel_RangeWrite($oTagsWorkbook, 'Tags', $Desc3, 'E' & $iTagCount + 1)
		_Excel_RangeWrite($oTagsWorkbook, 'Tags', $sTagPLC, 'G' & $iTagCount + 1)
;~ 		Exit
	Else
;~ 		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Bad"
	EndIf

	WinActivate($sWinTitlePID)

Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
