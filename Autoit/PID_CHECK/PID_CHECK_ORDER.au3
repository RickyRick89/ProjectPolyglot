#include <Excel.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PID_CHECK\Instruments_By_RJX_20220321.xlsx"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PID_CHECK\2022-03-18 Line 5 PIDs.pdf"
$sSheetName = 'Instrument'
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
	$sTag = $aSheet[$iInc][4]
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
		$oWorkbook.Sheets($sSheetName).Range('E' & $iInc + 1).Style = "Good"
	Else
		$oWorkbook.Sheets($sSheetName).Range('E' & $iInc + 1).Style = "Bad"
	EndIf

;~ 	WinActivate($sWinTitlePID)

Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
