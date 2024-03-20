#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PID_CHECK\Motor And Instrument List Rev 0.xlsb.xlsx"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PID_CHECK\2022-03-03 Line 5 PIDs.pdf"
$sSheetName = 'Instrument List'
$sWinTitlePID = '2022-03-03 Line 5 PIDs.pdf'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)


;~ _ArrayDisplay($aSheet)

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
	$sType = $aSheet[$iInc][2]
	$sEq = $aSheet[$iInc][3]
	$sTag = $aSheet[$iInc][4]
	$sSearch = $sType & ' ' & $sTag

	If $sEq < 5608 Then ContinueLoop

	$bFound = 0

	ConsoleWrite(@CRLF & '---->' & $sSearch)

	If StringLen($sTag) <> 4 Then ContinueLoop

	ControlSetText($sWinTitlePID, '', '[CLASS:Edit; INSTANCE:2]', $sSearch)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:16]')
	Sleep(1500)
	$sResults = ControlGetText($sWinTitlePID, '', '[CLASS:Static; INSTANCE:11]')

	$iStartPos = StringInStr($sResults, 'instance')
	$iInstances = Number(StringRight(StringLeft($sResults, $iStartPos - 2), 2))

	If $iInstances > 1 Then
		MsgBox(0, '', 'Check')
	EndIf

;~ 	If $sResults = '0 document(s) with 0 instance(s)' Then
;~ 		$bFound = 0
;~ 	Else
;~ 		$bFound = 1
;~ 	EndIf

;~ 	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:17]')
;~ 	Sleep(100)
;~ 	ControlClick($sWinTitlePID, '', '[CLASS:Static; INSTANCE:16]')
;~ 	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
	Sleep(100)



;~ 	If $bFound Then
;~ 		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Good"
;~ 	Else
;~ 		$oWorkbook.Sheets($sSheetName).Range('B' & $iInc + 1).Style = "Bad"
;~ 	EndIf

;~ 	WinActivate($sWinTitlePID)

Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
