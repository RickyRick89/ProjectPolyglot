#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>

;[INST_NAME],[DESCRIPTION],[JB_NAME],[NODE_NUM],[INPUT_NUM],[OUTPUT_NUM],[ASM_NAME],[TRUNK_NUM]

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Global $sLastSelected = 'L4_PRC_ASI01_JB01'
Global $aOptions[1] = [$sLastSelected]

$sFirstPageTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\First_Page.scr"
$sPLCPanelTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\PLC_Panel.scr"

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Motor And Instrument List Rev 1.xlsx"

$sSheetName = 'Instrument List'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

MsgBox(0, '', 'Sort by Signal Type, then Wired To.')
Global $aPanels = _Excel_RangeRead($oWorkbook, 'Panels')
Global $aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)

Local $bCntrlVlvFdbk = True
Local $iMaxNumOfModules = 8

Global $aTypes[2][6] = [['AI', 'AO', 'RLY', 'DI', 'DO', 'DI/DO'], ['AC2216', 'AC2218', 'AC2259', 'AC2267/AC2259', 'AC2267', 'NODE']]
Global $aIO[1][(UBound($aPanels) - 1) * $iMaxNumOfModules]
Global $aNodes[32][6][2][2] ; Node, Master, Trunk, Extension
$aNodes[0][0][0][0] = "L4_PRC_ASI01_ASM01"
$aNodes[0][1][0][0] = "L4_PRC_ASI02_ASM01"
$aNodes[0][2][0][0] = "L4_PRC_ASI02_ASM02"
$aNodes[0][3][0][0] = "L4_PRC_ASI02_ASM03"
$aNodes[0][4][0][0] = "L4_PRC_ASI03_ASM01"
$aNodes[0][5][0][0] = "L4_PRC_ASI04_ASM01"

$iInc = 0
For $x = 1 To UBound($aPanels) - 1
	$sJB = $aPanels[$x][7]
	For $iMod = 1 To $iMaxNumOfModules
		$sMod = StringFormat("%02i", $iMod)
		$aIO[0][$iInc] = $sJB & '_AM' & $sMod
		$iInc += 1
	Next
Next


ReDim $aIO[11][UBound($aIO, 2)]

;~ _ArrayDisplay($aIO)
;~ MsgBox(0, '', _ArrayToString($aIO))


;~ _ArrayDisplay($aPanels)
;~ _ArrayDisplay($aSheet)
;~ Exit

For $iTypeIndex = 0 To UBound($aTypes, 2) - 1
	ConsoleWrite(">Processing Signal Type: " & $aTypes[0][$iTypeIndex] & @CRLF)

	For $iRow = 1 To UBound($aSheet) - 1
		ConsoleWrite("Processing Row: " & $iRow & @CRLF)

		$sDevice = $aSheet[$iRow][2]
		$sConn = $aSheet[$iRow][7]
		$sSigType = $aSheet[$iRow][8]
		$sWiredTo = $aSheet[$iRow][9]
		$sControlType = $aSheet[$iRow][23]
		$sASiMaster = $aSheet[$iRow][26]
		$bAddModule = False

		If $sWiredTo = 'OEM' Or $sWiredTo = '?' Then ContinueLoop
		If $sSigType <> $aTypes[0][$iTypeIndex] Then ContinueLoop
		$iFirstAvailCol = -1
		If $aTypes[0][$iTypeIndex] = 'DI/DO' Then
			ConsoleWrite('--> Device is a valve' & @CRLF)

			$bAssigned = False
			For $iMaster = 0 To UBound($aNodes, 2) - 1
				If $bAssigned Then ExitLoop
				If $aNodes[0][$iMaster][0][0] <> $sASiMaster Then ContinueLoop
				For $iTrunk = 0 To UBound($aNodes, 3) - 1
					If $bAssigned Then ExitLoop
					For $iNode = 1 To UBound($aNodes, 1) - 1
						If $bAssigned Then ExitLoop
						For $iExtension = 0 To UBound($aNodes, 4) - 1
							If $bAssigned Then ExitLoop
							If $aNodes[$iNode][$iMaster][$iTrunk][$iExtension] = '' Then
								ConsoleWrite("Master: " & $aNodes[0][$iMaster][0][0] & " $iTrunk: " & $iTrunk & " $iNode: " & $iNode & ' $iExtension: ' & $iExtension & ' $sDevice: ' & $sDevice & @CRLF)
								$aNodes[$iNode][$iMaster][$iTrunk][$iExtension] = $sDevice
								$bAssigned = True
							EndIf
						Next
					Next
				Next
			Next
			If Not $bAssigned Then
				MsgBox(0, '', $sDevice & ' not assigned a node')
			EndIf
			ContinueLoop
		Else
			ConsoleWrite('++> Device is not a valve' & @CRLF)
			ConsoleWrite('-> Device ' & $sDevice & ' is wired to ' & $sWiredTo & @CRLF)
			$bAssigned = False

			For $iCol = 0 To UBound($aIO, 2) - 1
				If $aIO[9][$iCol] = '' And StringInStr($aIO[0][$iCol], $sWiredTo) And $iFirstAvailCol < 0 Then $iFirstAvailCol = $iCol
			Next
			If $iFirstAvailCol < 0 Then
				ConsoleWrite('%%%% DEBUG %%%% ' & $sWiredTo)
				_ArrayDisplay($aIO)
			EndIf

			For $iCol = 0 To UBound($aIO, 2) - 1
