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
Global $iSheetX = 29.9038
Global $iSheetY = 21.25
Global $iSheetXInc = 31.9038
Global $iSheetYInc = -22.25
Global $iSheetDeviceXOffset = 6.125
Global $iSheetDeviceXRange = 17.985

Global $aTrunkYStart[2] = [-66.75, -155.75]
Global $aSheetRowOffset[2] = [-1, -11]

Global $sFirstPageTemplatePath = @ScriptDir & "\Templates\First_Page.scr"
Global $sPLCPanelTemplatePath = @ScriptDir & "\Templates\PLC_Panel.scr"
Global $sUseFilesRoot = @ScriptDir & '\Sandbox\UseFiles\'

Global $sNewFilePath = @ScriptDir & "\Sandbox\New_File.dwg"
Global $sFirstScriptPath = @ScriptDir & "\Templates\First_Page.scr"
Global $sRemotePanelPath = @ScriptDir & "\Templates\Remote_Panel.scr"
Global $sTempPath = @ScriptDir & "\Templates\Temporary\Temp.scr"

$sWorkbookPath = @ScriptDir & "\Motor And Instrument List Rev 1.xlsx"



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

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FileCopy(@ScriptDir & "\Sandbox\Backup\New_File.dwg", @ScriptDir & "\Sandbox\New_File.dwg", 9)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~ _ArrayDisplay($aNodes)
_ArraySort($aNodes, 0, 1, 0, 0)
;~ _ArrayDisplay($aNodes)
;~ _ArrayDisplay($aIO)
;~ _ArrayDisplay($aMasters)
;~ _ArrayDisplay($aModules)


;~ _ArrayDisplay($aSheet)
;~ Exit

$iPanelCount = 0
$iMasterInc = 0
Local $aMasterPos[1][2]
For $iRow = 1 To UBound($aMasters) - 1
	$sPanel = $aMasters[$iRow][0]
	$iPanelCount += 1
	For $iCol = 1 To UBound($aMasters, 2) - 1
		$sMaster = $aMasters[$iRow][$iCol]

		If $sMaster = '' Then ContinueLoop
		$iMasterInc += 1

		$xSheetOffset = $iSheetXInc * $iMasterInc

		_ArrayAdd($aMasterPos, $aMasters[$iRow][$iCol] & '|' & $xSheetOffset)

	Next
Next

Local $aNodeDetails[1][12] = [['X', 'Y', 'Device Type', 'INST_NAME', 'DESCRIPTION', 'JB_NAME', 'NODE_NUM', 'INPUT_NUM', 'OUTPUT_NUM', 'ASM_NAME', 'TRUNK_NUM', 'Added']]

