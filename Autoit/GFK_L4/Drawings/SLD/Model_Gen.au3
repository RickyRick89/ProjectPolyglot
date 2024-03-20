#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <String.au3>

;[INST_NAME],[DESCRIPTION],[JB_NAME],[NODE_NUM],[INPUT_NUM],[OUTPUT_NUM],[ASM_NAME],[TRUNK_NUM]

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Global $sLastSelected = 'CLXL4B_ASI01_JB01'
Global $aOptions[1] = [$sLastSelected]
Global $aJBs[1][4]
Global $iSheetX = 29.9038
Global $iSheetY = 21.25
Global $iSheetXInc = 31.9038
Global $iSheetYInc = -22.25
Global $iJBWidth = 2.5
Global $iInstSpacing = .375
Global $iJBSpacing = .25

Global $sFirstPageTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\First_Page.scr"
Global $sPLCPanelTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\PLC_Panel.scr"

Global $sNewFilePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\SLD\New_File.dwg"
Global $sFirstScriptPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\First_Page.scr"
Global $sRemotePanelPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\Remote_Panel.scr"
Global $sTempPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\Temp.scr"

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Motor And Instrument List Rev 1.xlsx"



$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf
$aInstruments = _Excel_RangeRead($oWorkbook, 'Instrument List')

$aSheet = _Excel_RangeRead($oWorkbook, 'ASi')
$aNodes = $aSheet
For $iCol = 0 To UBound($aNodes, 2) - 1
	If $aNodes[0][$iCol] <> '' Then
		ContinueLoop
	Else
		ReDim $aNodes[UBound($aNodes)][$iCol]
		ExitLoop
	EndIf
Next

$aIO = $aSheet
For $iCol = UBound($aIO, 2) - 1 To 0 Step -1
	If $aIO[0][$iCol] <> '' Then
		ContinueLoop
	Else
		For $iCol2 = $iCol To 0 Step -1
			_ArrayColDelete($aIO, $iCol2)
		Next
		ExitLoop
	EndIf
Next


$aSheet = _Excel_RangeRead($oWorkbook, 'Panels')
_ArrayColDelete($aSheet, 0)
_ArrayColDelete($aSheet, 0)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
$aMasters = $aSheet
For $iCol = 0 To UBound($aMasters, 2) - 1
	If $aMasters[0][$iCol] <> '' Then
		ContinueLoop
	Else
		ReDim $aMasters[UBound($aMasters)][$iCol]
		ExitLoop
	EndIf
Next

$aModules = $aSheet
For $iCol = UBound($aModules, 2) - 1 To 0 Step -1
	If $aModules[0][$iCol] <> '' Then
		ContinueLoop
	Else
		For $iCol2 = $iCol To 0 Step -1
			_ArrayColDelete($aModules, $iCol2)
		Next
		ExitLoop
	EndIf
Next


For $iRow = UBound($aNodes) - 1 To 0 Step -1
	If $aNodes[$iRow][0] = '' Then
		_ArrayDelete($aNodes, $iRow)
	EndIf
Next
For $iRow = UBound($aIO) - 1 To 0 Step -1
	If $aIO[$iRow][0] = '' Then
		_ArrayDelete($aIO, $iRow)
	EndIf
Next
For $iRow = UBound($aMasters) - 1 To 0 Step -1
	If $aMasters[$iRow][0] = '' Then
		_ArrayDelete($aMasters, $iRow)
	EndIf
Next
For $iRow = UBound($aModules) - 1 To 0 Step -1
	If $aModules[$iRow][0] = '' Then
		_ArrayDelete($aModules, $iRow)
	EndIf
Next


;~ _ArrayDisplay($aNodes)
;~ _ArrayDisplay($aIO)
;~ _ArrayDisplay($aMasters)
;~ _ArrayDisplay($aModules)


;~ _ArrayDisplay($aSheet)
;~ Exit


;~ _ArrayDisplay($aModules)
MsgBox(0, '', 'New_File.dwg should be closed.')
MouseMove(0, 0, 0)

