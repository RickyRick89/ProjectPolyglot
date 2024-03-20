#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

$iXModStart = 350
$iYModStart = 40
$iXModInc = 900
$iYModInc = 400

$iXRefInc = 125
$iYRefInc = 20

Global $sNewRoutines
Global $sRoutineFooter = '</FBDContent>' & @CRLF & '</Routine>'
Global $sSheetFooter = '</Sheet>'
Local $aListOfMasters[1], $sPreviousRoutineName, $sItemID, $sSheetIRefText, $sSheetORefText, $sSheetAOIText, $sSheetWireText
$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_HBF\ASI_Mapping\DIST_5_ASI_Addresses.xlsx"
$sBaseTextpath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_HBF\ASI_Mapping\ASI_Mapping_Help-BaseText.L5x"
$aBaseText = FileReadToArray($sBaseTextpath)

$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

MsgBox(0, '', 'Sort the spreadsheet in this order: Node, Sub-Node, Segment, Master')

$aSheet = _Excel_RangeRead($oWorkbook, 'Sheet1')
For $x = UBound($aSheet) - 1 To 1 Step -1
	If $aSheet[$x][1] = '' Then
		ReDim $aSheet[UBound($aSheet) - 1][UBound($aSheet, 2)]
	EndIf
Next
;~ _ArrayDisplay($aSheet)

