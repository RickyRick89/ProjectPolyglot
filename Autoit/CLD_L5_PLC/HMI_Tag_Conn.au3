#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sExportPath = 'C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\HMI\'
$sImportPath = 'C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\HMI\'

$sMIWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_M&I.xlsx"
$sMISheetName = 'Motors'
;~ $sMISheetName = 'Instruments'

$sTagWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_Tag_Generator.xlsm"
$sTagSheetName = 'Tags'

$aFileNames = _FileListToArray($sExportPath, '*.xml', $FLTA_FILES, False)
$aFilePaths = _FileListToArray($sExportPath, '*.xml', $FLTA_FILES, True)

$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
If Not IsObj($oMIWorkbook) Then
	$oExcel = _Excel_Open()
	$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
Else
	$oExcel = $oMIWorkbook.Application
EndIf

$aMISheet = _Excel_RangeRead($oMIWorkbook, $sMISheetName)

$oTagWorkbook = _Excel_BookAttach($sTagWorkbookPath)
If Not IsObj($oTagWorkbook) Then
	$oExcel = _Excel_Open()
	$oTagWorkbook = _Excel_BookOpen($oExcel, $sTagWorkbookPath)
Else
	$oExcel = $oTagWorkbook.Application
EndIf

$aTagSheet = _Excel_RangeRead($oTagWorkbook, $sTagSheetName, Default, 1, True)

;~ _ArrayDisplay($aMISheet)
;~ _ArrayDisplay($aTagSheet)

Global $aFileLines[1]
Global $aMIInfo[1][9] = [['Group Name', 'Name', 'Desc', 'Unit', 'Line', 'Area', 'Type', 'PLC', 'CLX Tag Name']]


For $iRow = 1 To UBound($aMISheet) - 1
	ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)


	If $sMISheetName = 'Motors' Then
		$sName = StringReplace($aMISheet[$iRow][0], '-', '')
		$sDesc = $aMISheet[$iRow][3]
		$sUnit = $aMISheet[$iRow][4]
		$sLine = $aMISheet[$iRow][5]
		$sArea = $aMISheet[$iRow][6]
		$sType = $aMISheet[$iRow][11]
		$sPLC = $aMISheet[$iRow][12]
	ElseIf $sMISheetName = 'Instruments' Then
		$sName = StringReplace($aMISheet[$iRow][0], '-', '')
		$sDesc = $aMISheet[$iRow][4]
		$sUnit = $aMISheet[$iRow][8]
		$sLine = $aMISheet[$iRow][9]
		$sArea = $aMISheet[$iRow][10]
		$sType = $aMISheet[$iRow][7]
		$sPLC = $aMISheet[$iRow][11]
	EndIf
	$iTagIndex = _ArraySearch($aTagSheet, $sName, 0, 0, 0, 0, 1, 6)
	If $iTagIndex < 0 Then
		MsgBox(0, '', 'Device not found on TagList: ' & $sName)
		ContinueLoop
;~ 		Exit
	EndIf

	$sGroupName = 'grp' & $sName
	$sCLXTagName = $aTagSheet[$iTagIndex][11]

	$iArrayIndex = _ArrayAdd($aMIInfo, '')
	$aMIInfo[$iArrayIndex][0] = $sGroupName
	$aMIInfo[$iArrayIndex][1] = $sName
	$aMIInfo[$iArrayIndex][2] = $sDesc
	$aMIInfo[$iArrayIndex][3] = $sUnit
	$aMIInfo[$iArrayIndex][4] = $sLine
	$aMIInfo[$iArrayIndex][5] = $sArea
	$aMIInfo[$iArrayIndex][6] = $sType
	$aMIInfo[$iArrayIndex][7] = $sPLC
	$aMIInfo[$iArrayIndex][8] = $sCLXTagName

Next
;~ _ArrayDisplay($aMIInfo)

For $iInc = 1 To $aFileNames[0]
	ConsoleWrite(@CRLF & '+++>' & $aFileNames[$iInc])

	_FileReadToArray($aFilePaths[$iInc], $aFileLines)
	$sCurrentGroupName = ''
	$iCurrentArrayIndex = 0
	$iGroupCount = 0
	For $iLine = 1 To $aFileLines[0]
		If StringInStr($aFileLines[$iLine], '<group name="') Then
			$iStart = StringInStr($aFileLines[$iLine], '<group name="') + StringLen('<group name="')
			$iEnd = StringInStr($aFileLines[$iLine], '"', 0, 1, $iStart)
			$sGroupName = StringMid($aFileLines[$iLine], $iStart, $iEnd - $iStart)
			$iArrayIndex = _ArraySearch($aMIInfo, $sGroupName, 0, 0, 0, 0, 1, 0)
			If $iArrayIndex >= 0 Then
				$sCurrentGroupName = $sGroupName
				$iCurrentArrayIndex = $iArrayIndex
				$iGroupCount = 0
			Else
				$iGroupCount += 1
			EndIf
		ElseIf StringInStr($aFileLines[$iLine], '</group>') Then
			$iGroupCount -= 1
			If $iGroupCount < 0 Then
				$sCurrentGroupName = ''
				$iCurrentArrayIndex = 0
			EndIf
		ElseIf $sCurrentGroupName <> '' Then
			If StringInStr($aFileLines[$iLine], '<parameter name="#101"') Then
				$iStart = StringInStr($aFileLines[$iLine], 'value="') + StringLen('value="')
				$iEnd = StringInStr($aFileLines[$iLine], '"', 0, 1, $iStart)
				$sValue = '"' & StringMid($aFileLines[$iLine], $iStart, $iEnd - $iStart) & '"'
				$aFileLines[$iLine] = StringReplace($aFileLines[$iLine], $sValue, '"/FTDATA03::[' & $aMIInfo[$iCurrentArrayIndex][7] & ']"')
;~ 				MsgBox(0, $iLine, $aFileLines[$iLine])
			ElseIf StringInStr($aFileLines[$iLine], '<parameter name="#102"') Then
				$iStart = StringInStr($aFileLines[$iLine], 'value="') + StringLen('value="')
				$iEnd = StringInStr($aFileLines[$iLine], '"', 0, 1, $iStart)
				$sValue = '"' & StringMid($aFileLines[$iLine], $iStart, $iEnd - $iStart) & '"'
				$aFileLines[$iLine] = StringReplace($aFileLines[$iLine], $sValue, '"' & $aMIInfo[$iCurrentArrayIndex][8] & '"')
;~ 				MsgBox(0, $iLine, $aFileLines[$iLine])
			EndIf
		EndIf
	Next
	$sNewFilePath = $sImportPath & $aFileNames[$iInc]

	_ArrayDelete($aFileLines, 0)
	$sNewFileText = _ArrayToString($aFileLines, @CR)

	_FileCreate($sNewFilePath)
	FileWrite($sNewFilePath, $sNewFileText)
Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