;~ _OpenFile($sNewFilePath)
;~ $sNewText = 'layout delete layout1' & @CRLF
;~ $sNewText = 'layout delete layout2' & @CRLF
;~ $sNewText &= 'qsave' & @CRLF & 'close' & @CRLF
;~ _FileCreate($sTempPath)
;~ FileWrite($sTempPath, $sNewText)
;~ _RunScript($sTempPath)
;~ _CheckFileDate()
;~ Exit

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$sNewText = ''
$sNewText &= 'New "C:\Users\rgrov\AppData\Local\Autodesk\AutoCAD 2024\R24.3\enu\Template\acad.dwt"' & @CRLF
$sNewText &= '_SAVEAS' & @CRLF
$sNewText &= '' & @CRLF
$sNewText &= '"' & $sNewFilePath & '"' & @CRLF
$sNewText &= 'y' & @CRLF
$sNewText &= 'close' & @CRLF

_FileCreate($sTempPath)
FileWrite($sTempPath, $sNewText)
_RunScript($sTempPath)
_CheckFileDate()

$sNewText = ''
$sNewText &= 'OPEN "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\SLD\Templates\Sheet.dwg"' & @CRLF
$sNewText &= 'COPYBASE' & @CRLF
$sNewText &= '0,0,0' & @CRLF
$sNewText &= 'all' & @CRLF
$sNewText &= '' & @CRLF
$sNewText &= 'close y' & @CRLF

_FileCreate($sTempPath)
FileWrite($sTempPath, $sNewText)
_RunScript($sTempPath)
Sleep(10000)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$iMasterInc = 0
$sNewText = ''
$sNewText &= 'OPEN "' & $sNewFilePath & '"' & @CRLF
$sLastRemotePanel = ''
Local $aValves[1][2]

For $iRow = 1 To UBound($aMasters) - 1
	$sPanel = $aMasters[$iRow][0]
	For $iCol = 1 To UBound($aMasters, 2) - 1
		$sMaster = $aMasters[$iRow][$iCol]

		If $sMaster = '' Then ContinueLoop

		$sRemotePanel = StringLeft($sMaster, StringInStr($sMaster, '-', 0, -1) - 1)

		$iSheets = 0
		$sNewText &= _AddSheet(($iSheetXInc * $iMasterInc), 0)
		$sMasterX = ($iSheetXInc * $iMasterInc) + 3.75
		$sMasterY = -.8754
		$iSheets += 1
		$iMasterInc += 1

		$sNewText &= _AddMaster($sMasterX, $sMasterY, $sRemotePanel)

		$sJBX = $sMasterX + 5.25 + 8.375
		$sJBY = $sMasterY
		For $iInstRow = 1 To UBound($aInstruments) - 1
			$sID = $aInstruments[$iInstRow][2]
			$sConn = $aInstruments[$iInstRow][7]
			$sWiredTo = $aInstruments[$iInstRow][9]

;~ 			If Not StringInStr($sWiredTo, '-JB') Then ContinueLoop
			If Not StringInStr($sWiredTo, $sRemotePanel) Then ContinueLoop
			If $sConn = 'OEM' Then ContinueLoop

			$iArrIndex = _ArraySearch($aJBs, $sWiredTo, 0, 0, 0, 0, 1, 0)
			If Not StringInStr($sWiredTo, '-JB') Then
				_ArrayAdd($aValves, $sID & '|' & $sConn)
			Else
				If $iArrIndex < 0 Then
					$iCount = 0
					For $i = 0 To UBound($aInstruments) - 1
						If $aInstruments[$i][9] = $sWiredTo Then
							$iCount += 1
						EndIf
					Next
					$iHeight = $iCount * $iInstSpacing + $iInstSpacing
					If $iHeight < 3 Then $iHeight = 3

					If $sJBY - $iHeight < ($iSheets * $iSheetYInc) + 2 Then