For $x = 1 To UBound($aSheet) - 1
	$sMasterName = $aSheet[$x][2]
	$sSegment = $aSheet[$x][3]
	$sNodeAddress = StringFormat("%02i", $aSheet[$x][5])
	$sSubNode = $aSheet[$x][6]

	If $sMasterName = '' Or $sSegment = '' Or $sNodeAddress = '' Or $sSubNode = '' Then
		MsgBox(0, '', 'Skipping ' & $aSheet[$x][1])
		ContinueLoop
	EndIf

	If $sSubNode = 'B' Then
		$bIsBNode = 1
	Else
		$bIsBNode = 0
	EndIf

	If $sNodeAddress = '' Then ContinueLoop
	If _ArraySearch($aListOfMasters, $sMasterName) < 0 Then
		If $aListOfMasters[0] > 0 And StringRight($sNewRoutines, StringLen($sSheetFooter)) <> $sSheetFooter Then

			$sNewRoutines &= @CRLF & $sSheetIRefText & $sSheetORefText & $sSheetAOIText & $sSheetWireText & @CRLF & $sSheetFooter & @CRLF & $sRoutineFooter

			$sSheetIRefText = ''
			$sSheetORefText = ''
			$sSheetAOIText = ''
			$sSheetWireText = ''
		EndIf
		_ArrayAdd($aListOfMasters, $sMasterName)
		$aListOfMasters[0] += 1
		$sNewRoutines &= @CRLF & __AddMaster($sMasterName, $sMasterName, $aListOfMasters[0])
	EndIf
	$sRoutineName = $sMasterName & '_Seg' & $sSegment & $sSubNode & '_Nodes'
	If $sRoutineName <> $sPreviousRoutineName Then
		If $sItemID > 0 And StringRight($sNewRoutines, StringLen($sSheetFooter)) <> $sSheetFooter Then

			$sNewRoutines &= @CRLF & $sSheetIRefText & $sSheetORefText & $sSheetAOIText & $sSheetWireText & @CRLF & $sSheetFooter

			$sSheetIRefText = ''
			$sSheetORefText = ''
			$sSheetAOIText = ''
			$sSheetWireText = ''
		EndIf

		$sRoutineHeader = '<Routine Name="' & $sRoutineName & '" Type="FBD">' & @CRLF & '<FBDContent SheetSize="Tabloid - 11 x 17 in" SheetOrientation="Landscape">'
		$sNewRoutines &= @CRLF & $sRoutineFooter & @CRLF & $sRoutineHeader
		$iSheetCount = 0
		$iAOICount = 0
	EndIf
	$sPreviousRoutineName = $sRoutineName

	$sSlaveName = $sMasterName & '_Seg' & $sSegment & '_N' & $sNodeAddress & $sSubNode

	$iAOICount += 1

	If $iSheetCount = 0 Or $iAOICount > 4 Then
		$iSheetCount += 1
		$sSheetHeader = '<Sheet Number="' & $iSheetCount & '">'

		$sNewRoutines &= @CRLF & $sSheetIRefText & $sSheetORefText & $sSheetAOIText & $sSheetWireText

		If $iSheetCount = 1 Then
			$sNewRoutines &= @CRLF & $sSheetHeader
		Else
			$sNewRoutines &= @CRLF & $sSheetFooter & @CRLF & $sSheetHeader
		EndIf
		$iAOICount = 1

		$sSheetIRefText = ''
		$sSheetORefText = ''
		$sSheetAOIText = ''
		$sSheetWireText = ''
	EndIf

	If Mod($iAOICount, 2) = 0 Then
		$iXPos = $iXModStart + $iXModInc
	Else
		$iXPos = $iXModStart
	EndIf
	If $iAOICount > 2 Then
		$iYPos = $iYModStart + $iYModInc
	Else
		$iYPos = $iYModStart
	EndIf

	$iXIRefStart = $iXPos - 200
	$iYIRefStart = $iYPos + 68
	$iXORefStart = $iXPos + 200
	$iYORefStart = $iYPos + 68

	$sItemID += 1
	$iNodeID = $sItemID
	$sSheetIRefText &= @CRLF & __AddIRef($sItemID, $iXIRefStart + $iXRefInc, $iYIRefStart + $iYRefInc * 8, $sNodeAddress)
	$sItemID += 1
	$iSegmentID = $sItemID
	$sSheetIRefText &= @CRLF & __AddIRef($sItemID, $iXIRefStart + $iXRefInc, $iYIRefStart + $iYRefInc * 9, $sSegment)
	$sItemID += 1
	$iBNodeId = $sItemID
	$sSheetIRefText &= @CRLF & __AddIRef($sItemID, $iXIRefStart + $iXRefInc, $iYIRefStart + $iYRefInc * 10, $bIsBNode)

	Local $aRefIDs[17], $iIRefCount = 0, $iORefCount = 0
	For $y = 8 To 15

		If $aSheet[$x][$y] <> '' Then
			$sTag = StringReplace($aSheet[$x][$y], ' ', '_')
		Else
			$sTag = '0'
		EndIf
		$sItemID += 1
		$aRefIDs[$y - 7] = $sItemID
		If $y < 12 Or ($y > 15 And $y < 20) Then
			If $sTag <> '0' Then
				$sSheetORefText &= @CRLF & __AddORef($sItemID, $iXORefStart + $iXRefInc * Mod($y, 2), $iYORefStart + $iYRefInc * $iORefCount, $sTag)
			EndIf
			$iORefCount += 1
		Else
			$sSheetIRefText &= @CRLF & __AddIRef($sItemID, $iXIRefStart + $iXRefInc * Mod($y, 2), $iYIRefStart + $iYRefInc * $iIRefCount, $sTag)
			$iIRefCount += 1
		EndIf

	Next


	If Mod($iAOICount, 2) = 0 Then
		$iXPos = $iXModStart + $iXModInc
	Else
		$iXPos = $iXModStart
	EndIf
	If $iAOICount > 2 Then
		$iYPos = $iYModStart + $iYModInc
	Else
		$iYPos = $iYModStart
	EndIf


	ConsoleWrite(@CRLF & $sSlaveName)
	ConsoleWrite(@CRLF & '-->' & $iAOICount)
	$sItemID += 1
	$sAOISlaveText = '<AddOnInstruction Name="ASI_Slave_Map" ID="' & $sItemID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sSlaveName & '" VisiblePins="ASM DI1 DI2 DI3 DI4 DO1 DO2 DO3 DO4 AI1 AI2 AI3 AI4 AO1 AO2 AO3 AO4 LPF LAS Node Segment B_Node">' & @CRLF & '<InOutParameter Name="ASM" Argument="' & $sMasterName & '_Data"/>' & @CRLF & '</AddOnInstruction>'
	$sSheetAOIText &= @CRLF & $sAOISlaveText

	$sSheetWireText &= @CRLF & '<Wire FromID="' & $iSegmentID & '" ToID="' & $sItemID & '" ToParam="Segment"/>'
	$sSheetWireText &= @CRLF & '<Wire FromID="' & $iNodeID & '" ToID="' & $sItemID & '" ToParam="Node"/>'
	$sSheetWireText &= @CRLF & '<Wire FromID="' & $iBNodeId & '" ToID="' & $sItemID & '" ToParam="B_Node"/>'
	For $z = 1 To 16
		Select
			Case $z <= 4
				$sParam = 'DI' & $z
			Case $z >= 5 And $z <= 8
				$sParam = 'DO' & ($z - 4)
			Case $z >= 9 And $z <= 12
				$sParam = 'AI' & ($z - 8)
			Case $z >= 13 And $z <= 16
				$sParam = 'AO' & ($z - 12)
		EndSelect
		If StringInStr($sParam, 'I') Then
			$sSheetWireText &= @CRLF & '<Wire FromID="' & $sItemID & '" FromParam="' & $sParam & '" ToID="' & $aRefIDs[$z] & '"/>'
		Else
			$sSheetWireText &= @CRLF & '<Wire FromID="' & $aRefIDs[$z] & '" ToID="' & $sItemID & '" ToParam="' & $sParam & '"/>'
		EndIf
	Next

