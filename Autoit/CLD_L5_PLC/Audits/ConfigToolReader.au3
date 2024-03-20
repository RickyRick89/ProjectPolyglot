#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

Local $aBlankArray[200][200]

$sRootDir = 'Y:\My_Scripts\CLD_L5_PLC\Audits\ConfigTools'

$aFiles = _FileListToArray($sRootDir, '*.xls', Default, True)
$aFileNames = _FileListToArray($sRootDir, '*.xls', Default, False)


For $x = 2 To $aFiles[0]

	$sWorkbookPath = $aFiles[$x]

	$oWorkbook = _Excel_BookAttach($sWorkbookPath)
	If Not IsObj($oWorkbook) Then
		$oExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
	Else
		$oExcel = $oWorkbook.Application
	EndIf
	$aSheetList = _Excel_SheetList($oWorkbook)

;~ 	_ArrayDisplay($aSheetList)

	For $iSheetNum = 2 To UBound($aSheetList)-1
		$oWorkbook.Sheets($aSheetList[$iSheetNum][0]).Activate()
		$oWorkbook.Sheets($aSheetList[$iSheetNum][0]).Range("E10").Select()
		_Excel_RangeWrite($oWorkbook,$aSheetList[$iSheetNum][0],$aBlankArray,'E10')
		$oExcel.run("OPC_Control.cmdReadFromCLX")

	Next

Next






Func _Exit()
	Exit
EndFunc   ;==>_Exit