;~ 					MsgBox(0, $sJBY - $iHeight, ($iSheets * $iSheetYInc) + 1)

						$sNewText &= _AddSheet(($iSheetXInc * ($iMasterInc - 1)), $iSheets * $iSheetYInc)
						$sJBY = ($iSheets * $iSheetYInc) - .8754
						$iSheets += 1
					EndIf

					$sNewText &= _AddJB($sJBX, $sJBY, $iHeight, $sWiredTo)
					$iArrIndex = _ArrayAdd($aJBs, $sWiredTo & '|' & $sJBX & '|' & $sJBY & '|1')
					$sJBY -= $iHeight + $iJBSpacing
				EndIf

				If StringInStr($sID, 'WIT') And $sConn = 'ETHERNET' Then
					$sConn = 'LOADCELL CABLE'
					$sID &= ' SUMMING BOX'
				EndIf
				$sNewText &= _AddInst($aJBs[$iArrIndex][1] + 2.5, $aJBs[$iArrIndex][2] - ($aJBs[$iArrIndex][3] * $iInstSpacing), $sConn, $sID)
				$aJBs[$iArrIndex][3] += 1
			EndIf


		Next
		For $iValveRow = 1 To UBound($aValves) - 1

			If $sJBY - $iInstSpacing < ($iSheets * $iSheetYInc) + 2 Then

;~ 					MsgBox(0, $sJBY - $iHeight, ($iSheets * $iSheetYInc) + 1)

				$sNewText &= _AddSheet(($iSheetXInc * ($iMasterInc - 1)), $iSheets * $iSheetYInc)
				$sJBY = ($iSheets * $iSheetYInc) - .8754
				$iSheets += 1
			EndIf
			$sJBY = $sJBY - $iInstSpacing

			$sNewText &= _AddValve($sJBX - 5.0938, $sJBY, $aValves[$iValveRow][1], $aValves[$iValveRow][0])
		Next
		Local $aValves[1][2]
	Next
Next
$sNewText &= 'qsave' & @CRLF
_FileCreate($sTempPath)
FileWrite($sTempPath, $sNewText)
_RunScript($sTempPath)
_CheckFileDate()

Func _AddValve($X, $Y, $sConn, $sName)
	ConsoleWrite("_AddInst(" & $X & ", " & $Y & ", " & $sConn & ", " & $sName & ")" & @CRLF)
	$sTempText = ''

	$iValveBoxHeight = .25
	$iValveBoxWidth = 2.5

	Switch $sConn
		Case 'AS-I'
			$sConnText = 'P&F VAZ-2T1-FK-G10-PTC-1M-PUR-V1-G CABLE'
			$sColor = 'Black'
		Case Else
			MsgBox(0, '', 'Connection type?')
			Exit
	EndSwitch

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= 'layer set RJX_Desc' & @CRLF & @CRLF
	$sTempText &= 'Rectangle ' & $X + 0.34 & ',' & $Y + ($iValveBoxHeight / 2) & ' ' & $X + 0.34 + 4.925 & ',' & $Y - ($iValveBoxHeight / 2) & @CRLF

	$sTempText &= 'layer set PDF2_Texto' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j middle' & @CRLF
	$sTempText &= $X + 0.34 + (4.925 / 2) & ',' & $Y & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= 'P&F VAZ-2T1-FK-G10-PTC-1M-PUR-V1-G' & @CRLF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X + 0.34 + 4.925, $Y, $X + 13.0938, $Y, 'RJX_DESC', $sColor)

	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X + 0.34 + 4.925 + ((13.0938 - 4.925 - 0.34) / 2) & ',' & $Y & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= $sConnText & @CRLF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= 'layer set RJX_Desc' & @CRLF & @CRLF
	$sTempText &= 'Rectangle ' & $X + 13.0938 & ',' & $Y + ($iValveBoxHeight / 2) & ' ' & $X + 13.0938 + $iValveBoxWidth & ',' & $Y - ($iValveBoxHeight / 2) & @CRLF

	$sTempText &= 'layer set PDF2_Texto' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j middle' & @CRLF
	$sTempText &= $X + 13.0938 + ($iValveBoxWidth / 2) & ',' & $Y & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= $sName & @CRLF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	Return $sTempText
EndFunc   ;==>_AddValve

