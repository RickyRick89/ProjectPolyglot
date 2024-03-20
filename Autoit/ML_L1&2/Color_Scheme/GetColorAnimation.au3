#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sFileDir = "Y:\My_Scripts\ML_L1&2\Color_Scheme\Exports\PLP\"

$aFiles = _FileListToArray($sFileDir, '*.xml', $FLTA_FILES, True)
_ArrayDelete($aFiles, 0)

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


$oExcel = _Excel_Open()
$oWorkBook = _Excel_BookNew($oExcel)



For $sFile In $aFiles
	Local $aFileLines[1], $aItemName[1], $aItemsAdded[1]
	Local $bAnimateColor, $sExpression
	$aAnimationSettings = $aAnimationSettingsInit

	If Not StringInStr($sFile, 'Graphics Library') Then ContinueLoop


	$sDisplayName = StringLeft(StringReplace(StringTrimLeft($sFile, StringInStr($sFile, '\', 0, -1)), '.xml', ''), 31)

	_Excel_SheetAdd($oWorkBook, Default, False, 1, $sDisplayName)
	ConsoleWrite(@CRLF & '---->' & $sDisplayName)

	_FileReadToArray($sFile, $aFileLines)
	_ArrayDelete($aFileLines, 0)

	$iItems = 0
	$iLines = 0
	For $sLine In $aFileLines
		$iLines += 1

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
			$iArrayIndex = _ArraySearch($aItemsAdded, $aItemName[UBound($aItemName) - 1])
			If $iArrayIndex < 0 Then
				_ArrayAdd($aItemsAdded, $aItemName[UBound($aItemName) - 1])
				_Excel_RangeWrite($oWorkBook, $sDisplayName, $aAnimationSettings, _Excel_ColumnToLetter(($iItems * UBound($aAnimationSettings, 2)) + 1) & '1')
				$iItems += 1
			Else
				ConsoleWrite(@CRLF & '^^^^^^^^Skipped @Line ' & $iLines)
			EndIf

			$sExpression = ''
			$aAnimationSettings = $aAnimationSettingsInit
			$bAnimateColor = False
		EndIf
		If $bAnimateColor Then
			$aAnimationSettings[0][0] = $aItemName[UBound($aItemName) - 1]
			$aAnimationSettings[0][1] = $sExpression
;~ 			_ArrayDisplay($aItemName)

			$vReturn = _LineSearch($sLine, '<color ')
			If $vReturn <> -1 Then
				$sNewLine = ''

				$vReturn = _LineSearch($sLine, 'value="')
				If $vReturn <> -1 Then
					$sNewLine = '|' & $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'foreBehavior="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'foreColor1="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'foreColor2="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'backBehavior="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'backColor1="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'backColor2="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'fillColorMode="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'endColor="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'gradientStop="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'gradientDirection="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'gradientShadingStyle="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'fillEndColor="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'fillGradientStop="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'fillGradientDirection="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn & '|'
				EndIf
				$vReturn = _LineSearch($sLine, 'fillGradientShadingStyle="')
				If $vReturn <> -1 Then
					$sNewLine &= $vReturn
				EndIf
;~ 				MsgBox(0,'',$sNewLine)
				_ArrayAdd($aAnimationSettings, $sNewLine)

			EndIf
		EndIf



	Next



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

Func _Exit()
	Exit
EndFunc   ;==>_Exit


