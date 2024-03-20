#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sMIWorkbookPath = "Y:\My_Scripts\CLD_L5_PLC\VFD_Sync\VFDs.xlsx"
$sWinTitle = 'Configure driver: CLD_Drives'

$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
If Not IsObj($oMIWorkbook) Then
	$oExcel = _Excel_Open()
	$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
Else
	$oExcel = $oMIWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oMIWorkbook)

;~ _ArrayDisplay($aSheet)

For $iRow = 1 To UBound($aSheet) - 1
	WinActivate($sWinTitle)
	$sIP = $aSheet[$iRow][2]
	Send($sIP)
	Sleep(100)
	Send('{down}')
	Sleep(100)
	ControlClick($sWinTitle,'','[CLASS:Button; INSTANCE:6]')
;~ 	MsgBox(0,'',$sIP)
	Sleep(100)
;~ 	Exit
Next




Func _Exit()
	Exit
EndFunc   ;==>_Exit