Local $aTrunks[UBound($aMasterPos) - 1][2][4][2] ;[Master][Trunk][Sheet][SheetRow]
For $iNodeRow = 1 To UBound($aNodes) - 1
	$sDevice = $aNodes[$iNodeRow][0]
	$sMaster = $aNodes[$iNodeRow][1]
	$iTrunk = $aNodes[$iNodeRow][2]
	$sNode = $aNodes[$iNodeRow][3]
	If $sDevice = '' Then ContinueLoop
	ConsoleWrite('->Device = ' & $sDevice & @CRLF)

	$sDescription = ''

	$iMasterInc = _ArraySearch($aMasterPos, $sMaster, 0, 0, 0, 0, 1, 0)
	If $iMasterInc < 0 Then
		MsgBox(0, $sMaster, 'Master?')
	Else
		$xSheetOffset = $aMasterPos[$iMasterInc][1]
	EndIf


	$iSheetRowFactor = 0
	$iSpaceToLeft = 0
	$iSpaceToRight = 0
	If StringInStr($sDevice, '-JB') Then
		$sJB = StringLeft($sDevice, StringInStr($sDevice, '-AM') - 1)
		$iModNum = Number(StringRight($sDevice, 2))
		$iModuleIndex = _ArraySearch($aModules, $sJB, 0, 0, 0, 0, 1, 0)
		If $iModuleIndex < 0 Then
			MsgBox(0, $sDevice, 'Device not found.')
			Exit
		Else
			$sModuleType = $aModules[$iModuleIndex][$iModNum]
		EndIf
		If $sModuleType = 'IO-Link' Then ContinueLoop
		ConsoleWrite('++>Type = ' & $sModuleType & @CRLF)
		$iBusYOffset = +.4971
		$iSheetRowFactor = .75
		Switch $sModuleType
			Case 'VBA-4E4A-KE5-ZEJQ_R'
				$iSpaceToLeft = 4.9
				$iSpaceToRight = 5.9
			Case 'VBA-4E-KE5-IL'
				$iSpaceToLeft = 4.9
				$iSpaceToRight = 1.5
			Case 'VBA-4E4A-KE5-ZEJQ_E2L'
				$iSpaceToLeft = 4.9
				$iSpaceToRight = 5.9
			Case 'VBA-4A-KE5-IJL_UJL'
				$iSpaceToLeft = 0
				$iSpaceToRight = 5.9
			Case 'AC2220'
				$iSpaceToLeft = 4.9
				$iSpaceToRight = 1.5
			Case Else
				MsgBox(0, '', 'Module Type?' & @CRLF & $sModuleType)
		EndSwitch

	Else
		$sModuleType = 'ASI_Valve'
		ConsoleWrite('++>Type = ' & $sModuleType & @CRLF)
		$sInstIndex = _ArraySearch($aInstruments, $sDevice, 0, 0, 0, 0, 1, 2)
		If $sInstIndex < 0 Then
			MsgBox(0, $sDevice, 'Device?')
			Exit
		Else
			$sDescription = $aInstruments[$sInstIndex][6]
		EndIf

		$iBusYOffset = 0
		$iSheetRowFactor = .125
		$iSpaceToLeft = 1
		$iSpaceToRight = 2
	EndIf



	$bAssigned = False
	For $iSheet = 0 To UBound($aTrunks, 3) - 1
		For $iSheetRow = 0 To UBound($aTrunks, 4) - 1
			If $aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] = '' Then
				$aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] = 0
				$bAssigned = True
				ExitLoop
			ElseIf ($aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] + $iSpaceToLeft) <= $iSheetDeviceXRange Then
				$bAssigned = True
				ExitLoop
			EndIf

		Next
		If $bAssigned Then ExitLoop
	Next

	ConsoleWrite('->' & $iMasterInc - 1 & '->' & $iTrunk & '->' & $iSheet & '->' & $iSheetRow & @CRLF)
;~ 	_ArrayDisplay($aTrunks)
	If Not $bAssigned Then
		$sCSVText = _ArrayToString($aNodeDetails, ',', Default, Default, @CRLF)
		FileDelete(@ScriptDir & '/NodeDetails.csv')
		FileWrite(@ScriptDir & '/NodeDetails.csv', $sCSVText)
		MsgBox(0, '', 'Not assigned to sheet!' & @CRLF & @ScriptDir & '/NodeDetails.csv')
		Exit
	EndIf

	ConsoleWrite('++>X Start = ' & $aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] & @CRLF)
	If $aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] = 0 Then
		$xSheetOffset += $iSheetDeviceXOffset
	Else
		$xSheetOffset += $iSheetDeviceXOffset + ($aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] + $iSpaceToLeft)
		ConsoleWrite('++>Space to left = ' & $iSpaceToLeft & @CRLF)
	EndIf
	$ySheetOffset = $aTrunkYStart[$iTrunk] + ($iSheetYInc * $iSheet) + $aSheetRowOffset[$iSheetRow] + $iBusYOffset
	ConsoleWrite('++>xOffset = ' & $xSheetOffset & @CRLF)
	ConsoleWrite('++>yOffset = ' & $ySheetOffset & @CRLF)
	_ArrayAdd($aNodeDetails, $xSheetOffset & '|' & $ySheetOffset & '|' & $sModuleType & '|' & $sDevice & '|' & $sDescription & '|' & $sJB & '|' & $sNode & '|' & '' & '|' & '' & '|' & $sMaster & '|' & $iTrunk & '|0')
	If $aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] = 0 Then
		$aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] += $iSpaceToRight
	Else
		$aTrunks[$iMasterInc - 1][$iTrunk][$iSheet][$iSheetRow] += $iSpaceToLeft + $iSpaceToRight
	EndIf
