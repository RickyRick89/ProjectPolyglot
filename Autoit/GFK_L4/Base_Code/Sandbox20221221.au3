#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>


Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')


$sNewWorkbookPath = "X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\YASKAWA\Alarms.xlsx"


$oNewWorkbook = _Excel_BookAttach($sNewWorkbookPath)
If Not IsObj($oNewWorkbook) Then
	$oExcel = _Excel_Open()
	$oNewWorkbook = _Excel_BookOpen($oExcel, $sNewWorkbookPath)
Else
	$oExcel = $oNewWorkbook.Application
EndIf

$aNewSheets = _Excel_RangeRead($oNewWorkbook)

;~ _ArrayDisplay($aNewSheets)

For $iRow = 1 To UBound($aNewSheets) - 1
	$sText = $aNewSheets[$iRow][0]
	$iStart = StringInStr($sText, '(') + 1
	$iEnd = StringInStr($sText, ')')
	$iHex = StringMid($sText, $iStart, $iEnd - $iStart)
	$iDec = Dec($iHex)
	_Excel_RangeWrite($oNewWorkbook, Default, $iDec, 'B' & $iRow + 1)
Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
