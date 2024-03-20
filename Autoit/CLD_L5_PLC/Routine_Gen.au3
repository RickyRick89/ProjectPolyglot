#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\AJs_M&I.xlsx"

$sTagWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\AJs_Tag_Generator.xlsm"
$sTagSheetName = 'Tags'

_Routine_Generator('Motors')
_Routine_Generator('Instruments')



Func _Routine_Generator($sMISheetName)

	$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
	If Not IsObj($oMIWorkbook) Then
		$oExcel = _Excel_Open()
		$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
	Else
		$oExcel = $oMIWorkbook.Application
	EndIf

	$aMISheet = _Excel_RangeRead($oMIWorkbook, $sMISheetName)

	$oTagWorkbook = _Excel_BookAttach($sTagWorkbookPath)
	If Not IsObj($oTagWorkbook) Then
		$oExcel = _Excel_Open()
		$oTagWorkbook = _Excel_BookOpen($oExcel, $sTagWorkbookPath)
	Else
		$oExcel = $oTagWorkbook.Application
	EndIf

	$aTagSheet = _Excel_RangeRead($oTagWorkbook, $sTagSheetName, Default, 1, True)

;~ _ArrayDisplay($aMISheet)
;~ _ArrayDisplay($aTagSheet)

	For $iRow = 1 To UBound($aMISheet) - 1
		ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)

		If $sMISheetName = 'Motors' Then
			$sName = StringReplace($aMISheet[$iRow][0], '-', '')
			$sDesc = $aMISheet[$iRow][3]
			$sUnit = $aMISheet[$iRow][4]
			$sLine = $aMISheet[$iRow][5]
			$sArea = $aMISheet[$iRow][6]
			$sType = $aMISheet[$iRow][11]
		ElseIf $sMISheetName = 'Instruments' Then
			$sName = StringReplace($aMISheet[$iRow][0], '-', '')
			$sDesc = $aMISheet[$iRow][4]
			$sUnit = $aMISheet[$iRow][8]
			$sLine = $aMISheet[$iRow][9]
			$sArea = $aMISheet[$iRow][10]
			$sType = $aMISheet[$iRow][7]
		EndIf
		$iTagIndex = _ArraySearch($aTagSheet, $sName, 0, 0, 0, 0, 1, 6)
		If $iTagIndex < 0 Then
			MsgBox(0, '', 'Device not found on TagList: ' & $sName)
			ContinueLoop
;~ 		Exit
		EndIf

		$sCLXTagName = $aTagSheet[$iTagIndex][11]

		$sTemplate = FileRead($sTemplatePath & $sType & 'Tag.L5X')
		$sNewText = $sTemplate

		$sNewText = StringReplace($sNewText, 'TargetName="' & $sType & 'Tag' & '"', 'TargetName="' & $sName & '"')
		$sNewText = StringReplace($sNewText, '<Routine Use="Target" Name="' & $sType & 'Tag' & '" Type="FBD">', '<Routine Use="Target" Name="' & $sName & '" Type="FBD">')
		$sNewText = StringReplace($sNewText, $sType & 'Tag_Inp', $sName & '_Inp')
		$sNewText = StringReplace($sNewText, $sType & 'Tag_Out', $sName & '_Out')
		$sNewText = StringReplace($sNewText, $sType & 'Tag', $sCLXTagName)
		$sNewText = StringReplace($sNewText, $sType & 'Desc', $sDesc)
		$sNewText = StringReplace($sNewText, 'UnitTag', $sUnit)

		_FileCreate('C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\' & $sUnit & '\' & $sName & '.L5X')
		FileWrite('C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\' & $sUnit & '\' & $sName & '.L5X', $sNewText)

	Next
EndFunc   ;==>_Routine_Generator

Func _Exit()
	Exit
EndFunc   ;==>_Exit