Next

$sCSVText = _ArrayToString($aNodeDetails, ',', Default, Default, @CRLF)
FileDelete(@ScriptDir & '/NodeDetails.csv')
FileWrite(@ScriptDir & '/NodeDetails.csv', $sCSVText)

FileCopy(@ScriptDir & "\Sandbox\Backup\New_File.dwg", $sNewFilePath, 9)
MsgBox(0, '', 'New_File.dwg should be closed.')
MouseMove(0, 0, 0)
$sLastDevType = ''
For $iRow = 1 To UBound($aNodeDetails) - 1
	$X = $aNodeDetails[$iRow][0]
	$Y = $aNodeDetails[$iRow][1]
	$Device_Type = $aNodeDetails[$iRow][2]
	$INST_NAME = $aNodeDetails[$iRow][3]
	$DESCRIPTION = $aNodeDetails[$iRow][4]
	$JB_NAME = $aNodeDetails[$iRow][5]
	$NODE_NUM = $aNodeDetails[$iRow][6]
	$INPUT_NUM = $aNodeDetails[$iRow][7]
	$OUTPUT_NUM = $aNodeDetails[$iRow][8]
	$ASM_NAME = $aNodeDetails[$iRow][9]
	$TRUNK_NUM = $aNodeDetails[$iRow][10]
	$Added = Number($aNodeDetails[$iRow][11])

;~ 	If $Device_Type <> 'ASI_Valve' Then ContinueLoop

	$sUseFile = $sUseFilesRoot & $Device_Type & '.dwg'

	$sNewText = ''
	$sNewText &= 'OPEN "' & $sUseFile & '"' & @CRLF
	$sNewText &= 'COPYBASE' & @CRLF
	$sNewText &= '0,0,0' & @CRLF
	$sNewText &= 'all' & @CRLF
	$sNewText &= '' & @CRLF
	$sNewText &= 'close y' & @CRLF
	$sNewText &= 'OPEN "' & $sNewFilePath & '"' & @CRLF
	$sNewText &= 'ZOOM window ' & $X + 2.2 & ',' & $Y - 9.7 & ' ' & $X - .2 & ',' & $Y + .2 & @CRLF

	If Not $Added Then
		$sNewText &= 'PASTECLIP' & @CRLF
		$sNewText &= $X & ',' & $Y & @CRLF
		If $Device_Type <> 'ASI_Valve' Then
			$sNewText &= 'attedit y ' & $Device_Type & ' NODE  window ' & $X + 2.2 & ',' & $Y - 9.7 & ' ' & $X - .2 & ',' & $Y + .2 & ' value Replace ' & $NODE_NUM & @CRLF & @CRLF
		EndIf
		$aNodeDetails[$iRow][11] = 1
;~ 		For $iSearchRow = ($iRow + 1) To UBound($aNodeDetails) - 1
;~ 			$SearchX = $aNodeDetails[$iSearchRow][0]
;~ 			$SearchY = $aNodeDetails[$iSearchRow][1]
;~ 			$SearchDevice_Type = $aNodeDetails[$iSearchRow][2]
;~ 			$SearchINST_NAME = $aNodeDetails[$iSearchRow][3]
;~ 			$SearchDESCRIPTION = $aNodeDetails[$iSearchRow][4]
;~ 			$SearchJB_NAME = $aNodeDetails[$iSearchRow][5]
;~ 			$SearchNODE_NUM = $aNodeDetails[$iSearchRow][6]
;~ 			$SearchINPUT_NUM = $aNodeDetails[$iSearchRow][7]
;~ 			$SearchOUTPUT_NUM = $aNodeDetails[$iSearchRow][8]
;~ 			$SearchASM_NAME = $aNodeDetails[$iSearchRow][9]
;~ 			$SearchTRUNK_NUM = $aNodeDetails[$iSearchRow][10]
;~ 			$SearchAdded = $aNodeDetails[$iSearchRow][11]

