#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Motor And Instrument List Rev 0.1.xlsx"

_Routine_Generator('Motor List')
_Routine_Generator('Instrument List')



Func _Routine_Generator($sMISheetName)

	$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
	If Not IsObj($oMIWorkbook) Then
		$oExcel = _Excel_Open()
		$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
	Else
		$oExcel = $oMIWorkbook.Application
	EndIf

	$aMISheet = _Excel_RangeRead($oMIWorkbook, $sMISheetName)

;~ _ArrayDisplay($aMISheet)
;~ _ArrayDisplay($aTagSheet)

	For $iRow = 1 To UBound($aMISheet) - 1
		ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)

		If $sMISheetName = 'Motor List' Then
			$sName = StringReplace($aMISheet[$iRow][1], '-', '')
			$sDesc = $aMISheet[$iRow][2]
			$sUnit = $aMISheet[$iRow][15]
			$sUnitDesc = $aMISheet[$iRow][16]
			$sLine = $aMISheet[$iRow][14]
			$sType = $aMISheet[$iRow][8]
		ElseIf $sMISheetName = 'Instrument List' Then
			$sName = StringReplace($aMISheet[$iRow][2], '-', '')
			$sDesc = $aMISheet[$iRow][6]
			$sUnit = $aMISheet[$iRow][22]
			$sUnitDesc = $aMISheet[$iRow][24]
			$sLine = $aMISheet[$iRow][21]
			$sType = $aMISheet[$iRow][23]
		EndIf
		$sFilePath = 'X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Line' & $sLine & '\' & $sUnit & '\' & $sName & '.L5X'
		ConsoleWrite(@CRLF & '--->' & $sFilePath)

		Local $aFileLines[1]

		_FileReadToArray($sFilePath, $aFileLines, $FRTA_NOCOUNT)
;~ 		_ArrayDisplay($aFileLines)

		For $iFileRow = 0 To UBound($aFileLines) - 1
			$sLine = $aFileLines[$iFileRow]
			If StringInStr($aFileLines[$iFileRow], '],[') And StringInStr($aFileLines[$iFileRow], '$00') And (StringInStr($aFileLines[$iFileRow], $sName) Or StringInStr($aFileLines[$iFileRow], $sDesc)) Then

				$sFirstPart = StringLeft($sLine, StringInStr($sLine, '['))
				$iLenOrig = StringTrimLeft($sLine, StringInStr($sLine, '['))
				$sSecondPart = StringTrimLeft($iLenOrig, StringInStr($iLenOrig, ',') - 1)
				$iLenOrig = StringLeft($iLenOrig, StringInStr($iLenOrig, ',') - 1)

;~ 				MsgBox(0, '', $sFirstPart)
;~ 				MsgBox(0, '', $sSecondPart)
;~ 				MsgBox(0, '', $iLenOrig)
				$sString = StringTrimLeft($sLine, StringInStr($sLine, "'"))
				$sString = StringLeft($sString, StringInStr($sString, "'") - 1)
;~ 				MsgBox(0, '', $sString)
				$sStringTemp = StringReplace($sString, '$00', '')
;~ 				MsgBox(0, '', StringLen($sStringTemp))
				$sLine = $sFirstPart & StringLen($sStringTemp) & $sSecondPart
				$iDiff = StringLen($sStringTemp) - $iLenOrig
;~ 				MsgBox(0, StringReplace($sString, '$00', '|'), StringLen(StringReplace($sString, '$00', '|')) - $iDiff)
;~ 				MsgBox(0, '', $iDiff)
				If $iDiff < 0 Then
					$aFileLines[$iFileRow] = StringReplace($sLine, '$00', '$00$00', Abs($iDiff) * -1)
				Else
					$aFileLines[$iFileRow] = StringReplace($sLine, '$00', '', $iDiff * -1)
				EndIf
;~ 				MsgBox(0, '', $aFileLines[$iFileRow])


			EndIf
		Next

		$sNewText = _ArrayToString($aFileLines, @CRLF)
		_FileCreate($sFilePath)
		FileWrite($sFilePath, $sNewText)

	Next
EndFunc   ;==>_Routine_Generator

Func _Exit()
	Exit
EndFunc   ;==>_Exit
