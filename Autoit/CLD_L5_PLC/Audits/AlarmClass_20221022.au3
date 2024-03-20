#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>


Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Local $aTags[1][2]

$sTagPathRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\Tags'
$sL5XPathRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\L5X'

$aTagFiles = _FileListToArray($sTagPathRoot, '*.csv', Default, True)
$aTagFileNames = _FileListToArray($sTagPathRoot, '*.csv', Default, False)

$aL5XFiles = _FileListToArray($sL5XPathRoot, '*.L5X', Default, True)
$aL5XFileNames = _FileListToArray($sL5XPathRoot, '*.L5X', Default, False)

$sAlarmClassPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\UseFiles\AlarmClass.xlsx"
$sWorkbookPath = $sAlarmClassPath
$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aAlarmClass = _Excel_RangeRead($oWorkbook)


For $x = 1 To $aTagFileNames[0]
	Local $aL5XFileLinesTemp[1]
	Local $aNewTagFile[7][7]
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
	$sNewFilePath = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\Import\' & $sControllerName & '.csv'

	FileDelete($sNewFilePath)

	For $y = 1 To $aL5XFileNames[0]

		If StringInStr($aL5XFileNames[$y], $sControllerName) Then
			$iL5XFileInc = $y
			_FileReadToArray($aL5XFiles[$y], $aL5XFileLinesTemp)
			Local $aL5XFileLines[1]

			For $z = 1 To $aL5XFileLinesTemp[0] - 2
				If StringInStr($aL5XFileLinesTemp[$z], '<InOutParameter Name="Ref_Unit"') Or StringInStr($aL5XFileLinesTemp[$z + 1], '<InOutParameter Name="Ref_Unit"') Then
					$aL5XFileLines[0] = _ArrayAdd($aL5XFileLines, $aL5XFileLinesTemp[$z])
;~ 					ConsoleWrite(@CRLF & '-->' & $aL5XFileLines[0])
				EndIf
			Next
			ExitLoop
		EndIf


		If $y = $aL5XFileNames[0] Then
			MsgBox(0, '', 'L5X not found for ' & $sControllerName)
			Exit
		EndIf
	Next


	$oWorkbook = _Excel_BookAttach($sWorkbookPath)
	If Not IsObj($oWorkbook) Then
		$oExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
	Else
		$oExcel = $oWorkbook.Application
	EndIf

	$aSheet = _Excel_RangeRead($oWorkbook)



	$sPrevUnit = ''
	For $iRow = 7 To UBound($aSheet) - 1
		$sType = $aSheet[$iRow][0]
		$sScope = $aSheet[$iRow][1]
		$sTagName = $aSheet[$iRow][2]
		$sDesc = $aSheet[$iRow][3]
		$sDataType = $aSheet[$iRow][4]
		$sDataSpecifier = $aSheet[$iRow][5]
		$sDataAttributes = $aSheet[$iRow][6]

		If Not (StringInStr($sTagName, 'ALMD') And StringInStr($sDataType, 'ALARM_DIGITAL')) And Not (StringInStr($sTagName, 'ALMA') Or StringInStr($sDataType, 'ALARM_ANALOG')) Then
			ContinueLoop
		EndIf
		$iIndex = _ArraySearch($aTags, $sTagName, 0, 0, 0, 0, 1, 0)
		If $iIndex >= 0 Then
			ContinueLoop
		EndIf

		$sRootTag = StringReplace(StringReplace($sTagName, '_ALMD', ''), '_ALMA', '')

		ConsoleWrite(@CRLF & '++++++>' & $sRootTag)

		$sUnit = ''

		$iL5XRow = _ArraySearch($aL5XFileLines, 'Operand="' & $sRootTag & '"', 0, 0, 0, 1)
		If $iL5XRow >= 0 Then
			If StringInStr($aL5XFileLines[$iL5XRow], 'Operand="' & $sRootTag & '"') Then
				$sSearch = 'Argument="'
				$iStart = StringInStr($aL5XFileLines[$iL5XRow + 1], $sSearch) + StringLen($sSearch) - 1
				$iEnd = StringInStr($aL5XFileLines[$iL5XRow + 1], '"', 0, 1, $iStart + 1) - 1
				$sUnit = StringTrimLeft(StringLeft($aL5XFileLines[$iL5XRow + 1], $iEnd), $iStart)
				ConsoleWrite(@CRLF & '>>>' & $sUnit)

			EndIf
		EndIf
		If $sUnit = '' Then
			$iIndex = _ArraySearch($aAlarmClass, $sTagName, 0, 0, 0, 0, 1, 0)
			If $iIndex >= 0 Then
				$sUnit = $aAlarmClass[$iIndex][1]
			EndIf
		EndIf

		Local $aTemp[1][2] = [[$sTagName, $sUnit]]
		$sPrevUnit = $sUnit
		_ArrayAdd($aTags, $aTemp)
		If StringInStr($sDataAttributes, 'AlarmClass := "') Then
			$sSearch = 'AlarmClass := "'
			$iStart = StringInStr($sDataAttributes, $sSearch) + StringLen($sSearch) - 1
			$sNewAttributes = StringLeft($sDataAttributes, $iStart) & $sUnit & '")'
;~ 			MsgBox(0, '', $sNewAttributes)
;~ 			Exit
		Else
			$sNewAttributes = StringTrimRight($sDataAttributes, 1) & ', AlarmClass := "' & $sUnit & '")'
		EndIf
		$sNewAttributes = StringReplace($sNewAttributes, ', HMICmd := "Display"', '')


		Local $aTemp[1][7] = [[$sType, $sScope, $sTagName, $sDesc, $sDataType, $sDataSpecifier, $sNewAttributes]]

		_ArrayAdd($aNewTagFile, $aTemp)


	Next

	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookNew($oExcel)
	_Excel_BookSaveAs($oWorkbook, $sNewFilePath, $xlCSV)

	_Excel_RangeWrite($oWorkbook, $sControllerName, $aNewTagFile)
	_Excel_BookSave($oWorkbook)
	_Excel_BookClose($oWorkbook)

Next

_ArrayToClip($aTags, @TAB)




Func _Exit()
	Exit
EndFunc   ;==>_Exit