;~ 			If $SearchDevice_Type = $Device_Type Then
;~ 				$sNewText &= 'ZOOM window ' & $SearchX + 2.2 & ',' & $SearchY - 9.7 & ' ' & $SearchX - .2 & ',' & $SearchY + .2 & @CRLF
;~ 				$sNewText &= 'PASTECLIP' & @CRLF
;~ 				$sNewText &= $SearchX & ',' & $SearchY & @CRLF
;~ 				If $SearchDevice_Type <> 'ASI_Valve' Then
;~ 					$sNewText &= 'attedit y ' & $SearchDevice_Type & ' NODE  window ' & $SearchX + 2.2 & ',' & $SearchY - 9.7 & ' ' & $SearchX - .2 & ',' & $SearchY + .2 & ' value Replace ' & $SearchNODE_NUM & @CRLF & @CRLF
;~ 				EndIf
;~ 				$aNodeDetails[$iSearchRow][11] = 1
;~ 			EndIf

;~ 		Next
	EndIf
	$sNewText &= 'ZOOM window ' & $X + 2.2 & ',' & $Y - 9.7 & ' ' & $X - .38 & ',' & $Y + .2 & @CRLF

	$sNewText &= 'qsave' & @CRLF
	$sNewTempPath = StringReplace($sTempPath, "Temp.scr", "Temp" & @SEC & @MSEC & ".scr")
	_FileCreate($sNewTempPath)
	FileWrite($sNewTempPath, $sNewText)
	_RunScript($sNewTempPath)
	_CheckFileDate()
	Local $aFinds[8] = ['[INST_NAME]', '[DESCRIPTION]', '[JB_NAME]', '[NODE_NUM]', '[INPUT_NUM]', '[OUTPUT_NUM]', '[ASM_NAME]', '[TRUNK_NUM]']
	Local $aReplaces[8] = [$INST_NAME, $DESCRIPTION, $JB_NAME, $NODE_NUM, $INPUT_NUM, $OUTPUT_NUM, $ASM_NAME, $TRUNK_NUM + 1]