Func _AddInst($X, $Y, $sConn, $sName)
	ConsoleWrite("_AddInst(" & $X & ", " & $Y & ", " & $sConn & ", " & $sName & ")" & @CRLF)
	$sTempText = ''

	$iInstBoxHeight = .25
	$iInstBoxWidth = 2.5

	Switch $sConn
		Case '4-WIRE'
			$sConnText = '4C-SHLD/18AWG'
			$sColor = 'Blue'
		Case '3-WIRE'
			$sConnText = '3C/18AWG'
			$sColor = 'Orange'
		Case '5-WIRE'
			$sConnText = '5C/M12'
			$sColor = 'Black'
		Case 'LOADCELL CABLE'
			$sConnText = 'LOADCELL CABLE'
			$sColor = 'Red'
		Case 'ETHERNET'
			$sConnText = 'ETHERNET'
			$sColor = 'Magenta'
		Case Else
			MsgBox(0, '', 'Connection type?')
			Exit
	EndSwitch

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X, $Y, $X + 5.5, $Y, 'RJX_DESC', $sColor)

	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X + (5.5 / 2) & ',' & $Y & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= $sConnText & @CRLF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= 'layer set RJX_Desc' & @CRLF & @CRLF
	$sTempText &= 'Rectangle ' & $X + 5.5 & ',' & $Y + ($iInstBoxHeight / 2) & ' ' & $X + 5.5 + $iInstBoxWidth & ',' & $Y - ($iInstBoxHeight / 2) & @CRLF

	$sTempText &= 'layer set PDF2_Texto' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j middle' & @CRLF
	$sTempText &= $X + 5.5 + ($iInstBoxWidth / 2) & ',' & $Y & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= $sName & @CRLF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	Return $sTempText
EndFunc   ;==>_AddInst

Func _AddJB($X, $Y, $iHeight, $sName)
	ConsoleWrite("_AddJB(" & $X & ", " & $Y & ", " & $iHeight & ", " & $sName & ")" & @CRLF)
	$sTempText = ''

	$sTempText &= 'layer set RJX_Desc' & @CRLF & @CRLF
	$sTempText &= 'Rectangle ' & $X & ',' & $Y & ' ' & $X + 2.5 & ',' & $Y - $iHeight & @CRLF

	$sTempText &= 'layer set PDF2_Texto' & @CRLF & @CRLF
	$sTempText &= '-mtext ' & $X & ',' & $Y & @CRLF
	$sTempText &= 'j mc' & @CRLF
	$sTempText &= 'h 0.18' & @CRLF
	$sTempText &= $X + 2.5 & ',' & $Y - 2 & @CRLF
	$sTempText &= $sName & @CRLF & '12H x 12W x 6D' & @CRLF & @CRLF



;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X, $Y - 2, $X - 3.125, $Y - 2, 'RJX_DESC', 'Green')
	$sTempText &= _AddLine($X - 3.125, $Y - 2, $X - 3.125, $Y - 2 - $iHeight + 1.125, 'RJX_DESC', 'Green')
	$sTempText &= _AddLine($X, $Y - 2 - $iHeight + 1.125, $X - 3.125, $Y - 2 - $iHeight + 1.125, 'RJX_DESC', 'Green')
	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X - 1.5625 & ',' & $Y - 2 & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= 'YELLOW AS-i CABLE' & @CRLF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X, $Y - 2.625, $X - 2.5, $Y - 2.625, 'RJX_DESC', 'Cyan')
	$sTempText &= _AddLine($X - 2.5, $Y - 2.625, $X - 2.5, $Y - 2.625 - $iHeight + 1.125, 'RJX_DESC', 'Cyan')
	$sTempText &= _AddLine($X, $Y - 2.625 - $iHeight + 1.125, $X - 2.5, $Y - 2.625 - $iHeight + 1.125, 'RJX_DESC', 'Cyan')
	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X - 1.25 & ',' & $Y - 2.625 & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= 'BLACK AS-i CABLE' & @CRLF




	Return $sTempText


EndFunc   ;==>_AddJB

Func _AddMaster($X, $Y, $sName)
	ConsoleWrite("_AddMaster(" & $X & ", " & $Y & ", " & $sName & ")" & @CRLF)
	$sTempText = ''

	$sTempText &= 'layer set RJX_Desc' & @CRLF & @CRLF
	$sTempText &= 'Rectangle ' & $X & ',' & $Y & ' ' & $X + 5.25 & ',' & $Y - 5 & @CRLF

	$sTempText &= 'layer set PDF2_Texto' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j middle' & @CRLF
	$sTempText &= $X + 2.625 & ',' & $Y - 1.375 & @CRLF
	$sTempText &= '.3939' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= $sName & @CRLF

	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j middle' & @CRLF
	$sTempText &= $X + 2.625 & ',' & $Y - 2.25 & @CRLF
	$sTempText &= '0.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= '30H x 24W x 12D' & @CRLF



