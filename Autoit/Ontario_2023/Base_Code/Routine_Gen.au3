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

		$sTemplate = FileRead($sTemplatePath & $sType & 'Tag.L5X')
		$sNewText = $sTemplate

		$sNewText = StringReplace($sNewText, 'TargetName="' & $sType & 'Tag' & '"', 'TargetName="' & $sName & '"')
		$sNewText = StringReplace($sNewText, '<Routine Use="Target" Name="' & $sType & 'Tag' & '" Type="FBD">', '<Routine Use="Target" Name="' & $sName & '" Type="FBD">')
		$sNewText = StringReplace($sNewText, $sType & 'Tag_Inp', $sName & '_Inp')
		$sNewText = StringReplace($sNewText, $sType & 'Tag_Out', $sName & '_Out')
		$sNewText = StringReplace($sNewText, $sType & 'Tag', $sName)
		$sNewText = StringReplace($sNewText, $sType & 'Desc', $sDesc)
		$sNewText = StringReplace($sNewText, 'UnitTag', $sUnit)
		$sNewText = StringReplace($sNewText, 'UnitDesc', $sUnitDesc)

		_FileCreate('X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Line' & $sLine & '\' & $sUnit & '\' & $sName & '.L5X')
		FileWrite('X:\2022_Ontario\SystemIntegrator\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Line' & $sLine & '\' & $sUnit & '\' & $sName & '.L5X', $sNewText)

	Next
EndFunc   ;==>_Routine_Generator

Func _Exit()
	Exit
EndFunc   ;==>_Exit