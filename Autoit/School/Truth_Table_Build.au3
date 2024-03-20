#include <Array.au3>
#include <Excel.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\School\ECE 530 - Digital Hardware Design\Activities\01\Part3_Truth_Table.xlsx"
$iNumBits = 8
Local $aInputTable[1][$iNumBits]


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

For $iInc = 0 To (2 ^ $iNumBits) - 1
	$sBinary = StringFormat('%0' & $iNumBits & 'i', _DecToBinary($iInc))
	$aRow = StringSplit($sBinary, '', 2)
	_ArrayTranspose($aRow)
	_ArrayAdd($aInputTable, $aRow)

Next
_ArrayDelete($aInputTable, 0)
;~ _ArrayDisplay($aInputTable)
_Excel_RangeWrite($oWorkbook, Default, $aInputTable, 'A2')


Func _DecToBinary($iInt)
	Local $iRem, $sRet = ''
	While $iInt > 2 - 1
		$iRem = Mod($iInt, 2)
		$sRet = $iRem & $sRet
		$iInt = Int(($iInt - $iRem) / 2)
	WEnd
	Return $iInt & $sRet
EndFunc   ;==>_DecToBinary

Func _Exit()
	Exit
EndFunc   ;==>_Exit
