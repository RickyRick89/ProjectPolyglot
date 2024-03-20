#include <Excel.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PID_CHECK\MosesLake\Lists\22083-JRSML-Fry Form Line-Instrument List.xls"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PID_CHECK\MosesLake\L1-L2_PIDs_20221018.pdf"

;~ $sSheetName = 'Instruments'
$sWinTitlePID = 'L1-L2_PIDs_20221018.pd'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook)
$sSheetName = $oWorkbook.Activesheet.Name


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

For $iInc = 812 To UBound($aSheet) - 1
	$sType = $aSheet[$iInc][4]
	$sTag = $aSheet[$iInc][2]
	$sLetter = $aSheet[$iInc][5]
	$sStatus = 'Active'
	$sDescription = $aSheet[$iInc][8]
	$sSearch = $sType & ' .. ' & $sTag & $sLetter

	If $sType = 'M' Then
		ContinueLoop
	EndIf

	$bFound = 0

	If $sType <> '' Then

		ConsoleWrite(@CRLF & '---->' & $sSearch)

		ControlSetText($sWinTitlePID, '', '[CLASS:Edit; INSTANCE:2]', $sSearch)
		ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:16]')
		Sleep(2500)
		$sResults = ControlGetText($sWinTitlePID, '', '[CLASS:Static; INSTANCE:11]')
		If $sResults = '0 document(s) with 0 instance(s)' Then
			$bFound = 0
		Else
			$bFound = 1
		EndIf

		ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:17]')
		Sleep(100)
		ControlClick($sWinTitlePID, '', '[CLASS:Static; INSTANCE:16]')
		Sleep(100)
		ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
		Sleep(100)
	EndIf


	If $bFound Then
		$oWorkbook.Sheets($sSheetName).Range('A' & $iInc + 1 & ':O' & $iInc + 1).Style = "Good"

;~ 		$iResponse = MsgBox($MB_YESNO, $sSearch, $sDescription & '?')

;~ 		If $iResponse = $IDYES Then
;~ 			$oWorkbook.Sheets($sSheetName).Range('G' & $iInc + 1).Style = "Good"
;~ 		ElseIf $iResponse = $IDNO Then
;~ 		$oWorkbook.Sheets($sSheetName).Range('L' & $iInc + 1).Value = InputBox('Type', 'Type', 'VFD')
;~ 		EndIf
	Else
		$oWorkbook.Sheets($sSheetName).Range('A' & $iInc + 1 & ':O' & $iInc + 1).Style = "Bad"
	EndIf


Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
