#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\AJs_M&I.xlsx"

$sTagWorkbookPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\AJs_Tag_Generator.xlsm"
$sTagSheetName = 'Tags'

Global $aText[1], $aHandles[1]
Global $aReplaceInfo[1][6] = [['Program', 'DataTypes', 'AOIs', 'Tags', 'Rungs', 'RungCount']]


_Main_Generator('Motors')
_Main_Generator('Instruments')


Func _Main_Generator($sMISheetName)

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
		Switch $sUnit
			Case 'L5_Blancher1'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_Blancher2'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_BlnDschPmpLoop'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_SAPP'
				$sPLCWinTitle = 'Logix Designer - Ingredient'
			Case 'L5_Tote'
				$sPLCWinTitle = 'Logix Designer - CA_DIST_5'
			Case 'L5_WaterKnife'
				$sPLCWinTitle = 'Logix Designer - CA_PROC_5A'
			Case 'L5_CGd'
				$sPLCWinTitle = 'Logix Designer - CA_DIST_5'
			Case Else
				MsgBox(0, '', 'Invalid Unit')
				Exit
		EndSwitch


		If $sType = 'VFD' Or $sType = 'M2S' Then
			$sProgram = $sUnit & '_Motors'
		ElseIf $sType = 'AIn' Or $sType = 'AOut' Then
			$sProgram = $sUnit & '_Ana_Inst'
		ElseIf $sType = 'DIn' Or $sType = 'DOut' Or $sType = 'V2S' Then
			$sProgram = $sUnit & '_Dig_Inst'
		Else
			MsgBox(0, '', 'Invalid Type')
			Exit
		EndIf

		ConsoleWrite(@CRLF & '===========> $sType = ' & $sType)
		ConsoleWrite(@CRLF & '===========> $sProgram = ' & $sProgram)



		$iArrayIndex = _ArraySearch($aReplaceInfo, $sProgram, 0, 0, 0, 0, 1, 0)
		If $iArrayIndex < 0 Then
			$iArrayIndex = _ArrayAdd($aReplaceInfo, '')
			$aReplaceInfo[$iArrayIndex][0] = $sProgram
			$aReplaceInfo[$iArrayIndex][5] = 0
		EndIf
;~~~~~~~~~~~~~~~~~ Data Types ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][1] = FileRead("C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\DTs.xml")

;~~~~~~~~~~~~~~~~~ AOIs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][2] = FileRead("C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\AOIs.xml")

;~~~~~~~~~~~~~~~~~ Tags ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][3] &= @CRLF & StringReplace(StringReplace(FileRead("C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\" & $sType & "_Tags.xml"), '[Name]', $sName), '[CLXTagName]', $sCLXTagName)

;~~~~~~~~~~~~~~~~~ Rungs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][4] &= @CRLF & StringReplace(StringReplace(StringReplace(FileRead("C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\" & $sType & "_Rungs.xml"), '[Name]', $sName), '[RungNum]', $aReplaceInfo[$iArrayIndex][5]), '[CLXTagName]', $sCLXTagName)
		$aReplaceInfo[$iArrayIndex][5] += 1


;~ 	Exit

	Next

;~ _ArrayDisplay($aReplaceInfo)

	For $x = 1 To UBound($aReplaceInfo) - 1
		$sFilePath = 'C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Main_' & $aReplaceInfo[$x][0] & '.L5X'

		$sFileText = FileRead($sTemplatePath & "\Main.L5X")
		For $y = 1 To UBound($aReplaceInfo, 2) - 1
			$sFileText = StringReplace($sFileText, '[' & $aReplaceInfo[0][$y] & ']', $aReplaceInfo[$x][$y])
		Next

		_FileCreate($sFilePath)
		FileWrite($sFilePath, $sFileText)
	Next

EndFunc   ;==>_Main_Generator

Func _Exit()
	Exit
EndFunc   ;==>_Exit