;~ 				ConsoleWrite("~>Processing Col: " & $iCol & @CRLF)
				If Not StringInStr($aIO[0][$iCol], $sWiredTo) Or $aIO[10][$iCol] <> '' Then ContinueLoop
				ConsoleWrite('> Possible Module: ' & $aIO[0][$iCol] & @CRLF)
				If StringInStr($aTypes[1][$iTypeIndex], $aIO[9][$iCol]) Then
					ConsoleWrite('>> Try Module ' & $aIO[0][$iCol] & @CRLF)
					If StringRight($sSigType, 1) = 'I' Then
						For $iInput = 1 To 4
							ConsoleWrite('>>> Try Input ' & $iInput & @CRLF)
							If $aIO[$iInput][$iCol] = '' Then
								ConsoleWrite('>> Assigned to ' & $aIO[0][$iCol] & @CRLF)
								$aIO[$iInput][$iCol] = $sDevice
								$bAssigned = True
							EndIf
							If $iInput = 4 And Not $bAssigned Then
								If $aTypes[1][$iTypeIndex] = 'AC2267/AC2259' Then
									_AddIOMod($iFirstAvailCol, 'AC2267', $sWiredTo, $sSigType, $sASiMaster)
								Else
									_AddIOMod($iFirstAvailCol, $aTypes[1][$iTypeIndex], $sWiredTo, $sSigType, $sASiMaster)
								EndIf
								ConsoleWrite('>> Assigned to ' & $aIO[0][$iFirstAvailCol] & @CRLF)
								$aIO[1][$iFirstAvailCol] = $sDevice
								$bAssigned = True
								$aIO[10][$iCol] = 'FULL'
							EndIf
							If $bAssigned Then ExitLoop
						Next
					ElseIf StringRight($sSigType, 1) = 'O' Or StringRight($sSigType, 1) = 'Y' Then
						For $iOutput = 5 To 8
							ConsoleWrite('>>> Try Output ' & $iOutput & @CRLF)
							If $aIO[$iOutput][$iCol] = '' Then
								ConsoleWrite('>> Assigned to ' & $aIO[0][$iCol] & @CRLF)
								$aIO[$iOutput][$iCol] = $sDevice
								$bAssigned = True
							EndIf
							If $iOutput = 8 And Not $bAssigned Then
								_AddIOMod($iFirstAvailCol, $aTypes[1][$iTypeIndex], $sWiredTo, $sSigType, $sASiMaster)
								ConsoleWrite('>> Assigned to ' & $aIO[0][$iFirstAvailCol] & @CRLF)
								$aIO[5][$iFirstAvailCol] = $sDevice
								$bAssigned = True
								$aIO[10][$iCol] = 'FULL'
							EndIf