Next

$sNewRoutines &= @CRLF & $sSheetIRefText & $sSheetORefText & $sSheetAOIText & $sSheetWireText
$sNewRoutines &= @CRLF & $sSheetFooter & @CRLF & $sRoutineFooter
$sNewRoutines = StringReplace($sNewRoutines, @CRLF & @CRLF, @CRLF)

For $x = 0 To UBound($aBaseText) - 1
	If $aBaseText[$x] = '<Routines>' And $aBaseText[$x + 1] = '' Then
		$aBaseText[$x + 1] = $sNewRoutines
		ExitLoop
	EndIf
Next

_FileWriteFromArray(@ScriptDir & '\ASI_Import.L5X', $aBaseText, Default, Default, @CRLF)
ClipPut($sNewRoutines)
MsgBox(0, '', $sNewRoutines)
Exit

Func __AddIRef($sItemID, $iXPos, $iYPos, $sTag)
	$sIRefText = '<IRef ID="' & $sItemID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sTag & '" HideDesc="false"/>'
	Return $sIRefText
EndFunc   ;==>__AddIRef


Func __AddORef($sItemID, $iXPos, $iYPos, $sTag)
	$sIRefText = '<ORef ID="' & $sItemID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sTag & '" HideDesc="false"/>'
	Return $sIRefText
EndFunc   ;==>__AddORef

Func __AddMaster($sRoutineName, $sModuleName, $sMasterID)
	$iXPos = 400
	$iYPos = 140
	$sRoutineHeader = '<Routine Name="' & $sRoutineName & '" Type="FBD">' & @CRLF & '<FBDContent SheetSize="Tabloid - 11 x 17 in" SheetOrientation="Landscape">'
	$sSheetHeader = '<Sheet Number="1">'
	$sAOIMasterText = '<AddOnInstruction Name="ASI_AC1422_Mapping" ID="' & $sMasterID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sModuleName & '_Mapping" VisiblePins="SlaveStatus_MSG ASI_Master ASI_Inp ASI_Out">' & @CRLF & '<InOutParameter Name="ASI_Inp" Argument="' & $sModuleName & ':I"/>' & @CRLF & '<InOutParameter Name="ASI_Master" Argument="' & $sModuleName & '_Data"/>' & @CRLF & '<InOutParameter Name="ASI_Out" Argument="' & $sModuleName & ':O"/>' & @CRLF & '<InOutParameter Name="SlaveStatus_MSG" Argument="' & $sModuleName & '_MSG"/>' & @CRLF & '</AddOnInstruction>'

	$sReturnText = $sRoutineHeader & @CRLF & $sSheetHeader & @CRLF & $sAOIMasterText & @CRLF & $sSheetFooter
	Return $sReturnText
EndFunc   ;==>__AddMaster


;~ $sRoutineHeader = '<Routine Name="' & $sRoutineName & '" Type="FBD">' & @CRLF & '<FBDContent SheetSize="Tabloid - 11 x 17 in" SheetOrientation="Landscape">'
;~ $sRoutineFooter = '</FBDContent>' & @CRLF & '</Routine>'
;~ $sIRefText = '<IRef ID="' & $sItemID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sTag & '" HideDesc="false"/>'
;~ $sORefText = '<ORef ID="' & $sItemID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sTag & '" HideDesc="false"/>'
;~ $sAOIMasterText = '<AddOnInstruction Name="ASI_AC1422_Mapping" ID="' & $sMasterID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sModuleName & '_Mapping" VisiblePins="SlaveStatus_MSG ASI_Master ASI_Inp ASI_Out">' & @CRLF & '<InOutParameter Name="ASI_Inp" Argument="' & $sModuleName & ':I"/>' & @CRLF & '<InOutParameter Name="ASI_Master" Argument="' & $sModuleName & '_Data"/>' & @CRLF & '<InOutParameter Name="ASI_Out" Argument="' & $sModuleName & ':O"/>' & @CRLF & '<InOutParameter Name="SlaveStatus_MSG" Argument="' & $sModuleName & '_MSG"/>' & @CRLF & '</AddOnInstruction>'
;~ $sAOISlaveText = '<AddOnInstruction Name="ASI_Slave_Map" ID="' & $sItemID & '" X="' & $iXPos & '" Y="' & $iYPos & '" Operand="' & $sNodeAddress & '" VisiblePins="ASM DI1 DI2 DI3 DI4 DO1 DO2 DO3 DO4 AI1 AI2 AI3 AI4 AO1 AO2 AO3 AO4 LPF LAS Node Segment B_Node">' & @CRLF & '<InOutParameter Name="ASM" Argument="' & $sMasterName & '_Data"/>' & @CRLF & '</AddOnInstruction>'




