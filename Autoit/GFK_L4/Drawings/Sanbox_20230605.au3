#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Motor And Instrument List Rev 1.xlsx"
$sSheetName = 'Instrument List'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

Global $aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)

;~ _ArrayDisplay($aSheet)

For $iRow = 1 To UBound($aSheet) - 1
	$sWiredTo = $aSheet[$iRow][9]
	If StringInStr($sWiredTo, '_JB') Then
		$iEnd = StringInStr($sWiredTo, '_JB') - 1
		$sMain = StringLeft($sWiredTo, $iEnd)
		$sASM = $sMain & '_ASM01'
;~ 		MsgBox(0, '', $sASM)
		_Excel_RangeWrite($oWorkbook, $sSheetName, $sASM, 'AA' & $iRow + 1)
	Else
		_Excel_RangeWrite($oWorkbook, $sSheetName, $sWiredTo & '_ASM01', 'AA' & $iRow + 1)
	EndIf
Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