;~~~~~~~~~~~~~~~~~~~~~~~ Control Valve Feed Back ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							If $sSigType = 'AO' And $bCntrlVlvFdbk And $bAssigned Then
								$iFirstAvailCol = -1
								$bAssigned2 = False
								ConsoleWrite('=> Control Valve Feedback for ' & $sDevice & @CRLF)
								For $iCol2 = 0 To UBound($aIO, 2) - 1
									If $aIO[9][$iCol2] = '' And StringInStr($aIO[0][$iCol2], $sWiredTo) And $iFirstAvailCol < 0 Then $iFirstAvailCol = $iCol2
								Next
								For $iCol2 = 0 To UBound($aIO, 2) - 1
									$iAITypeIndex = _ArraySearch($aTypes, 'AI', 0, 0, 0, 0, 1, 0, True)
									If $iCol2 = UBound($aIO, 2) - 1 And Not $bAssigned2 Then
										_AddIOMod($iFirstAvailCol, $aTypes[1][$iAITypeIndex], $sWiredTo, 'AI', $sASiMaster)
										$aIO[1][$iFirstAvailCol] = $sDevice
										ExitLoop
									EndIf
									If Not StringInStr($aIO[0][$iCol2], $sWiredTo) Or $aIO[10][$iCol2] <> '' Then ContinueLoop
									If $bAssigned2 Then ExitLoop

									If StringInStr($aTypes[1][$iAITypeIndex], $aIO[9][$iCol2]) Then
										For $iInput = 1 To 4
											ConsoleWrite('>>> Try Input ' & $iInput & @CRLF)
											If $aIO[$iInput][$iCol2] = '' Then
												ConsoleWrite('>> Assigned to ' & $aIO[0][$iCol2] & @CRLF)
												$aIO[$iInput][$iCol2] = $sDevice
												$bAssigned2 = True
											EndIf
											If $iInput = 4 And Not $bAssigned2 Then
												_AddIOMod($iFirstAvailCol, $aTypes[1][$iAITypeIndex], $sWiredTo, 'AI', $sASiMaster)
												ConsoleWrite('>> Assigned to ' & $aIO[0][$iFirstAvailCol] & @CRLF)
												$aIO[1][$iFirstAvailCol] = $sDevice
												$bAssigned2 = True
												$aIO[10][$iCol2] = 'FULL'
											EndIf
											If $bAssigned2 Then ExitLoop
										Next

									EndIf
								Next
							EndIf
							If $bAssigned Then ExitLoop
						Next
					Else
						MsgBox(0, $sSigType, 'I/O Type?')
					EndIf
					ExitLoop
				EndIf
			Next
			If Not $bAssigned And $iFirstAvailCol >= 0 Then
				ConsoleWrite('=> Adding New Module' & @CRLF)
				If $aTypes[1][$iTypeIndex] = 'AC2267/AC2259' And StringRight($sSigType, 1) = 'I' Then
					_AddIOMod($iFirstAvailCol, 'AC2267', $sWiredTo, $sSigType, $sASiMaster)
				Else
					_AddIOMod($iFirstAvailCol, $aTypes[1][$iTypeIndex], $sWiredTo, $sSigType, $sASiMaster)
				EndIf
				ConsoleWrite('>> Assigned to ' & $aIO[0][$iFirstAvailCol] & @CRLF)
				If StringRight($sSigType, 1) = 'I' Then
					$aIO[1][$iFirstAvailCol] = $sDevice
				ElseIf StringRight($sSigType, 1) = 'O' Or StringRight($sSigType, 1) = 'Y' Then
					$aIO[5][$iFirstAvailCol] = $sDevice
				Else
					MsgBox(0, $sSigType, 'I/O Type?')
				EndIf

