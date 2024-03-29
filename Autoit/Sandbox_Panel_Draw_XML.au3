#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\Instrument_List\Motor And Instrument List Rev 0.8.xlsx"
$sSheetName = 'Instrument List'
$sSheetName2 = 'New Control Panel Connection'
$sWinTitle = 'Sandbox.odg - LibreOffice Draw'
$sWinTitleArea = 'Area'
$sWinTitleSize = 'Position and Size'

$sPageTemplate = FileRead("C:\Users\rgrov\Downloads\Page_Template.xml")
$sShapeTemplate = FileRead("C:\Users\rgrov\Downloads\Shape_Template.xml")
$sConnTemplate = FileRead("C:\Users\rgrov\Downloads\Conn_Template.xml")


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)
$aPanelSheet = _Excel_RangeRead($oWorkbook, $sSheetName2)

_ArrayDelete($aSheet, 0)
_ArrayDelete($aPanelSheet, 0)
;~ _ArraySort($aSheet, 0, 0, 0, 9)
_ArrayDisplay($aSheet)
_ArrayDisplay($aPanelSheet)
;~ Exit

$sLastWiredTo = ''
$iInstCount = 0
$iPanelCount = 0

Local $aAddedPanels[1][3]

$iWidth = 0.953
$iHeight = 0.318

$sBody = ''
$iPageNum = 1
$sBody &= '	<draw:page draw:name="page' & $iPageNum & '" draw:style-name="dp2" draw:master-page-name="Default">'
For $iRow = 0 To UBound($aPanelSheet) - 1
	$sStatus = $aPanelSheet[$iRow][5]
	$sWiredTo = $aPanelSheet[$iRow][3]
	$sID = $aPanelSheet[$iRow][0]
	$sSigType = $aPanelSheet[$iRow][2]

	If $sStatus <> 'Active' Or $sID = '' Then ContinueLoop

	ConsoleWrite(@CRLF & '-->' & $sID)

	$sWiredToPretty = StringStripWS(StringReplace(StringReplace(StringReplace($sWiredTo, '_', ''), '-', ''), '/', ''), 8)
	$sIDPretty = StringStripWS(StringReplace(StringReplace(StringReplace($sID, '_', ''), '-', ''), '/', ''), 8)

	$iWiredToIsID = _ArraySearch($aPanelSheet, $sWiredTo, 0, 0, 0, 0, 1, 0)

;~ 	If $sStatus <> 'Active' Or $sWiredTo = '' Or $iWiredToIsID >= 0 Then ContinueLoop

	$iWiredToIndex = _ArraySearch($aAddedPanels, $sWiredTo, 0, 0, 0, 0, 1, 0)
	$iPanelIndex = _ArraySearch($aAddedPanels, $sID, 0, 0, 0, 0, 1, 0)

;~ 	Switch $sSigType
;~ 		Case 'AS-I'
;~ 			$iStyle = 'ASI'
;~ 		Case 'AI'
;~ 			$iStyle = 'Analog'
;~ 		Case 'DO'
;~ 			$iStyle = 'Digital'
;~ 		Case 'DI'
;~ 			$iStyle = 'Digital'
;~ 		Case 'DI/DO'
;~ 			$iStyle = 'Digital'
;~ 		Case 'OEM Provided'
;~ 			$iStyle = 'Unknown'
;~ 		Case 'Ethernet'
;~ 			$iStyle = 'Ethernet'
;~ 		Case 'Load Cell'
;~ 			$iStyle = 'Unknown'
;~ 		Case 'AI/24VDC'
;~ 			$iStyle = 'Analog'
;~ 		Case 'AI/AO'
;~ 			$iStyle = 'Analog'
;~ 		Case 'AI(RTD)'
;~ 			$iStyle = 'Analog'
;~ 		Case '?'
;~ 			$iStyle = 'Unknown'
;~ 		Case 'RTD'
;~ 			$iStyle = 'Analog'
;~ 		Case Else
;~ 			$iStyle = 'Unknown'
;~ 	EndSwitch

	$iStyle = 'Unknown'

	$sWiredToExtended = $sWiredTo
	$sPanelIDExtended = $sID

	$iStart = 0
	While 1
		$iStart = _ArraySearch($aPanelSheet, $sWiredTo, $iStart, 0, 0, 0, 1, 3)
		If $iStart < 0 Then ExitLoop
		If $aPanelSheet[$iStart][5] <> 'Active' Then
			$iStart += 1
			ContinueLoop
		EndIf
		$sWiredToExtended &= '|##' & $aPanelSheet[$iStart][0]
		$iStart += 1
	WEnd

	$iStart = 0
	While 1
		$iStart = _ArraySearch($aPanelSheet, $sID, $iStart, 0, 0, 0, 1, 3)
		If $iStart < 0 Then ExitLoop
		If $aPanelSheet[$iStart][5] <> 'Active' Then
			$iStart += 1
			ContinueLoop
		EndIf
		$sPanelIDExtended &= '|##' & $aPanelSheet[$iStart][0]
		$iStart += 1
	WEnd

	$iStart = 0
	While 1
		$iStart = _ArraySearch($aPanelSheet, $sWiredTo, $iStart, 0, 0, 0, 1, 9)
		If $iStart < 0 Then ExitLoop
		If $aSheet[$iStart][21] <> 'Active' Then
			$iStart += 1
			ContinueLoop
		EndIf
		$sWiredToExtended &= '|*' & $aSheet[$iStart][2]
		$iStart += 1
	WEnd

	$iStart = 0
	While 1
		$iStart = _ArraySearch($aSheet, $sID, $iStart, 0, 0, 0, 1, 9)
		If $iStart < 0 Then ExitLoop
		If $aSheet[$iStart][21] <> 'Active' Then
			$iStart += 1
			ContinueLoop
		EndIf
		$sPanelIDExtended &= '|*' & $aSheet[$iStart][2]
		$iStart += 1
	WEnd

	If $iWiredToIndex < 0 Then