;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X - .1408, $Y - .625 + 0.05635, $X - .1408, $Y - .625 - 0.05635, 'RJX_DESC', 'Black')
	$sTempText &= _AddLine($X - .1408, $Y - .625 + 0.05635, $X, $Y - .625, 'RJX_DESC', 'Black')
	$sTempText &= _AddLine($X - .1408, $Y - .625 - 0.05635, $X, $Y - .625, 'RJX_DESC', 'Black')
	$sTempText &= _AddLine($X - .1408, $Y - .625, $X - .1408 - 2.4, $Y - .625, 'RJX_DESC', 'Black')
	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X - .1408 - 1.2 & ',' & $Y - .625 & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= '110VAC/1PH/20A' & @CRLF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X - .1408, $Y - 1.25 + 0.05635, $X - .1408, $Y - 1.25 - 0.05635, 'RJX_DESC', 'Magenta')
	$sTempText &= _AddLine($X - .1408, $Y - 1.25 + 0.05635, $X, $Y - 1.25, 'RJX_DESC', 'Magenta')
	$sTempText &= _AddLine($X - .1408, $Y - 1.25 - 0.05635, $X, $Y - 1.25, 'RJX_DESC', 'Magenta')
	$sTempText &= _AddLine($X - .1408, $Y - 1.25, $X - .1408 - 2.4, $Y - 1.25, 'RJX_DESC', 'Magenta')
	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X - .1408 - 1.2 & ',' & $Y - 1.25 & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= 'SCADA NETWORK' & @CRLF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X + 5.25, $Y - .625, $X + 5.25 + 8.375, $Y - .625, 'RJX_DESC', 'Green')
	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X + 5.25 + 4.6875 & ',' & $Y - .625 & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= 'YELLOW AS-i CABLE' & @CRLF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$sTempText &= _AddLine($X + 5.25, $Y - 1.25, $X + 5.25 + 8.375, $Y - 1.25, 'RJX_DESC', 'Cyan')
	$sTempText &= 'layer set RA_WIRENO' & @CRLF & @CRLF
	$sTempText &= '_text' & @CRLF
	$sTempText &= 'j bc' & @CRLF
	$sTempText &= $X + 5.25 + 4.6875 & ',' & $Y - 1.25 & @CRLF
	$sTempText &= '.18' & @CRLF
	$sTempText &= '0' & @CRLF
	$sTempText &= 'BLACK AS-i CABLE' & @CRLF




	Return $sTempText

EndFunc   ;==>_AddMaster

Func _AddLine($X1, $Y1, $X2, $Y2, $sLayer, $sColor)
	ConsoleWrite("_AddLine(" & $X1 & ", " & $Y1 & ", " & $X2 & ", " & $Y2 & ", " & $sLayer & ", " & $sColor & ")" & @CRLF)

	Switch $sColor
		Case 'Red'
			$sColorCode = '255,0,0'
		Case 'Green'
			$sColorCode = '0,255,0'
		Case 'Blue'
			$sColorCode = '0,0,255'
		Case 'Cyan'
			$sColorCode = '0,255,255'
		Case 'Orange'
			$sColorCode = '255,127,0'
		Case 'Magenta'
			$sColorCode = '255,0,255'
		Case 'Black'
			$sColorCode = '0,0,0'
		Case Else
			MsgBox(0, '', 'Not a known color')
			Exit
	EndSwitch

	$sTempText = ''
	$sTempText &= 'layer set ' & $sLayer & @CRLF & @CRLF
	$sTempText &= '-color Truecolor' & @CRLF
	$sTempText &= $sColorCode & @CRLF
	$sTempText &= 'line' & @CRLF
	$sTempText &= $X1 & ',' & $Y1 & ',0 ' & $X2 & ',' & $Y2 & ',0' & @CRLF & @CRLF
	$sTempText &= '-color bylayer' & @CRLF
	Return $sTempText



EndFunc   ;==>_AddLine

