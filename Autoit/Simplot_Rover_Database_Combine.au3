#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


$sFileDir = 'C:\Users\rgrov\Downloads\Rover_Databases\'
$sNewFilePath = 'C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Rovers\My_Rover_Work\All_Databases.xlsx'

Local $aFileLines[0]


$aFilePaths = _FileListToArray($sFileDir, '*.csv', $FLTA_FILES, True)
$aFileNames = _FileListToArray($sFileDir, '*.csv', $FLTA_FILES, False)
;~ _ArrayDisplay($aFileNames)

For $x = 1 To $aFileNames[0]
	$iLen = StringLen($aFileNames[$x])
	$iStart = StringInStr($aFileNames[$x], 'ROVER') - 1
	$iEnd = StringInStr($aFileNames[$x], '_', 0, 1, $iStart + 1) - 1

	$sName = StringTrimLeft(StringTrimRight($aFileNames[$x], $iLen - $iEnd), $iStart)

	$oWorkbook = _Excel_BookAttach($aFilePaths[$x])
	If Not IsObj($oWorkbook) Then
		$oConfigExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oConfigExcel, $aFilePaths[$x])
	Else
		$oConfigExcel = $oWorkbook.Application
	EndIf

	$aFileLines = _Excel_RangeRead($oWorkbook)
	_Excel_BookClose($oWorkbook)
	_Excel_Close($oConfigExcel)
	For $y = 11 To 8 Step -1
		_ArrayColDelete($aFileLines, $y)
	Next
	_ArrayColDelete($aFileLines, 2)
	_ArrayColDelete($aFileLines, 1)
	_ArrayDelete($aFileLines, 1)
	_ArrayDelete($aFileLines, 0)

	_ArrayColInsert($aFileLines, 6)
	For $y = 0 To UBound($aFileLines) - 1
		For $z = 1 To 5
			If $aFileLines[$y][$z] = '' Then ExitLoop
			If $z <> 1 Then $aFileLines[$y][6] &= @CRLF
			$aFileLines[$y][6] &= $aFileLines[$y][$z]
		Next
	Next
	For $y = 5 To 1 Step -1
		_ArrayColDelete($aFileLines, $y)
	Next

;~ 	_ArrayDisplay($aFileLines)
;~ Exit

	$oWorkbook = _Excel_BookAttach($sNewFilePath)
	If Not IsObj($oWorkbook) Then
		$oConfigExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oConfigExcel, $sNewFilePath)
	Else
		$oConfigExcel = $oWorkbook.Application
	EndIf

	$aSheet = _Excel_RangeRead($oWorkbook)
	If Not IsArray($aSheet) Then
		_Excel_RangeWrite($oWorkbook, Default, $sName, "A1")
		_Excel_RangeWrite($oWorkbook, Default, $aFileLines, "A2")
	Else
		$iUsedColumns = UBound($aSheet, 2)
		_Excel_RangeWrite($oWorkbook, Default, $sName, _Excel_ColumnToLetter($iUsedColumns + 1) & "1")
		_Excel_RangeWrite($oWorkbook, Default, $aFileLines, _Excel_ColumnToLetter($iUsedColumns + 1) & '2')
	EndIf
;~ 	Exit

Next