;~ 		$iPanelCount = 0
;~ 		$iPageNum += 1
;~ 		$sBody &= '   </draw:page>'
;~ 		$sBody &= '	<draw:page draw:name="page' & $iPageNum & '" draw:style-name="dp2" draw:master-page-name="Default">'


		$iLeft = 1.317 + Mod($iPanelCount, 20) * 1
		$iTop = 5 + Floor($iPanelCount / 20) * .5

		$sTemp = $sShapeTemplate
		$sTemp = StringReplace($sTemp, '[ShapeStyle]', 'Panel')
		$sTemp = StringReplace($sTemp, '[ShapeID]', $sWiredToPretty)
		$sTemp = StringReplace($sTemp, '[ShapeWidth]', $iWidth & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeHeight]', $iHeight & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeLeft]', $iLeft & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeTop]', $iTop & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeText]', StringReplace($sWiredToExtended, '|', '</text:span></text:p>' & @CRLF & '<text:p text:style-name="P1"><text:span text:style-name="T1">'))

		$sBody &= @CRLF & $sTemp

		$iWiredToIndex = _ArrayAdd($aAddedPanels, $sWiredTo & '|' & $iLeft & '|' & $iTop)
		$iPanelCount += 1
	EndIf

	If $iPanelIndex < 0 Then
		$iLeft = 1.317 + Mod($iPanelCount, 20) * 1
		$iTop = 5 + Floor($iPanelCount / 20) * .5

		$sTemp = $sShapeTemplate
		$sTemp = StringReplace($sTemp, '[ShapeStyle]', $iStyle)
		$sTemp = StringReplace($sTemp, '[ShapeID]', $sIDPretty)
		$sTemp = StringReplace($sTemp, '[ShapeWidth]', $iWidth & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeHeight]', $iHeight & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeLeft]', $iLeft & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeTop]', $iTop & 'cm')
		$sTemp = StringReplace($sTemp, '[ShapeText]', StringReplace($sPanelIDExtended, '|', '</text:span></text:p>' & @CRLF & '<text:p text:style-name="P1"><text:span text:style-name="T1">'))

		$sBody &= @CRLF & $sTemp

		$iPanelIndex = _ArrayAdd($aAddedPanels, $sID & '|' & $iLeft & '|' & $iTop)

		$iPanelCount += 1
	EndIf



	$sTemp = $sConnTemplate
	$sTemp = StringReplace($sTemp, '[ConnStyle]', 'Conn')
	$sTemp = StringReplace($sTemp, '[ConnLeft1]', ($aAddedPanels[$iPanelIndex][1] + ($iWidth / 2)) & 'cm')
	$sTemp = StringReplace($sTemp, '[ConnTop1]', ($aAddedPanels[$iPanelIndex][2]) & 'cm')
	$sTemp = StringReplace($sTemp, '[ConnLeft2]', ($aAddedPanels[$iWiredToIndex][1] + ($iWidth / 2)) & 'cm')
	$sTemp = StringReplace($sTemp, '[ConnTop2]', ($aAddedPanels[$iWiredToIndex][2] + $iHeight) & 'cm')
	$sTemp = StringReplace($sTemp, '[ConnShape1]', $sIDPretty)
	$sTemp = StringReplace($sTemp, '[ConnShape2]', $sWiredToPretty)
	$sTemp = StringReplace($sTemp, '[ConnText]', $sSigType)

	$sBody &= @CRLF & $sTemp
;~ 	Exit
Next


$sBody &= '   </draw:page>'

_FileCreate("C:\Users\rgrov\Downloads\Trial.fodg")
FileWrite("C:\Users\rgrov\Downloads\Trial.fodg", (StringReplace($sPageTemplate, '[PAGE]', $sBody)))

Func _Exit()
	Exit
EndFunc   ;==>_Exit
