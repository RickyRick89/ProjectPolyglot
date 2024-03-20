#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sFileDir = "Y:\My_Scripts\ML_L1&2\Color_Scheme\Exports\ML\"

$aFiles = _FileListToArray($sFileDir, '*.xml', $FLTA_FILES, True)
$aFileNames = _FileListToArray($sFileDir, '*.xml', $FLTA_FILES, False)
_ArrayDelete($aFiles, 0)
_ArrayDelete($aFileNames, 0)

Local $aAnimationSettingsInit[2][17]
$aAnimationSettingsInit[1][0] = 'Description'
$aAnimationSettingsInit[1][1] = 'value'
$aAnimationSettingsInit[1][2] = 'foreBehavior'
$aAnimationSettingsInit[1][3] = 'foreColor1'
$aAnimationSettingsInit[1][4] = 'foreColor2'
$aAnimationSettingsInit[1][5] = 'backBehavior'
$aAnimationSettingsInit[1][6] = 'backColor1'
$aAnimationSettingsInit[1][7] = 'backColor2'
$aAnimationSettingsInit[1][8] = 'fillColorMode'
$aAnimationSettingsInit[1][9] = 'endColor'
$aAnimationSettingsInit[1][10] = 'gradientStop'
$aAnimationSettingsInit[1][11] = 'gradientDirection'
$aAnimationSettingsInit[1][12] = 'gradientShadingStyle'
$aAnimationSettingsInit[1][13] = 'fillEndColor'
$aAnimationSettingsInit[1][14] = 'fillGradientStop'
$aAnimationSettingsInit[1][15] = 'fillGradientDirection'
$aAnimationSettingsInit[1][16] = 'fillGradientShadingStyle'


$sMLWorkbookPath = "Y:\My_Scripts\ML_L1&2\Color_Scheme\NewColors\ML_Colors.xlsx"

$oMLWorkbook = _Excel_BookAttach($sMLWorkbookPath)
If Not IsObj($oMLWorkbook) Then
	$oExcel = _Excel_Open()
	$oMLWorkbook = _Excel_BookOpen($oExcel, $sMLWorkbookPath)
Else
	$oExcel = $oMLWorkbook.Application
EndIf

$aMLSheets2D = _Excel_SheetList($oMLWorkbook)

Local $aMLSheets[UBound($aMLSheets2D)]

For $x = 0 To UBound($aMLSheets2D) - 1
	$aMLSheets[$x] = $aMLSheets2D[$x][0]
Next



