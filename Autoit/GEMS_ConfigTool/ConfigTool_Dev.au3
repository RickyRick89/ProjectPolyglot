#include <Excel.au3>
#include <ExcelConstants.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')


Global $sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GEMS_ConfigTool\GEMS_ConfigTool.xls"
$sAOIPath = 'C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\Programming\Exports\Tags\'

$sFileExt = '.CSV'
$sLineSearchText = '<Parameter '
$sNameSearchText = 'Name="'


Global $aFilePaths = _FileListToArray($sAOIPath, '*' & $sFileExt, $FLTA_FILES, True)
Global $aFileNames = _FileListToArray($sAOIPath, '*' & $sFileExt, $FLTA_FILES, False)
Global $iSheetNum = 0

For $x = 1 To $aFileNames[0]
	$aFileNames[$x] = StringReplace($aFileNames[$x], '-Tags' & $sFileExt, '')
Next

For $iFileInc = 1 To $aFilePaths[0]
	Local $aParams[7][1]
	$iSheetNum = $iFileInc
	_GetParams($aFilePaths[$iFileInc], $aFileNames[$iFileInc], $aParams)
	If IsArray($aParams) Then
		If (UBound($aParams, 2) - 1) > 0 Then
			_AddSheet($aFileNames[$iFileInc], $aParams)
		EndIf
	EndIf
Next


; #FUNCTION# ====================================================================================================================
; Name ..........: _GetParams
; Description ...:
; Syntax ........: _GetParams($sFilePath, $sFileName, Byref $aParams)
; Parameters ....: $sFilePath           - a string value.
;                  $sFileName           - a string value.
;                  $aParams             - [in/out] an array of unknowns.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetParams($sFilePath, $sFileName, ByRef $aParams)

	Local $aFileLines[1][1]
	Local $aParamsColCount = 0
	Local $sAOIName = $sFileName
	Local $aTemp[7][1]
	Local $iLine
	Local $sRootDType
	Local $iStart, $iEnd

	$oWorkbook = _Excel_BookAttach($sFilePath)
	If Not IsObj($oWorkbook) Then
		$oExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oExcel, $sFilePath)
	Else
		$oExcel = $oWorkbook.Application
	EndIf

	$aFileLines = _Excel_RangeRead($oWorkbook, $sFileName & '-Tags')

	_Excel_BookClose($oWorkbook)

;~ 	_ArrayDisplay($aFileLines)

