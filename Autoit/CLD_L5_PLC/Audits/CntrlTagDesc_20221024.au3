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

	$oWorkbook = _Excel_BookAttach($sWorkbookPath)
	If Not IsObj($oWorkbook) Then
		$oExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
	Else
		$oExcel = $oWorkbook.Application
	EndIf

	$aSheet = _Excel_RangeRead($oWorkbook)

	_Excel_BookClose($oWorkbook)


	For $iRow = 7 To UBound($aSheet) - 1
		$sType = $aSheet[$iRow][0]
		$sScope = $aSheet[$iRow][1]
		$sTagName = $aSheet[$iRow][2]
		$sDesc = $aSheet[$iRow][3]
		$sDataType = $aSheet[$iRow][4]
		$sDataSpecifier = $aSheet[$iRow][5]
		$sDataAttributes = $aSheet[$iRow][6]


		If Not ($sDataType = 'CM_AIN' Or $sDataType = 'CM_AOUT' Or $sDataType = 'CM_DIN' Or $sDataType = 'CM_DOUT' Or $sDataType = 'CM_M2S' Or $sDataType = 'CM_V2S' Or $sDataType = 'CM_VFD') Then
			ContinueLoop
		EndIf
		ConsoleWrite(@CRLF & '++++++>' & $sTagName)


		$sSearch = '_'
		$iStart = StringInStr($sTagName, $sSearch) + StringLen($sSearch) - 1
		$sBaseTag = StringTrimLeft($sTagName, $iStart)
		$sCtrlTag = $sBaseTag & '_Ctrl'
;~ 		MsgBox(0, $sTagName, $sBaseTag)
;~ 		Exit

		ConsoleWrite(@CRLF & '>>>>' & $sCtrlTag)

		$iCtrlRow = _ArraySearch($aSheet, $sCtrlTag, 0, 0, 0, 1, 1, 2)
		If $iCtrlRow < 0 Then
			ContinueLoop
		EndIf
		ConsoleWrite(@CRLF & '>>' & $sDesc)


		$sCtrlType = $aSheet[$iCtrlRow][0]
		$sCtrlScope = $aSheet[$iCtrlRow][1]
		$sCtrlTagName = $aSheet[$iCtrlRow][2]
		$sCtrlDesc = $aSheet[$iCtrlRow][3]
		$sCtrlDataType = $aSheet[$iCtrlRow][4]
		$sCtrlDataSpecifier = $aSheet[$iCtrlRow][5]
		$sCtrlDataAttributes = $aSheet[$iCtrlRow][6]


		Local $aTemp[1][7] = [[$sCtrlType, $sCtrlScope, $sCtrlTagName, $sDesc, $sCtrlDataType, $sCtrlDataSpecifier, $sCtrlDataAttributes]]

		_ArrayAdd($aNewTagFile, $aTemp)


	Next

	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookNew($oExcel)
	_Excel_BookSaveAs($oWorkbook, $sNewFilePath, $xlCSV)

	_Excel_RangeWrite($oWorkbook, $sControllerName, $aNewTagFile)
	_Excel_BookSave($oWorkbook)
	_Excel_BookClose($oWorkbook)

Next





Func _Exit()
	Exit
EndFunc   ;==>_Exit

