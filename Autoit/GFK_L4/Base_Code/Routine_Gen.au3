#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "W:\My_Scripts\GFK_L4\Base_Code\Motor And Instrument List Rev 1.xlsx"

_Routine_Generator('Motor List')
_Routine_Generator('Instrument List')

RunWait(@AutoItExe & ' "' & @ScriptDir & '\Routine_Cleanup.au3"')

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
			$sUnit = $aMISheet[$iRow][16]
			$sUnitDesc = $aMISheet[$iRow][17]
			$sLine = $aMISheet[$iRow][15]
			$sType = $aMISheet[$iRow][8]
		ElseIf $sMISheetName = 'Instrument List' Then
			$sName = StringReplace($aMISheet[$iRow][2], '-', '')
			$sDesc = $aMISheet[$iRow][6]
			$sUnit = $aMISheet[$iRow][22]
			$sUnitDesc = $aMISheet[$iRow][24]
			$sLine = $aMISheet[$iRow][21]
			$sType = $aMISheet[$iRow][23]
		EndIf
		If $sUnit = 'OEM' Or $sUnit = '' Or $sType = 'OEM' Or $sType = 'EXISTING' Then ContinueLoop

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

		_FileCreate('X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Line' & $sLine & '\' & $sUnit & '\' & $sName & '.L5X')
		FileWrite('X:\2022_Grand_Forks\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Line' & $sLine & '\' & $sUnit & '\' & $sName & '.L5X', $sNewText)

	Next
EndFunc   ;==>_Routine_Generator

Func _Exit()
	Exit
EndFunc   ;==>_Exit
