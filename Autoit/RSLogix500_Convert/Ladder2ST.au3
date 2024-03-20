#include <File.au3>
#include <Array.au3>

$sFilePath = "Y:\My_Scripts\RSLogix500_Convert\Use_Files\SIMPLOT_CALDWELL_ROVER26.SLC"

$aFilesLines = FileReadToArray($sFilePath)

;~ _ArrayDisplay($aFilesLines)


;~~~~~~~~~~~~~~~~~~~~Get Routine Names~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Global $aRoutines[1][2]
$bStarted = 0
For $iInc = 1 To UBound($aFilesLines) - 1
	If $bStarted = 1 Then
		If $aFilesLines[$iInc] = '' Then ExitLoop
		$aSplit = StringSplit($aFilesLines[$iInc], '"')
		_ArrayAdd($aRoutines, StringStripWS($aSplit[1], 8) & '|' & $aSplit[2])
	EndIf

	If StringInStr($aFilesLines[$iInc], 'Project') Then
		$bStarted = 1
	EndIf

Next

_ArrayDisplay($aRoutines)


;~~~~~~~~~~~~~~~~~~~~Convert Each Routine~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For $iInc = 1 To UBound($aRoutines) - 1
	$sSearchStart = 'LADDER ' & $aRoutines[$iInc][0]
	If $iInc = UBound($aRoutines) - 1 Then
		$sSearchEnd = 'DATA O:0'
	Else
		$sSearchEnd = 'LADDER ' & $aRoutines[$iInc + 1][0]
	EndIf
	$sRoutineName = $aRoutines[$iInc][1]

	$bStarted = 0
	For $iLine = 1 To UBound($aFilesLines) - 1
		If $aFilesLines[$iLine] = $sSearchStart Then
			$bStarted = 1
		EndIf
		If $bStarted = 0 Then ContinueLoop
		If StringInStr($aFilesLines[$iLine], '% Rung:') Then
			$sNewLineText = _Ladder2STConvert($aFilesLines[$iLine + 1])
		EndIf
	Next
Next

Func _Ladder2STConvert($sLadderText)
	$sNewText = $sLadderText
	$sNewText = StringReplace($sNewText, 'SOR ', '')
	$sNewText = StringReplace($sNewText, ' EOR', '')

	$bBranchStarted = 0
	If StringInStr($sNewText, 'BST') Then
		$bBranchStarted = 1
		$sNewText = StringReplace($sNewText, 'BST ', '')
		$sNewText = StringReplace($sNewText, ' BND', '')
	EndIf
	$sNewText = StringStripWS($sNewText, 2)

	$aInstructionSearch = StringSplit($sNewText, ' ')
;~ 	_ArrayDisplay($aInstructionSearch)

	$sStructuredText = ''
	$iLastInstPOS = $aInstructionSearch[0]
	$bAssignment = 0
	For $iIndex = $aInstructionSearch[0] To 1 Step -1
		$aInstructionSearch[$iIndex] = StringStripWS($aInstructionSearch[$iIndex], 8)
		If $aInstructionSearch[$iIndex] = '' Then ContinueLoop
		If Not StringRegExp($aInstructionSearch[$iIndex], "\d+") Then
			$sParams = ''
			For $iParamIndex = $iIndex + 1 To $iLastInstPOS

				$sParams &= $aInstructionSearch[$iParamIndex]
				If $iParamIndex <> $iLastInstPOS Then
					$sParams &= '|'
				EndIf
			Next

;~ 			MsgBox(0, '', $aInstructionSearch[$iIndex])
;~ 			MsgBox(0, '', $sParams)

			$sStructuredText = _InstructionReplace($aInstructionSearch[$iIndex], $sParams, $bAssignment) & $sStructuredText
			If StringInStr($sStructuredText, '[Conditions]') Then
				$bAssignment = 1
			EndIf
;~ 			MsgBox(0, '', $sStructuredText)
			$iLastInstPOS = $iIndex - 1
		EndIf
	Next

;~ 	MsgBox(0, '', $sStructuredText)
;~ 	Exit
EndFunc   ;==>_Ladder2STConvert

Func _InstructionReplace($sInstruction, $sParams, $bAssignment)
	$sReturn = ''

	$aParams = StringSplit($sParams, '|')
;~ 	_ArrayDisplay($aParams)

	Switch $sInstruction
		Case 'MOV'
			$sReturn = $aParams[2] & ' := ' & $aParams[1] & ';' & @CRLF
		Case 'JSR'
			For $iRoutineIndex = 1 To UBound($aRoutines) - 1
				If $aRoutines[$iRoutineIndex][0] = $sParams Then
					$sReturn = 'JSR(' & $aRoutines[$iRoutineIndex][1] & ');'
					ExitLoop
				EndIf
			Next
		Case 'XIC'
			If $bAssignment Then
				$sReturn = $sParams & ' = 1 ' & @CRLF
			Else
				$sReturn = 'IF ' & $sParams & ' = 1 THEN' & @CRLF
			EndIf
		Case 'XIO'
			If $bAssignment Then
				$sReturn = $sParams & ' = 0 ' & @CRLF
			Else
				$sReturn = 'IF ' & $sParams & ' = 0 THEN' & @CRLF
			EndIf
		Case 'OTL'
			$sReturn = $sParams & ' := 1;' & @CRLF
		Case 'OTU'
			$sReturn = $sParams & ' := 0;' & @CRLF
		Case 'OTE'
			$sReturn = $sParams & ' := [Conditions];' & @CRLF
		Case 'OSR'
			$sReturn &=  $aParams[2] & '.InputBit := [Conditions];' & @CRLF
			$sReturn &= 'OSRI(' & $aParams[2] & ');' & @CRLF
			$sReturn &= $aParams[2] & ' := ' & $aParams[2] & '.OutputBit;' & @CRLF
		case 'TON'
			$sReturn &= $aParams[1]&'.PRE := '($aParams[2]/.001)*$aParams[3]';'
			$sReturn &= $aParams[1]&'.Reset := NOT [Conditions];'
			$sReturn &= $aParams[1]&'.TimerEnable := [Conditions];'
			$sReturn &= 'TONR('&$aParams[1]&');'
		Case 'NXB'
			If $bAssignment Then
				$sReturn = ' OR '
			Else
				$sReturn = ''
			EndIf
		Case Else
			MsgBox(0, '', $sInstruction & '| Not Defined')
	EndSwitch
	Return $sReturn

EndFunc   ;==>_InstructionReplace

