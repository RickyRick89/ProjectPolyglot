#include <Excel.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\AJs_M&I.xlsx"

$sPIDPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PID_CHECK\2022-05-18 Line 5 PIDs.pdf"
$sSheetName = 'Motors'
;~ $sSheetName = 'Instruments'
$sWinTitlePID = '2022-05-18 Line 5 PIDs.pdf'


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
	If $sSheetName = 'Motors' Then
		$sType = 'EC'
;~ 	$sType = $aSheet[$iInc][3]
		$sTag = $aSheet[$iInc][2]
		$sStatus = 'Active'
		$sDescription = $aSheet[$iInc][3]
		$sSearch = $sType & ' ' & $sTag
	Else

;~ 	$sType = 'EC'
		$sType = $aSheet[$iInc][1]
		$sTag = $aSheet[$iInc][3]
		$sStatus = 'Active'
		$sDescription = $aSheet[$iInc][4]
		$sSearch = $sType & ' ' & $sTag
	EndIf

	If $sTag = '' Or $sStatus <> 'Active' Then ContinueLoop

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

;~ 		$iResponse = MsgBox($MB_YESNO, $sSearch, $sDescription & '?')

;~ 		If $iResponse = $IDYES Then
;~ 			$oWorkbook.Sheets($sSheetName).Range('G' & $iInc + 1).Style = "Good"
;~ 		ElseIf $iResponse = $IDNO Then
		$oWorkbook.Sheets($sSheetName).Range('L' & $iInc + 1).Value = InputBox('Type', 'Type', 'VFD')
;~ 		EndIf
	Else
		$oWorkbook.Sheets($sSheetName).Range('C' & $iInc + 1).Style = "Bad"
	EndIf


Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