;~~~~~~~~~~~~~~~~~~~~~~~ Control Valve Feed Back ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				If $sSigType = 'AO' And $bCntrlVlvFdbk Then
					$iFirstAvailCol = -1
					$bAssigned2 = False
					ConsoleWrite('=> Control Valve Feedback for ' & $sDevice & @CRLF)
					For $iCol2 = 0 To UBound($aIO, 2) - 1
						If $aIO[9][$iCol2] = '' And StringInStr($aIO[0][$iCol2], $sWiredTo) And $iFirstAvailCol < 0 Then $iFirstAvailCol = $iCol2
					Next
					For $iCol2 = 0 To UBound($aIO, 2) - 1
						$iAITypeIndex = _ArraySearch($aTypes, 'AI', 0, 0, 0, 0, 1, 0, True)
						If $iCol2 = UBound($aIO, 2) - 1 And Not $bAssigned2 Then
							ConsoleWrite('=> Adding New Module' & @CRLF)
							_AddIOMod($iFirstAvailCol, $aTypes[1][$iAITypeIndex], $sWiredTo, 'AI', $sASiMaster)
							$aIO[1][$iFirstAvailCol] = $sDevice
							ExitLoop
						EndIf
						If Not StringInStr($aIO[0][$iCol2], $sWiredTo) Or $aIO[10][$iCol2] <> '' Then ContinueLoop
						If $bAssigned2 Then ExitLoop

						If StringInStr($aTypes[1][$iAITypeIndex], $aIO[9][$iCol2]) Then
							For $iInput = 1 To 4
								ConsoleWrite('>>> Try Input ' & $iInput & @CRLF)
								If $aIO[$iInput][$iCol2] = '' Then
									ConsoleWrite('>> Assigned to ' & $aIO[0][$iCol2] & @CRLF)
									$aIO[$iInput][$iCol2] = $sDevice
									$bAssigned2 = True
								EndIf
								If $iInput = 4 And Not $bAssigned2 Then
									_AddIOMod($iFirstAvailCol, $aTypes[1][$iAITypeIndex], $sWiredTo, 'AI', $sASiMaster)
									ConsoleWrite('>> Assigned to ' & $aIO[0][$iFirstAvailCol] & @CRLF)
									$aIO[1][$iFirstAvailCol] = $sDevice
									$bAssigned2 = True
									$aIO[10][$iCol2] = 'FULL'
								EndIf
								If $bAssigned2 Then ExitLoop
							Next
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	Next
Next

;~ _ArrayDisplay($aIO)

ConsoleWrite('########## Record ##########' & @CRLF)

Local $aTemp[200][200]
_Excel_RangeWrite($oWorkbook, 'ASi', $aTemp, 'G2')
Local $aTemp[250][4]
_Excel_RangeWrite($oWorkbook, 'ASi', $aTemp, 'A2')
Local $aTemp[27][8]
_Excel_RangeWrite($oWorkbook, 'Panels', $aTemp, 'I2')

$iInc = 2
For $iCol = 0 To UBound($aIO, 2) - 1

	If $aIO[1][$iCol] = '' And $aIO[5][$iCol] = '' Then ContinueLoop
	ConsoleWrite('## Module ' & $aIO[0][$iCol] & @CRLF)

	$sModNum = Number(StringRight($aIO[0][$iCol], 2))
	$sJB = StringLeft($aIO[0][$iCol], StringInStr($aIO[0][$iCol], '_AM') - 1)
	ConsoleWrite('### JB ' & $sJB & ' >> Module Type ' & $aIO[9][$iCol] & @CRLF)

	$iPanelRow = _ArraySearch($aPanels, $sJB, 0, 0, 0, 0, 1, 7)
	ConsoleWrite('### PanelRow ' & $iPanelRow & ' >> Column ' & _Excel_ColumnToLetter($sModNum + 8) & @CRLF)
	_Excel_RangeWrite($oWorkbook, 'Panels', $aIO[9][$iCol], _Excel_ColumnToLetter($sModNum + 8) & $iPanelRow + 1)

	If $aIO[9][$iCol] = 'AC2216' Or $aIO[9][$iCol] = 'AC2218' Then
		$sExcelColumn = 'P'
	Else
		$sExcelColumn = 'H'
	EndIf

	Local $aTemp[8]
	For $x = 0 To 7
		$aTemp[$x] = $aIO[$x + 1][$iCol]
	Next
	_ArrayTranspose($aTemp)