;~ 	_SelectWindow($X + 1.98, $Y - 9.7, $X - .2, $Y + .2)
	_FindReplace($aFinds, $aReplaces, 'Current space/layout')

	$sNewText = 'qsave' & @CRLF
	$sNewText &= 'close' & @CRLF

	$sNewTempPath = StringReplace($sTempPath, "Temp.scr", "Temp" & @SEC & @MSEC & ".scr")
	_FileCreate($sNewTempPath)
	FileWrite($sNewTempPath, $sNewText)
	_RunScript($sNewTempPath)
	_CheckFileDate()

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ADD IO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	$iModuleX = $X
	$iModuleY = $Y
	If StringInStr($INST_NAME, '-JB') Then
		$sINIPath = $sUseFilesRoot & $Device_Type & '.ini'

		For $iIORow = 1 To UBound($aIO) - 1
			If $aIO[$iIORow][0] = $INST_NAME Then
				ExitLoop
			EndIf
			If $iIORow = UBound($aIO) - 1 Then
				MsgBox(0, '', 'JB Module Not Found')
				Exit
			EndIf
		Next
		For $iCol = 1 To 16
			$bInput = 0
			$INST_NAME = $aIO[$iIORow][$iCol]
			Select
				Case $iCol < 5
					$INPUT_NUM = $iCol
					$OUTPUT_NUM = ''
					$bInput = 1
				Case $iCol >= 5 And $iCol < 9
					$X = $iModuleX
					$Y = $iModuleY

					$INPUT_NUM = ''
					$OUTPUT_NUM = $iCol - 4
					$bInput = 0
				Case $iCol >= 9 And $iCol < 13
					$INPUT_NUM = $iCol - 8
					$OUTPUT_NUM = ''
					$bInput = 1
				Case $iCol >= 13
					$X = $iModuleX
					$Y = $iModuleY

					$INPUT_NUM = ''
					$OUTPUT_NUM = $iCol - 12
					$bInput = 0
			EndSelect
			If $aIO[$iIORow][$iCol] = '' Then ContinueLoop

			For $iInstRow = 1 To UBound($aInstruments) - 1
				If $aInstruments[$iInstRow][2] = $INST_NAME Then
					$DESCRIPTION = $aInstruments[$iInstRow][6]
					ExitLoop
				EndIf
			Next


			$aTemp = StringSplit($INST_NAME, '-')
			$sInstLetters = $aTemp[1]
			Select
				Case StringRight($sInstLetters, 1) = 'V' And $iCol < 9
					If $Device_Type = 'VBA-4E4A-KE5-ZEJQ_R' Then
						$sInstType = 'SV(for_Relay)'
					Else
						$sInstType = 'SV'
					EndIf
				Case StringRight($sInstLetters, 1) = 'V' And $iCol >= 9
					If $bInput Then
						$sInstType = 'Transmitter'
					Else
						$sInstType = 'Control_Valve'
					EndIf
				Case StringLeft($sInstLetters, 2) = 'HS'
					$sInstType = 'Hand_Switch'
				Case StringMid($sInstLetters, 2, 1) = 'S' And StringLeft($sInstLetters, 1) <> 'H'
					$sInstType = 'Limit_Switch'
				Case StringRight($sInstLetters, 1) = 'T'
					$sInstType = 'Transmitter'
				Case Else
					MsgBox(0, '', 'Instrument Type?' & @CRLF & $sInstLetters)
			EndSelect

			$sUseFile = $sUseFilesRoot & $sInstType & '.dwg'

			If $bInput Then
				$X += Number(IniRead($sINIPath, 'In' & $INPUT_NUM, 'X', 0))
				$Y += Number(IniRead($sINIPath, 'In' & $INPUT_NUM, 'Y', 0))
			Else
				$X += Number(IniRead($sINIPath, 'Out' & $OUTPUT_NUM, 'X', 0))
				$Y += Number(IniRead($sINIPath, 'Out' & $OUTPUT_NUM, 'Y', 0))
			EndIf

			$sNewText = ''
			$sNewText &= 'OPEN "' & $sUseFile & '"' & @CRLF
			$sNewText &= 'COPYBASE' & @CRLF
			$sNewText &= '0,0,0' & @CRLF
			$sNewText &= 'all' & @CRLF
			$sNewText &= '' & @CRLF
			$sNewText &= 'close y' & @CRLF
			$sNewText &= 'OPEN "' & $sNewFilePath & '"' & @CRLF
;~ 			$sNewText &= 'ZOOM window ' & $X + 2.2 & ',' & $Y - 9.7 & ' ' & $X - .2 & ',' & $Y + .2 & @CRLF
			$sNewText &= 'PASTECLIP' & @CRLF
			$sNewText &= $X & ',' & $Y & @CRLF

			$sNewText &= 'qsave' & @CRLF
			$sNewTempPath = StringReplace($sTempPath, "Temp.scr", "Temp" & @SEC & @MSEC & ".scr")
			_FileCreate($sNewTempPath)
			FileWrite($sNewTempPath, $sNewText)
			_RunScript($sNewTempPath)
			_CheckFileDate()
			Local $aFinds[8] = ['[INST_NAME]', '[DESCRIPTION]', '[JB_NAME]', '[NODE_NUM]', '[INPUT_NUM]', '[OUTPUT_NUM]', '[ASM_NAME]', '[TRUNK_NUM]']
			Local $aReplaces[8] = [$INST_NAME, $DESCRIPTION, $JB_NAME, $NODE_NUM, $INPUT_NUM, $OUTPUT_NUM, $ASM_NAME, $TRUNK_NUM + 1]

			_FindReplace($aFinds, $aReplaces, 'Current space/layout')

			$sNewText = 'qsave' & @CRLF
			$sNewText &= 'close' & @CRLF

			$sNewTempPath = StringReplace($sTempPath, "Temp.scr", "Temp" & @SEC & @MSEC & ".scr")
			_FileCreate($sNewTempPath)
			FileWrite($sNewTempPath, $sNewText)
			_RunScript($sNewTempPath)
			_CheckFileDate()
		Next
	EndIf

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




	$sLastDevType = $Device_Type

