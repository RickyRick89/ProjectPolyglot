#include <Excel.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

Local $aFileLines[1]

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GEMS_ConfigTool\GEMS_ConfigTool.xls"
$sAOIPath = 'C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\Programming\Exports\AOIs\'
$sSheetName = 'Motor List'
$sFileExt = '.L5X'
$sLineSearchText = '<Parameter '
$sNameSearchText = 'Name="'



$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf


$aFilePaths = _FileListToArray($sAOIPath, '*' & $sFileExt, $FLTA_FILES, True)
$aFileNames = _FileListToArray($sAOIPath, '*' & $sFileExt, $FLTA_FILES, False)

For $iFileInc = 1 To $aFilePaths[0]
	Local $aParams[7][1]
	Local $aSubAOIs[1][1]
	Local $aSubAOIParams[100][100][100]  ;[AOIs][PARAMS][PROPERTIES]
	$aParamsColCount = 0
	$aSubAOIParamsXPOS = 0
	$aSubAOIParamsYPOS = 0
	$aSubAOIParamsZPOS = 0
	$iMaxColumn = 1
	$bSkip = 0
	$iSubAOIColumn = 0
	$sAOIName = StringReplace($aFileNames[$iFileInc], $sFileExt, '')

	_FileReadToArray($aFilePaths[$iFileInc], $aFileLines)

	$sAOIDesc = StringReplace(StringReplace($aFileLines[2], '<!--', ''), '-->', '')

;~ 	_ArrayDisplay($aFileLines)

	For $iLine = 1 To $aFileLines[0]
		$sLineText = $aFileLines[$iLine]
		If StringInStr($sLineText, '<EncodedData ') Then
			$iSubAOIIndex = _ArrayAdd($aSubAOIs, '')
			$iStart = StringInStr($sLineText, $sNameSearchText) + StringLen($sNameSearchText)
			$iEnd = StringInStr($sLineText, '"', 0, 1, $iStart) - 1
			$iStart -= 1
			$sSubAOIName = StringTrimLeft(StringLeft($sLineText, $iEnd), $iStart)
			$aSubAOIParamsXPOS += 1
			$aSubAOIParams[$aSubAOIParamsXPOS][0][0] = $sSubAOIName
			$bSkip = 1
			ContinueLoop
		ElseIf StringInStr($sLineText, '</EncodedData>') Then
			$aSubAOIParamsYPOS = 0
			$aSubAOIParamsZPOS = 0
			$bSkip = 0
			ContinueLoop
		ElseIf $bSkip = 1 Then
			If StringInStr($sLineText, $sLineSearchText) Then
				$iStart = StringInStr($sLineText, $sNameSearchText) + StringLen($sNameSearchText)
				$iEnd = StringInStr($sLineText, '"', 0, 1, $iStart) - 1
				$iStart -= 1
				$sParameter = StringTrimLeft(StringLeft($sLineText, $iEnd), $iStart)
				If StringLeft($sParameter, 4) = 'CFG_' Or $sParameter = 'Inp_Sim' Then
					$aSubAOIParamsYPOS += 1
					$aSubAOIParams[$aSubAOIParamsXPOS][$aSubAOIParamsYPOS][0] = $sParameter

					$aSubAOIParamsZPOS += 1
					$aSubAOIParams[$aSubAOIParamsXPOS][$aSubAOIParamsYPOS][$aSubAOIParamsZPOS] = StringReplace(StringReplace($aFileLines[$iLine + 2], '<![CDATA[', ''), ']]>', '')

					$aSubAOIParamsZPOS += 1
					$iStart = StringInStr($sLineText, 'Usage="') + StringLen('Usage="')
					$iEnd = StringInStr($sLineText, '"', 0, 1, $iStart) - 1
					$iStart -= 1
					$sProperty = StringTrimLeft(StringLeft($sLineText, $iEnd), $iStart)
					$aSubAOIParams[$aSubAOIParamsXPOS][$aSubAOIParamsYPOS][$aSubAOIParamsZPOS] = $sProperty

					$aSubAOIParamsZPOS += 1
					$iStart = StringInStr($sLineText, 'DataType="') + StringLen('DataType="')
					$iEnd = StringInStr($sLineText, '"', 0, 1, $iStart) - 1
					$iStart -= 1
					$sProperty = StringTrimLeft(StringLeft($sLineText, $iEnd), $iStart)
					$aSubAOIParams[$aSubAOIParamsXPOS][$aSubAOIParamsYPOS][$aSubAOIParamsZPOS] = $sProperty

					If StringInStr($aFileLines[$iLine + 8], '<DataValue') Then
						$aSubAOIParamsZPOS += 1
						$iStart = StringInStr($sLineText, 'Value="') + StringLen('Value="')
						$iEnd = StringInStr($sLineText, '"', 0, 1, $iStart) - 1
						$iStart -= 1
						$sProperty = StringTrimLeft(StringLeft($sLineText, $iEnd), $iStart)
						$aSubAOIParams[$aSubAOIParamsXPOS][$aSubAOIParamsYPOS][$aSubAOIParamsZPOS] = $sProperty
					EndIf


				EndIf
			EndIf
			ContinueLoop
		EndIf

		If StringInStr($sLineText, $sLineSearchText) Then
			$bAdded = 0

			$iStart = StringInStr($sLineText, 'DataType="') + StringLen('DataType="')
			$iEnd = StringInStr($sLineText, '"', 0, 1, $iStart) - 1
			$iStart -= 1
			$sDType = StringTrimLeft(StringLeft($sLineText, $iEnd), $iStart)

			$iStart = StringInStr($sLineText, $sNameSearchText) + StringLen($sNameSearchText)
			$iEnd = StringInStr($sLineText, '"', 0, 1, $iStart) - 1
			$iStart -= 1
			$sParameter = StringTrimLeft(StringLeft($sLineText, $iEnd), $iStart)

			If $sDType = 'I_Alarm' Then MsgBox(0, '', $sDType)
			For $iDTypeLookup = 1 To UBound($aSubAOIParams) - 1
				If $aSubAOIParams[$iDTypeLookup][0][0] = 0 Then ExitLoop

				If $sDType = $aSubAOIParams[$iDTypeLookup][0][0] Then

					For $iParameterCopy = 1 To UBound($aSubAOIParams, 2) - 1
						If $aSubAOIParams[$iDTypeLookup][$iParameterCopy][0] = 0 Then ExitLoop
						$aParamsColCount += 1
						_ArrayColInsert($aParams, $aParamsColCount)
						$iStart = StringInStr($aSubAOIParams[$iDTypeLookup][$iParameterCopy][0], '_') + 1
						$sFirstLine = '.' & $sParameter & '.' & StringLeft($aSubAOIParams[$iDTypeLookup][$iParameterCopy][0], $iStart)
						MsgBox(0, '', $sFirstLine)
						Exit

					Next
					$bAdded = 1
				EndIf


			Next


			If StringLeft($sParameter, 4) = 'CFG_' Or $sParameter = 'Inp_Sim' And Not $bAdded Then
				_ArrayAdd($aParams, $sParameter)
			EndIf
		EndIf
	Next
	_ArraySort($aParams)
	_ArrayColInsert($aParams, 1)
	_ArrayDisplay($aParams)
	Exit

Next


Func _Exit()
	Exit
EndFunc   ;==>_Exit