;~ 	_ArrayDisplay($aTemp)

	_Excel_RangeWrite($oWorkbook, 'ASi', $aIO[0][$iCol], 'G' & $iInc)
	_Excel_RangeWrite($oWorkbook, 'ASi', $aTemp, $sExcelColumn & $iInc)
	$iInc += 1
Next


$iInc = 2
For $iMaster = 0 To UBound($aNodes, 2) - 1
	For $iTrunk = 0 To UBound($aNodes, 3) - 1
		For $iNode = 1 To UBound($aNodes, 1) - 1
			For $iExtension = 0 To UBound($aNodes, 4) - 1
				If $aNodes[$iNode][$iMaster][$iTrunk][$iExtension] <> '' Then
					If $aNodes[$iNode][$iMaster][$iTrunk][$iExtension] = '-' Then ContinueLoop
					_Excel_RangeWrite($oWorkbook, 'ASi', $aNodes[$iNode][$iMaster][$iTrunk][$iExtension], 'A' & $iInc)
					_Excel_RangeWrite($oWorkbook, 'ASi', $aNodes[0][$iMaster][0][0], 'B' & $iInc)
					_Excel_RangeWrite($oWorkbook, 'ASi', $iTrunk, 'C' & $iInc)
					If $aNodes[$iNode][$iMaster][$iTrunk][1] = '-' Then
						_Excel_RangeWrite($oWorkbook, 'ASi', "'" & $iNode, 'D' & $iInc)
					Else
						_Excel_RangeWrite($oWorkbook, 'ASi', "'" & $iNode & _Excel_ColumnToLetter($iExtension + 1), 'D' & $iInc)
					EndIf
					$iInc += 1
				EndIf
			Next
		Next
	Next
Next

Func _AddIOMod($iFirstAvailCol, $sModule, $sWiredTo, $sSigType, $sASiMaster)
	ConsoleWrite('_AddIOMod(' & $iFirstAvailCol & ',' & $sModule & ',' & $sWiredTo & ',' & $sSigType & ')' & @CRLF)
	$bAssigned = False
	$aIO[9][$iFirstAvailCol] = $sModule

	For $iMaster = 0 To UBound($aNodes, 2) - 1
		If $bAssigned Then ExitLoop
		$sRemotePanel = StringLeft($sWiredTo, StringInStr($sWiredTo, '_JB') - 1)
		If $aNodes[0][$iMaster][0][0] <> $sASiMaster Then ContinueLoop

		For $iTrunk = 0 To UBound($aNodes, 3) - 1
			If $bAssigned Then ExitLoop
			For $iNode = 1 To UBound($aNodes, 1) - 1
				If $bAssigned Then ExitLoop
				For $iExtension = 0 To UBound($aNodes, 4) - 1
					If $bAssigned Then ExitLoop
					If $iExtension > 0 And ($sSigType = 'AI' Or $sSigType = 'AO') Then ContinueLoop
					If $aNodes[$iNode][$iMaster][$iTrunk][$iExtension] = '' Then
						ConsoleWrite("Master: " & $aNodes[0][$iMaster][0][0] & " $iTrunk: " & $iTrunk & " $iNode: " & $iNode & ' $iExtension: ' & $iExtension & ' $sWiredTo: ' & $sWiredTo & @CRLF)
						$aNodes[$iNode][$iMaster][$iTrunk][$iExtension] = $sWiredTo
						If ($sSigType = 'AI' Or $sSigType = 'AO') Then $aNodes[$iNode][$iMaster][$iTrunk][1] = '-'
						$bAssigned = True
					EndIf
				Next
			Next
		Next
	Next

	If Not $bAssigned Then
		MsgBox(0, '', $sWiredTo & ' not assigned a node')
	EndIf
EndFunc   ;==>_AddIOMod

Func _Exit()
	Exit
EndFunc   ;==>_Exit
