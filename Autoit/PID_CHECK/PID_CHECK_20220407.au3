#include <Excel.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\Instrument_List\Motor And Instrument List Rev 0.7.xlsx"

$sPIDPath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\PIDs\2022-03-25 Line 5 PIDs.pdf"
$sSheetName = 'Instrument List'
$sWinTitlePID = '2022-03-25 Line 5 PIDs.pdf'


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

For $iInc = 792 To UBound($aSheet) - 1
;~ 	$sType = 'EC'
	$sType = $aSheet[$iInc][3]
	$sTag = $aSheet[$iInc][5]
	$sConn = $aSheet[$iInc][7]
	$sSigType = $aSheet[$iInc][8]
	$sWiredTo = $aSheet[$iInc][9]
	$sSearch = $sType & ' ' & $sTag

	If $sTag = '' Then ContinueLoop

	$bFound = 0

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



	If $bFound Then
		$oWorkbook.Sheets($sSheetName).Range('C' & $iInc + 1).Style = "Good"

		$iResponse = MsgBox($MB_YESNO, $sSearch, $sConn & '?')

		If $iResponse = $IDYES Then
			$oWorkbook.Sheets($sSheetName).Range('H' & $iInc + 1).Style = "Good"
		ElseIf $iResponse = $IDNO Then
			$sNewConn = InputBox('New Conn', 'What is Connection Type?', $sConn)
			$oWorkbook.Sheets($sSheetName).Range('H' & $iInc + 1).Style = "Neutral"
			$oWorkbook.Sheets($sSheetName).Range('H' & $iInc + 1).Value = $sNewConn
		EndIf

		$iResponse = MsgBox($MB_YESNO, $sSearch, $sSigType & '?')

		If $iResponse = $IDYES Then
			$oWorkbook.Sheets($sSheetName).Range('I' & $iInc + 1).Style = "Good"
		ElseIf $iResponse = $IDNO Then
			$sNewSigType = InputBox('New Signal Type', 'What is Signal Type?', $sSigType)
			$oWorkbook.Sheets($sSheetName).Range('I' & $iInc + 1).Style = "Neutral"
			$oWorkbook.Sheets($sSheetName).Range('I' & $iInc + 1).Value = $sNewSigType
		EndIf

		$iResponse = MsgBox($MB_YESNO, $sSearch, $sWiredTo & '?')

		If $iResponse = $IDYES Then
			$oWorkbook.Sheets($sSheetName).Range('J' & $iInc + 1).Style = "Good"
		ElseIf $iResponse = $IDNO Then
			$sNewWiredTo = InputBox('New Wired To', 'What is Instrument Wired To?', $sWiredTo)
			$oWorkbook.Sheets($sSheetName).Range('J' & $iInc + 1).Style = "Neutral"
			$oWorkbook.Sheets($sSheetName).Range('J' & $iInc + 1).Value = $sNewWiredTo
		EndIf


	Else
		$oWorkbook.Sheets($sSheetName).Range('C' & $iInc + 1).Style = "Bad"
	EndIf

Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