Func _AddSheet($X, $Y)
	ConsoleWrite("_AddSheet(" & $X & ", " & $Y & ")" & @CRLF)
	$sTempText = ''
	$sTempText &= 'PASTECLIP' & @CRLF
	$sTempText &= $X & ',' & $Y & ',0' & @CRLF
	$sTempText &= 'ERASE WINDOW' & @CRLF
	$sTempText &= $X + .3803 & ',' & $Y - .0208 & ',0 ' & $X + .3803 + 2.1346 & ',' & $Y - .0208 - .5489 & ',0 ' & @CRLF
	$sTempText &= 'qsave' & @CRLF
	Return $sTempText
EndFunc   ;==>_AddSheet

Func _RunScript($sTempPath)
	ConsoleWrite("_RunScript(" & $sTempPath & ")" & @CRLF)

	WinActivate('AutoCAD 2024')
	Sleep(100)
	WinActivate('AutoCAD 2024')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', 'script')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', '{enter}')

	WinWait('Select Script File')
	ControlSend('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', @DesktopCommonDir)
	Sleep(500)
	ControlSetText('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', @DesktopCommonDir)
	Sleep(100)
	ControlClick('Select Script File', '', '[CLASS:Button; INSTANCE:7]')
	ControlSetText('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', $sTempPath)
	Sleep(500)
	ControlClick('Select Script File', '', '[CLASS:Button; INSTANCE:7]')

EndFunc   ;==>_RunScript

Func _CheckFileDate()
	$sFileTime = FileGetTime($sNewFilePath, $FT_MODIFIED, $FT_STRING)
	$dtFileTime = _StringInsert(_StringInsert(_StringInsert(_StringInsert(_StringInsert($sFileTime, ' ', -6), ':', -4), ':', -2), '/', 6), '/', 4)
;~ ConsoleWrite("-> File Time: " & $dtFileTime & @CRLF)
	$iTimeDiff = _DateDiff('s', $dtFileTime, _NowCalc())
;~ ConsoleWrite("-> File Age: " & $iTimeDiff & " Seconds" & @CRLF)

	While $iTimeDiff > 2
		$sFileTime = FileGetTime($sNewFilePath, $FT_MODIFIED, $FT_STRING)
		$dtFileTime = _StringInsert(_StringInsert(_StringInsert(_StringInsert(_StringInsert($sFileTime, ' ', -6), ':', -4), ':', -2), '/', 6), '/', 4)
		$iTimeDiff = _DateDiff('s', $dtFileTime, _NowCalc())
		Sleep(100)
	WEnd
	Sleep(2000)
EndFunc   ;==>_CheckFileDate

Func _FindReplace($sFind, $sReplace)
	ConsoleWrite("_FindReplace(" & $sFind & ", " & $sReplace & ")" & @CRLF)
	Sleep(100)

	WinActivate('AutoCAD 2024')
	Sleep(100)
	WinActivate('AutoCAD 2024')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', 'find')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', '{enter}')

	WinWait('Find and Replace', 'Find &what:')
	ControlSend('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', 'Temp')
	ControlSend('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:2]', 'Temp')
	ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', $sFind)
	ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:2]', $sReplace)
	ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:5]')
	WinWait('Find and Replace', 'The system has finished searching the drawing.')
	ControlClick('Find and Replace', 'The system has finished searching the drawing.', '[CLASS:Button; INSTANCE:1]')
	ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:7]')
EndFunc   ;==>_FindReplace

Func _OpenFile($sPath)
	ConsoleWrite("_OpenFile(" & $sPath & ")" & @CRLF)
	Sleep(100)

	WinActivate('AutoCAD 2024')
	Sleep(100)
	WinActivate('AutoCAD 2024')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', 'open')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', '{enter}')

	WinWait('Select File')
	ControlSend('Select File', '', '[CLASS:Edit; INSTANCE:1]', @DesktopCommonDir)
	Sleep(500)
	ControlSetText('Select File', '', '[CLASS:Edit; INSTANCE:1]', @DesktopCommonDir)
	Sleep(100)
	ControlClick('Select File', '', '[CLASS:Button; INSTANCE:7]')
	ControlSetText('Select File', '', '[CLASS:Edit; INSTANCE:1]', $sPath)
	Sleep(500)
	ControlClick('Select File', '', '[CLASS:Button; INSTANCE:7]')
	Sleep(5000)

EndFunc   ;==>_OpenFile

Func _Exit()
	Exit
EndFunc   ;==>_Exit