Next

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
	ControlSetText('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', '')
	Sleep(500)
	ControlClick('Select Script File', '', '[CLASS:Button; INSTANCE:7]')
	ControlSetText('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', $sTempPath)
	Sleep(500)
	ControlClick('Select Script File', '', '[CLASS:Button; INSTANCE:7]')

EndFunc   ;==>_RunScript

Func _SelectWindow($X1, $Y1, $X2, $Y2)
	ConsoleWrite("_SelectWindow(" & $X1 & ',' & $Y1 & ',' & $X2 & ',' & $Y2 & ")" & @CRLF)

	Sleep(1500)
	WinActivate('AutoCAD 2024')
	Sleep(100)
	WinActivate('AutoCAD 2024')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', 'select ')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', 'window ')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', $X1 & ',' & $Y1 & ' ' & $X2 & ',' & $Y2)
	Sleep(1000)
	ControlSend('AutoCAD 2024', '', '', '{enter}')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', '{enter}')
	Sleep(250)

EndFunc   ;==>_SelectWindow

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

Func _FindReplace($sFind, $sReplace, $sWhere = 'All')
	ConsoleWrite("_FindReplace(" & $sFind & ", " & $sReplace & ")" & @CRLF)
	Sleep(1000)


	WinActivate('AutoCAD 2024')
	Sleep(100)
	WinActivate('AutoCAD 2024')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', 'find')
	Sleep(100)
	ControlSend('AutoCAD 2024', '', '', '{enter}')

	WinWait('Find and Replace', 'Find &what:')

	If IsArray($sFind) And IsArray($sReplace) Then
		For $iRow = 0 To UBound($sFind) - 1
			ControlSend('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', 'Temp')
			ControlSend('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:2]', 'Temp')
			ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', $sFind[$iRow])
			ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:2]', $sReplace[$iRow])
			If $sWhere = 'Current space/layout' Then
				ControlSend('Find and Replace', 'Find &what:', '[CLASS:ComboBox; INSTANCE:3]', 'C')
			ElseIf $sWhere = 'All' Then
				ControlSend('Find and Replace', 'Find &what:', '[CLASS:ComboBox; INSTANCE:3]', 'E')
			Else
				MsgBox(0, '', 'Where to find and replace?')
				Exit
			EndIf
			ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:5]')
			WinWait('Find and Replace', 'The system has finished searching the drawing.')
			ControlClick('Find and Replace', 'The system has finished searching the drawing.', '[CLASS:Button; INSTANCE:1]')
			Sleep(500)
		Next
	Else
		ControlSend('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', 'Temp')
		ControlSend('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:2]', 'Temp')
		ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', $sFind)
		ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:2]', $sReplace)
		If $sWhere = 'Current space/layout' Then
			ControlSend('Find and Replace', 'Find &what:', '[CLASS:ComboBox; INSTANCE:3]', 'C')
		ElseIf $sWhere = 'All' Then
			ControlSend('Find and Replace', 'Find &what:', '[CLASS:ComboBox; INSTANCE:3]', 'E')
		Else
			MsgBox(0, '', 'Where to find and replace?')
			Exit
		EndIf
		ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:5]')
		WinWait('Find and Replace', 'The system has finished searching the drawing.')
		ControlClick('Find and Replace', 'The system has finished searching the drawing.', '[CLASS:Button; INSTANCE:1]')
	EndIf
	ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:7]')
	Sleep(1000)
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
