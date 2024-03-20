#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\Motor And Instrument List Rev 1.2.xlsx"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Audit\GFP Process PID Complete Set-8-9-2023.pdf"
$sSheetName = 'Instrument List'
$sWinTitlePID = 'GFP Process PID Complete Set-8-9-2023.pdf'


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

For $iInc = 1 To UBound($aSheet) - 1

	If StringInStr($sSheetName, 'Motor') Then
		$sType = $aSheet[$iInc][7]
		$sHP = $aSheet[$iInc][5]
		$sDesc = $aSheet[$iInc][2]
		$sSearch = 'EC ' & $sType & ' ' & StringReplace($aSheet[$iInc][1], 'EC-', '')
		$sStatus = $aSheet[$iInc][18]
	Else
		$sType = $aSheet[$iInc][3]
		$sTag = $aSheet[$iInc][5]
		$sStatus = $aSheet[$iInc][25]

		$sSearch = $sType & ' ' & $sTag
	EndIf

	If $sStatus = 'Deleted' Then ContinueLoop


;~ 	If String(Number($sTag)) <> $sTag Then ContinueLoop


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
	ControlClick($sWinTitlePID, '', '[CLASS:Static; INSTANCE:16]')
	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
	Sleep(100)

;~ 	If $sHP = '' Then
;~ 		$sHP = InputBox('', $sSearch)
;~ 		$oWorkbook.Sheets($sSheetName).Range('F' & $iInc + 1).Value = $sHP
;~ 	EndIf
;~ 	$sDesc = InputBox('', $sSearch, $sDesc)
;~ 	$oWorkbook.Sheets($sSheetName).Range('C' & $iInc + 1).Value = $sDesc


;~ 	If String(Number($sTag)) = $sTag Then
;~ 		$sTag = InputBox('', $sTag, $sTag & 'A')
;~ 		$oWorkbook.Sheets($sSheetName).Range('C' & $iInc + 1).Value = $sType & '-' & $sTag
;~ 		$oWorkbook.Sheets($sSheetName).Range('F' & $iInc + 1).Value = $sTag
;~ 	EndIf




	If $bFound Then
		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Good"
	Else
		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Bad"
	EndIf

	WinActivate($sWinTitlePID)

Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