;~ 	_FileReadToArray($sFilePath, $aFileLines)
;~ 	_ArrayDisplay($aFileLines)
;~ 	Exit

	For $iLine = 1 To (UBound($aFileLines) - 1)
		Local $aLine[8]
		Local $aNextLine[8]

		If $iLine = (UBound($aFileLines) - 1) Then
			$bFinalLine = 1
		Else
			$bFinalLine = 0
		EndIf
		ConsoleWrite(@CRLF & '>>' & $iLine & '/' & (UBound($aFileLines) - 1))
		$aLine[0] = 7
		$aLine[1] = $aFileLines[$iLine][0]
		$aLine[2] = $aFileLines[$iLine][1]
		$aLine[3] = $aFileLines[$iLine][2]
		$aLine[4] = $aFileLines[$iLine][3]
		$aLine[5] = $aFileLines[$iLine][4]
		$aLine[6] = $aFileLines[$iLine][5]
		$aLine[7] = $aFileLines[$iLine][6]

		If Not $bFinalLine Then
			$aNextLine[0] = 7
			$aNextLine[1] = $aFileLines[$iLine + 1][0]
			$aNextLine[2] = $aFileLines[$iLine + 1][1]
			$aNextLine[3] = $aFileLines[$iLine + 1][2]
			$aNextLine[4] = $aFileLines[$iLine + 1][3]
			$aNextLine[5] = $aFileLines[$iLine + 1][4]
			$aNextLine[6] = $aFileLines[$iLine + 1][5]
			$aNextLine[7] = $aFileLines[$iLine + 1][6]

		EndIf


		For $x = 1 To $aLine[0]
			$aLine[$x] = StringReplace($aLine[$x], '"', '')
		Next

		$sType = $aLine[1]
		$sName = $aLine[3]
		$sDesc = $aLine[4]
		$sDType = $aLine[5]
		$sSpec = $aLine[6]
		$sAtt = $aLine[7]


		If $sType = 'ALIAS' Then ContinueLoop

		If StringInStr($sAtt, 'Usage := ') Then
			$iStart = StringInStr($sAtt, 'Usage := ') + StringLen('Usage := ')
			$iEnd = StringInStr($sAtt, ',', 0, 1, $iStart) - 1
			$iStart -= 1
			$sUsage = StringTrimLeft(StringLeft($sAtt, $iEnd), $iStart)
		Else
			$sUsage = 'Local'
		EndIf

		If $sUsage = 'Output' Then ContinueLoop

		If $sType = 'TAG' And Not $bFinalLine Then
			If $aNextLine[1] = 'COMMENT' Then
				$sRootDType = $sDType
				$sRootUsage = $sUsage
				ContinueLoop
			EndIf
		EndIf

		If $sType = 'COMMENT' Then
			$sDType = 'BOOL'
			$sName = $sSpec
		EndIf

		$iFileSearch = _ArraySearch($aFileNames, $sDType)
		If $iFileSearch >= 0 And StringLeft($sName, 4) <> 'Ref_' Then
;~ 			MsgBox(0, $sDType, $aFilePaths[$iFileSearch])
			_GetParams($aFilePaths[$iFileSearch], $aFileNames[$iFileSearch], $aTemp)


			For $x = 1 To $aTemp[0][0]
				$aParamsColCount += 1

				_ArrayColInsert($aParams, $aParamsColCount)
				$aParams[1][$aParamsColCount] = $aTemp[1][$x]
				$aParams[2][$aParamsColCount] = $aTemp[2][$x]
				$aParams[3][$aParamsColCount] = $aTemp[3][$x]
				$aParams[4][$aParamsColCount] = '.' & $sName & $aTemp[4][$x]
				$aParams[5][$aParamsColCount] = $aTemp[5][$x]
				$aParams[6][$aParamsColCount] = $aTemp[6][$x]
			Next

			ContinueLoop
;~ 			Exit
		EndIf
		If StringInStr($sAtt, 'ExternalAccess := ') Then
			$iStart = StringInStr($sAtt, 'ExternalAccess := ') + StringLen('ExternalAccess := ')
			$iEnd = StringInStr($sAtt, ',', 0, 1, $iStart) - 1
			If $iEnd < 0 Then
				$iEnd = StringInStr($sAtt, ')', 0, 1, $iStart) - 1
			EndIf
			$iStart -= 1
			$sAccess = StringTrimLeft(StringLeft($sAtt, $iEnd), $iStart)
		Else
			$sAccess = ''
		EndIf

		If $sAccess <> 'Read/Write' Then ContinueLoop


