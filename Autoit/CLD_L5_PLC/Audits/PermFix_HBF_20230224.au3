#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>


Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Local $aTags[1][2]

$sTagPathRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\Tags'
$sL5XPathRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\L5X'
$sConfigRootDir = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\ConfigTools'

$aConfigFiles = _FileListToArray($sConfigRootDir, '*.xls', Default, True)
$aConfigFileNames = _FileListToArray($sConfigRootDir, '*.xls', Default, False)

$aTagFiles = _FileListToArray($sTagPathRoot, '*.csv', Default, True)
$aTagFileNames = _FileListToArray($sTagPathRoot, '*.csv', Default, False)

$aL5XFiles = _FileListToArray($sL5XPathRoot, '*.L5X', Default, True)
$aL5XFileNames = _FileListToArray($sL5XPathRoot, '*.L5X', Default, False)


For $x = 1 To $aTagFileNames[0]
	Local $aL5XFileLinesTemp[1]
	Local $aNewTagFile[7][7]
	Local $aList[1][3]
	$aList[0][0] = 'Permissive'
	$aList[0][1] = 'Description'
	$aList[0][2] = 'Logic'

	$aNewTagFile[0][0] = 'remark'
	$aNewTagFile[1][0] = 'remark'
	$aNewTagFile[2][0] = 'remark'
	$aNewTagFile[3][0] = 'remark'
	$aNewTagFile[4][0] = 'remark'
	$aNewTagFile[5][0] = '0.3'
	$aNewTagFile[0][1] = 'CSV-Import-Export'
	$aNewTagFile[1][1] = 'Date = Sat Oct 22 08:29:40 2022'
	$aNewTagFile[2][1] = 'Version = RSLogix 5000 v31.02'
	$aNewTagFile[3][1] = 'Owner = Triplex'
	$aNewTagFile[4][1] = 'Company = '
	$aNewTagFile[6][0] = 'TYPE'
	$aNewTagFile[6][1] = 'SCOPE'
	$aNewTagFile[6][2] = 'NAME'
	$aNewTagFile[6][3] = 'DESCRIPTION'
	$aNewTagFile[6][4] = 'DATATYPE'
	$aNewTagFile[6][5] = 'SPECIFIER'
	$aNewTagFile[6][6] = 'ATTRIBUTES'

	$sWorkbookPath = $aTagFiles[$x]
	$sControllerName = StringLeft($aTagFileNames[$x], StringInStr($aTagFileNames[$x], '_', 0, 3) - 1)
	ConsoleWrite(@CRLF & '==================>' & $sControllerName)
	$sNewFilePath = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\Report\' & $sControllerName & '.csv'


	$oWorkbook = _Excel_BookAttach($sNewFilePath)
	If Not IsObj($oWorkbook) Then
		$oExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oExcel, $sNewFilePath)
	Else
		$oExcel = $oWorkbook.Application
	EndIf

	$aNewSheet = _Excel_RangeRead($oWorkbook)

	For $y = 1 To $aConfigFileNames[0]

		If StringInStr($aConfigFileNames[$y], $sControllerName) Then

			$oWorkbook = _Excel_BookAttach($aConfigFiles[$y])
			If Not IsObj($oWorkbook) Then
				$oExcel = _Excel_Open()
				$oWorkbook = _Excel_BookOpen($oExcel, $aConfigFiles[$y])
			Else
				$oExcel = $oWorkbook.Application
			EndIf

			$aConfigSheet = _Excel_RangeRead($oWorkbook, 'P_Perm')
			ExitLoop

		EndIf
	Next

	For $iRow = 1 To UBound($aNewSheet) - 1
		$sPermissive = $aNewSheet[$iRow][0]
		$sDesc = $aNewSheet[$iRow][1]
		$aTemp = StringSplit($sPermissive, '.')
		$sRootTag = $aTemp[1]
		$iPermNum = Number(StringRight($sPermissive, 2))
		ConsoleWrite(@CRLF & '++++>' & $sPermissive)

		$iConfigRow = _ArraySearch($aConfigSheet, $sRootTag, 0, 0, 0, 1, 1, 2)
		$sSearchTag = $aConfigSheet[$iConfigRow][2]
		If $sSearchTag = $sRootTag Then
			$iCol = ($iPermNum * 5) + 7
			$aConfigSheet[$iConfigRow][$iCol] = $sDesc
		EndIf
	Next

	_ArrayDelete($aConfigSheet, 8)
	_ArrayDelete($aConfigSheet, 7)
	_ArrayDelete($aConfigSheet, 6)
	_ArrayDelete($aConfigSheet, 5)
	_ArrayDelete($aConfigSheet, 4)
	_ArrayDelete($aConfigSheet, 3)
	_ArrayDelete($aConfigSheet, 2)
	_ArrayDelete($aConfigSheet, 1)
	_ArrayDelete($aConfigSheet, 0)

	_ArrayColDelete($aConfigSheet, 3)
	_ArrayColDelete($aConfigSheet, 2)
	_ArrayColDelete($aConfigSheet, 1)
	_ArrayColDelete($aConfigSheet, 0)

	_Excel_RangeWrite($oWorkbook, 'P_Perm', $aConfigSheet, 'E10')


Next





Func _Exit()
	Exit
EndFunc   ;==>_Exit

