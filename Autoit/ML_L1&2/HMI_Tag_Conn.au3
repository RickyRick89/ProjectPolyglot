#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sExportPath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\ScreenWork\Exports\'
$sImportPath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\ScreenWork\Imports\'

$sMIWorkbookPath = "X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Motor And Instrument List Rev 0.1.xlsx"
;~ $sMISheetName = 'Motor List'
$sMISheetName = 'Instrument List'

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


;~ _ArrayDisplay($aMISheet)

Global $aFileLines[1]
Global $aMIInfo[1][9] = [['Group Name', 'Name', 'Desc', 'Unit', 'Line', 'Area', 'Type', 'PLC', 'CLX Tag Name']]


For $iRow = 1 To UBound($aMISheet) - 1
	ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)


	If $sMISheetName = 'Motor List' Then
		$sName = StringReplace($aMISheet[$iRow][1], '-', '')
		$sDesc = $aMISheet[$iRow][2]
		$sUnit = $aMISheet[$iRow][15]
		$sUnitDesc = $aMISheet[$iRow][16]
		$sLine = $aMISheet[$iRow][14]
		$sType = $aMISheet[$iRow][8]
		$sLine = ''
		$sArea = ''
		$sPLC = 'MOS_L01_CLX'
	ElseIf $sMISheetName = 'Instrument List' Then
		$sName = StringReplace($aMISheet[$iRow][2], '-', '')
		$sDesc = $aMISheet[$iRow][6]
		$sUnit = $aMISheet[$iRow][22]
		$sUnitDesc = $aMISheet[$iRow][24]
		$sLine = $aMISheet[$iRow][21]
		$sType = $aMISheet[$iRow][23]
		$sLine = ''
		$sArea = ''
		$sPLC = 'MOS_L01_CLX'
	EndIf

	$sGroupName = $sName
	$sCLXTagName = $sName

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
			If StringInStr($aFileLines[$iLine], '<parameter name="#103"') Then
				$iStart = StringInStr($aFileLines[$iLine], 'value="') + StringLen('value="')
				$iEnd = StringInStr($aFileLines[$iLine], '"', 0, 1, $iStart)
				$sValue = '"' & StringMid($aFileLines[$iLine], $iStart, $iEnd - $iStart) & '"'
				$aFileLines[$iLine] = StringReplace($aFileLines[$iLine], $sValue, '"[' & $aMIInfo[$iCurrentArrayIndex][7] & ']"')
;~ 				MsgBox(0, $iLine, $aFileLines[$iLine])
			ElseIf StringInStr($aFileLines[$iLine], '<parameter name="#102"') Then
				$iStart = StringInStr($aFileLines[$iLine], 'value="') + StringLen('value="')
				$iEnd = StringInStr($aFileLines[$iLine], '"', 0, 1, $iStart)
				$sValue = '"' & StringMid($aFileLines[$iLine], $iStart, $iEnd - $iStart) & '"'
				$aFileLines[$iLine] = StringReplace($aFileLines[$iLine], $sValue, '"{[' & $aMIInfo[$iCurrentArrayIndex][7] & ']' & $aMIInfo[$iCurrentArrayIndex][8] & '}"')
;~ 				MsgBox(0, $iLine, $aFileLines[$iLine])
			ElseIf StringInStr($aFileLines[$iLine], '<parameter name="#122"') Then
				$iStart = StringInStr($aFileLines[$iLine], 'value="') + StringLen('value="')
				$iEnd = StringInStr($aFileLines[$iLine], '"', 0, 1, $iStart)
				$sValue = '"' & StringMid($aFileLines[$iLine], $iStart, $iEnd - $iStart) & '"'
				$aFileLines[$iLine] = StringReplace($aFileLines[$iLine], $sValue, '"0"')
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
