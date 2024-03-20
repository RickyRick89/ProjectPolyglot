#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\GEM\Simplot Grand Forks batter valves & instrumentation 2-16-23.xls"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\GEM\2023-04-26 GF L4 PIDs - RBG.pdf"
$sSheetName = 'Batter L4'
$sWinTitlePID = '2023-04-26 GF L4 PIDs - RBG.pdf'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)


;~ _ArrayDisplay($aSheet)
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

For $iInc = 2 To UBound($aSheet) - 1

	If StringInStr($sSheetName, 'Motor') Then
		$sType = 'FVNR'
		$sHP = $aSheet[$iInc][9]
		$sDesc = $aSheet[$iInc][6]
		$sSearch = 'EC ' & $sType & ' ' & StringReplace($aSheet[$iInc][2], 'EC-', '')

		$sSupplyer = $aSheet[$iInc][14]
	Else
		$sType = $aSheet[$iInc][1]
		$sTag = $aSheet[$iInc][2]
		$sLetter = $aSheet[$iInc][3]
		$sSearch = $sType & ' ' & $sTag & $sLetter

		$sSupplyer = $aSheet[$iInc][14]
		If $sType = 'M' Or $sType = 'EC' Then ContinueLoop
	EndIf

	Global $iHighlightNum = 10

	If $iHighlightNum > 1 Then
		If $sSupplyer = 'GEM' Or $sSupplyer = '' Then ContinueLoop
	Else
		If $sSupplyer <> 'GEM' Then ContinueLoop
	EndIf


	$bFound = _Search($sSearch)
	If Not $bFound And StringInStr($sSheetName, 'Motor') Then
		$bFound = _Search(StringReplace($sSearch, 'FVNR', 'VFD'))
	EndIf




	If $bFound Then
		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Good"
	Else
		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Bad"
	EndIf

	WinActivate($sWinTitlePID)

Next

Func _Search($sSearch)
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
		EndIf

		Sleep(10)
	Next

	Sleep(1000)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:17]')
	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Static; INSTANCE:16]', 'left', $iHighlightNum)
	Sleep(1000)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
	Sleep(100)

	Return $bFound
EndFunc   ;==>_Search

Func _Exit()
	Exit
EndFunc   ;==>_Exit