;~ 		If StringLeft($sName, 4) = 'CFG_' Or $sName = 'Inp_Sim' Then
		If StringLeft($sName, 4) <> 'Wrk_' Then

			If StringInStr($sDType, '[') Then
				$iStart = StringInStr($sDType, '[') + StringLen('[')
				$iEnd = StringInStr($sDType, ']', 0, 1, $iStart) - 1
				$iStart -= 1
				$iArraySize = StringTrimLeft(StringLeft($sDType, $iEnd), $iStart)
			Else
				$iArraySize = 0
			EndIf
			If $iArraySize > 0 Then
				For $iArrayIndex = 0 To $iArraySize - 1
					$aParamsColCount += 1
					$aParams[0][0] = $aParamsColCount
					_ArrayColInsert($aParams, $aParamsColCount)
					$aParams[1][$aParamsColCount] = $sDesc
					$aParams[2][$aParamsColCount] = $sUsage
					$aParams[3][$aParamsColCount] = $sDType
					$aParams[4][$aParamsColCount] = '.' & StringLeft($sName, StringInStr($sName, '_'))
					$aParams[5][$aParamsColCount] = StringReplace('.' & $sName, $aParams[4][$aParamsColCount], '') & '[' & $iArrayIndex & ']'
					$aParams[6][$aParamsColCount] = ''
				Next
			Else
				$aParamsColCount += 1
				$aParams[0][0] = $aParamsColCount
				_ArrayColInsert($aParams, $aParamsColCount)
				$aParams[1][$aParamsColCount] = $sDesc
				$aParams[2][$aParamsColCount] = $sUsage
				$aParams[3][$aParamsColCount] = $sDType
				$aParams[4][$aParamsColCount] = '.' & StringLeft($sName, StringInStr($sName, '_'))
				$aParams[5][$aParamsColCount] = StringReplace('.' & $sName, $aParams[4][$aParamsColCount], '')
				$aParams[6][$aParamsColCount] = ''
			EndIf
		EndIf
	Next
;~ 	If $sFileName = 'CM_PIDE' Then _ArrayDisplay($aParams)
	If UBound($aParams, 2) - 1 > 252 Then
		MsgBox(0, 'Too Many Columns!!!', UBound($aParams, 2) - 1)
		Exit
	EndIf
EndFunc   ;==>_GetParams


