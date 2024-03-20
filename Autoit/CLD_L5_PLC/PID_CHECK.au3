#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Motor And Instrument List Rev 0.5.xlsx"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\2022-03-18 Line 5 PIDs.pdf"
$sSheetName = 'Instrument List'
$sWinTitlePID = '2022-03-18 Line 5 PIDs.pdf'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)


;~ _ArrayDisplay($aSheet)
Exit
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
	$sType = $aSheet[$iInc][3]
	$sTag = $aSheet[$iInc][5]
	$sStatus = $aSheet[$iInc][26]
	If $sStatus = 'Deleted' Then ContinueLoop

	$sSearch = $sType & ' ' & $sTag

	$bFound = 0

	ConsoleWrite(@CRLF & '---->' & $sSearch)

	ControlSetText($sWinTitlePID, '', '[CLASS:Edit; INSTANCE:2]', $sSearch)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:16]')
	Sleep(100)
	MsgBox(0, '', $sSearch)
	Exit
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


	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:17]')
	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Static; INSTANCE:16]')
	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
	Sleep(100)



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