For $iFile = 0 To UBound($aFiles) - 1
	$sFile = $aFiles[$iFile]
	Local $aFileLines[1], $aItemName[1]
	Local $bAnimateColor, $sExpression
	$aAnimationSettings = $aAnimationSettingsInit

	If Not StringInStr($sFile, 'Graphics Library') Then ContinueLoop

	$sDisplayName = StringLeft(StringReplace(StringTrimLeft($sFile, StringInStr($sFile, '\', 0, -1)), '.xml', ''), 31)

	$bFound = False
	For $sMLSheet In $aMLSheets
		If $sMLSheet = $sDisplayName Then
			$bFound = True
			ExitLoop
		EndIf
	Next

	If Not $bFound Then
		MsgBox(0, '', $sDisplayName & '-Not Found')
	EndIf

	$aMLValues = _Excel_RangeRead($oMLWorkbook, $sDisplayName)


	ConsoleWrite(@CRLF & '---->' & $sDisplayName)

	_FileReadToArray($sFile, $aFileLines)
	_ArrayDelete($aFileLines, 0)


	For $iLine = 0 To UBound($aFileLines) - 1
		$sLine = $aFileLines[$iLine]

		$vReturn = _LineSearch($sLine, 'name="')
		If $vReturn <> -1 Then
			$vReturn = StringRegExpReplace($vReturn, '(\d)', '')
			_ArrayAdd($aItemName, $vReturn)
		EndIf
		If StringInStr($sLine, '</group') Then
			If UBound($aItemName) > 1 Then _ArrayDelete($aItemName, UBound($aItemName) - 1)
		EndIf
		If StringInStr($sLine, 'name="') And StringInStr($sLine, '/>') Then
			If UBound($aItemName) > 1 Then _ArrayDelete($aItemName, UBound($aItemName) - 1)
		EndIf

		$vReturn = _LineSearch($sLine, '<animateColor ')
		If $vReturn <> -1 Then
			$vReturn = _LineSearch($sLine, 'expression="')
			If $vReturn <> -1 Then
				$sExpression = $vReturn
			EndIf
			$bAnimateColor = True
		EndIf
		$vReturn = _LineSearch($sLine, '</animateColor>')
		If $vReturn <> -1 Then
;~ 			_ArrayDisplay($aAnimationSettings)
			ConsoleWrite(@CRLF & '+++++++>' & $aItemName[UBound($aItemName) - 1])
			ConsoleWrite(@CRLF & '^^^^^^^ Row' & $iLine)

			$sExpression = ''
			$aAnimationSettings = $aAnimationSettingsInit
			$bAnimateColor = False
		EndIf
		If $bAnimateColor Then
			$aAnimationSettings[0][0] = $aItemName[UBound($aItemName) - 1]
			$aAnimationSettings[0][1] = $sExpression
;~ 			_ArrayDisplay($aItemName)

			For $iMLCol = 0 To UBound($aMLValues, 2) - 1
				If $aMLValues[0][$iMLCol] <> '' And $aMLValues[1][$iMLCol] = 'Description' Then
					$sItem = $aMLValues[0][$iMLCol]
					If $sItem = $aAnimationSettings[0][0] Then
						$iItemCol = $iMLCol
						ExitLoop
					EndIf
				EndIf
				If $iMLCol = UBound($aMLValues, 2) - 1 Then
					MsgBox(0, '', 'Item-' & $aAnimationSettings[0][0] & '-Not Found')
					Exit
				EndIf
			Next

			$vReturn = _LineSearch($sLine, '<color ')
			If $vReturn <> -1 Then
				$sNewLine = ''

				$vReturn = _LineSearch($sLine, 'value="')
				If $vReturn <> -1 Then
					For $iMLRow = 2 To UBound($aMLValues) - 1
						$sDesc = $aMLValues[$iMLRow][$iItemCol]
						$iValue = $aMLValues[$iMLRow][$iItemCol + 1]
						If $iValue = $vReturn Then

							_LineSearchReplace($sLine, 'foreBehavior="', $aMLValues[$iMLRow][$iItemCol + 2])
							_LineSearchReplace($sLine, 'foreColor1="', $aMLValues[$iMLRow][$iItemCol + 3])
							_LineSearchReplace($sLine, 'foreColor2="', $aMLValues[$iMLRow][$iItemCol + 4])
							_LineSearchReplace($sLine, 'backBehavior="', $aMLValues[$iMLRow][$iItemCol + 5])
							_LineSearchReplace($sLine, 'backColor1="', $aMLValues[$iMLRow][$iItemCol + 6])
							_LineSearchReplace($sLine, 'backColor2="', $aMLValues[$iMLRow][$iItemCol + 7])
							_LineSearchReplace($sLine, 'fillColorMode="', $aMLValues[$iMLRow][$iItemCol + 8])
							_LineSearchReplace($sLine, 'endColor="', $aMLValues[$iMLRow][$iItemCol + 9])
							_LineSearchReplace($sLine, 'gradientStop="', $aMLValues[$iMLRow][$iItemCol + 10])
							_LineSearchReplace($sLine, 'gradientDirection="', $aMLValues[$iMLRow][$iItemCol + 11])
							_LineSearchReplace($sLine, 'gradientShadingStyle="', $aMLValues[$iMLRow][$iItemCol + 12])
							_LineSearchReplace($sLine, 'fillEndColor="', $aMLValues[$iMLRow][$iItemCol + 13])
							_LineSearchReplace($sLine, 'fillGradientStop="', $aMLValues[$iMLRow][$iItemCol + 14])
							_LineSearchReplace($sLine, 'fillGradientDirection="', $aMLValues[$iMLRow][$iItemCol + 15])
							_LineSearchReplace($sLine, 'fillGradientShadingStyle="', $aMLValues[$iMLRow][$iItemCol + 16])


							$aFileLines[$iLine] = $sLine

							ConsoleWrite(@CRLF & '^^^^^^ Value ' & $iValue)

						EndIf

					Next
				EndIf

			EndIf
		EndIf



	Next


	$sNewFileText = _ArrayToString($aFileLines, @CRLF)
	$sNewFilePath = 'Y:\My_Scripts\ML_L1&2\Color_Scheme\NewColors\GlobalObjects\' & $aFileNames[$iFile]
	_FileCreate($sNewFilePath)
	FileWrite($sNewFilePath, $sNewFileText)


Next

Func _LineSearch($sLine, $sSearch)
	Local $vReturn

	If StringInStr($sLine, $sSearch) Then
		$iStart = StringInStr($sLine, $sSearch) + StringLen($sSearch)
		$iEnd = StringInStr($sLine, '"', 0, 1, $iStart)
		$vReturn = StringMid($sLine, $iStart, $iEnd - $iStart)
	Else
		$vReturn = -1
	EndIf

	Return ($vReturn)
EndFunc   ;==>_LineSearch

Func _LineSearchReplace(ByRef $sLine, $sSearch, $sNewValue)
	$sTemp = $sLine

	If StringInStr($sLine, $sSearch) Then
		$iStart = StringInStr($sLine, $sSearch) + StringLen($sSearch)
		$iEnd = StringInStr($sLine, '"', 0, 1, $iStart)
		$sBefore = StringLeft($sLine, $iStart - 1)
		$sAfter = StringTrimLeft($sLine, $iEnd - 1)
		$sLine = $sBefore & $sNewValue & $sAfter
	Else
		MsgBox(0, '', '_LineSearchReplace Error')
		Exit
	EndIf

EndFunc   ;==>_LineSearchReplace

Func _Exit()
	Exit
EndFunc   ;==>_Exit