; #FUNCTION# ====================================================================================================================
; Name ..........: _AddSheet
; Description ...:
; Syntax ........: _AddSheet($sFileName, $aParams)
; Parameters ....: $sFileName           - a string value.
;                  $aParams             - an array of unknowns.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _AddSheet($sFileName, $aParams)
	Local $aSheetList[1][1]


	$oWorkbook = _Excel_BookAttach($sWorkbookPath)
	If Not IsObj($oWorkbook) Then
		$oExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
	Else
		$oExcel = $oWorkbook.Application
	EndIf
	$aSheetList = _Excel_SheetList($oWorkbook)

	$oNewSheet = _Excel_SheetCopyMove($oWorkbook, 'P_Motor', $oWorkbook, $aSheetList[UBound($aSheetList) - 1][0], False)
	$oNewSheet.Name = $sFileName

	$sAOIDesc = _GetAOIDesc($sFileName)
	$sAOIRev = _GetAOIRev($sFileName)

	$iSetupRow = $iSheetNum + 1
	_Excel_RangeWrite($oWorkbook, 'Setup', $iSheetNum, 'A' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', $sFileName, 'B' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', $sFileName, 'C' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', '=ROWS(INDIRECT(CONCATENATE(H' & $iSetupRow & ',"!$C$10:$C$65536")))-COUNTBLANK(INDIRECT(CONCATENATE(H' & $iSetupRow & ',"!$C$10:$C$65536")))', 'D' & $iSetupRow, False)
	_Excel_RangeWrite($oWorkbook, 'Setup', '=COLUMNS(INDIRECT(CONCATENATE(H' & $iSetupRow & ',"!$E$7:$IV$7"))) -COUNTBLANK(INDIRECT(CONCATENATE(H' & $iSetupRow & ',"!$E$7:$IV$7")))', 'E' & $iSetupRow, False)
	_Excel_RangeWrite($oWorkbook, 'Setup', 'RSLinx OPC SERVER', 'F' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', 'CLD_L5', 'G' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', $sFileName, 'H' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', 7, 'I' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', 4, 'J' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', 'N', 'K' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', 250, 'L' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', 1, 'M' & $iSetupRow)
	_Excel_RangeWrite($oWorkbook, 'Setup', $sAOIRev, 'N' & $iSetupRow)

	_Excel_RangeWrite($oWorkbook, $sFileName, $sFileName, 'A1')
	_Excel_RangeWrite($oWorkbook, $sFileName, $sFileName & ': ' & $sAOIDesc, 'B1')

	$oSheet = $oWorkbook.WorkSheets.Item($sFileName)
	_ArrayColDelete($aParams, 0)
	_ArrayTranspose($aParams)
	_ArrayColInsert($aParams, 6)
	For $iInc = 0 To UBound($aParams) - 1
		$aParams[$iInc][6] = $aParams[$iInc][4] & $aParams[$iInc][5]
		$aParams[$iInc][4] = "'" & $aParams[$iInc][4]
		$aParams[$iInc][5] = "'" & $aParams[$iInc][5]
	Next
	_ArraySort($aParams, 0, 0, 0, 6)
	_ArrayColDelete($aParams, 6)
;~ 	_ArrayDisplay($aParams)
	_ArrayTranspose($aParams)
;~ 	_ArrayDisplay($aParams)
	If (UBound($aParams, 2) - 1) > 0 Then
		_Excel_RangeCopyPaste($oSheet, 'E:E', 'F:' & _Excel_ColumnToLetter((UBound($aParams, 2) - 1) + 5), False, $xlPasteFormats)
	EndIf
	_Excel_RangeWrite($oWorkbook, $sFileName, $aParams, 'E3')
;~ 	For $iColumn = 1 To (UBound($aParams, 2) - 1)
;~ 		$sColumnLetter = _Excel_ColumnToLetter($iColumn + 4)

;~ 		ConsoleWrite(@CRLF & '++>' & $sColumnLetter & '/' & _Excel_ColumnToLetter((UBound($aParams, 2) - 1)))

;~ 		If $sColumnLetter <> 'E' Then
;~ 			_Excel_RangeCopyPaste($oSheet, 'E:E', $sColumnLetter & ':' & $sColumnLetter, False, $xlPasteFormats)
;~ 		EndIf

;~ 		For $iRow = 1 To 6
;~ 			_Excel_RangeWrite($oWorkbook, $sFileName, $aParams[$iRow][$iColumn], $sColumnLetter & ($iRow + 3))
;~ 		Next
;~ 	Next

EndFunc   ;==>_AddSheet

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetAOIDesc
; Description ...:
; Syntax ........: _GetAOIDesc($sFileName)
; Parameters ....: $sFileName           - a string value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetAOIDesc($sFileName)
	Local $aL5XFileLines[1]
	$aFileRoot = 'C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\Programming\Exports\AOIs\'

	_FileReadToArray($aFileRoot & $sFileName & '.L5X', $aL5XFileLines)

	$sAOIDesc = StringReplace(StringReplace($aL5XFileLines[2], '<!--', ''), '-->', '')
	Return ($sAOIDesc)
EndFunc   ;==>_GetAOIDesc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetAOIRev
; Description ...:
; Syntax ........: _GetAOIRev($sFileName)
; Parameters ....: $sFileName           - a string value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetAOIRev($sFileName)
	Local $aL5XFileLines[1]
	Local $iStart, $iEnd
	$aFileRoot = 'C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\Programming\Exports\AOIs\'

	_FileReadToArray($aFileRoot & $sFileName & '.L5X', $aL5XFileLines)

	$iStart = StringInStr($aL5XFileLines[3], 'TargetRevision="') + StringLen('TargetRevision="')
	$iEnd = StringInStr($aL5XFileLines[3], ' ', 0, 1, $iStart) - 1
	$iStart -= 1
	$sAOIRev = StringTrimLeft(StringLeft($aL5XFileLines[3], $iEnd), $iStart)
	Return ($sAOIRev)
EndFunc   ;==>_GetAOIRev

; #FUNCTION# ====================================================================================================================
; Name ..........: _Exit
; Description ...:
; Syntax ........: _Exit()
; Parameters ....: None
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Exit()
	Exit
EndFunc   ;==>_Exit




