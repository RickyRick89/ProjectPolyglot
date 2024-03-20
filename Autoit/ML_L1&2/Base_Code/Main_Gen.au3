#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Motor And Instrument List Rev 0.1.xlsx"

Global $aText[1], $aHandles[1]
Global $aReplaceInfo[1][6] = [['Program', 'DataTypes', 'AOIs', 'Tags', 'Rungs', 'RungCount']]

_Main_Generator('Motor List')
_Main_Generator('Instrument List')

Func _Main_Generator($sMISheetName)

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

		If $sUnit = 'L01_DRYER' Then ContinueLoop

		Switch $sLine
			Case '1'
				$sPLCWinTitle = 'Logix Designer - MOLA_L01_CLX'
			Case '2'
				$sPLCWinTitle = 'Logix Designer - MOLA_L02_CLX'
			Case Else
				MsgBox(0, '', 'Invalid Line')
				Exit
		EndSwitch

		If $sType = 'YaskawaVSD' Or $sType = 'Motor' Or $sType = 'PF753' Then
			$sProgram = $sUnit & '_Motors'
		ElseIf $sType = 'AIn' Or $sType = 'AOut' Then
			$sProgram = $sUnit & '_Ana_Inst'
		ElseIf $sType = 'DIn' Or $sType = 'DOut' Or $sType = 'ValveSO' Then
			$sProgram = $sUnit & '_Dig_Inst'
		Else
			MsgBox(0, $sType, 'Invalid Type')
			Exit
		EndIf

		ConsoleWrite(@CRLF & '===========> $sType = ' & $sName)
		ConsoleWrite(@CRLF & '===========> $sType = ' & $sType)
		ConsoleWrite(@CRLF & '===========> $sProgram = ' & $sProgram)



		$iArrayIndex = _ArraySearch($aReplaceInfo, $sProgram, 0, 0, 0, 0, 1, 0)
		If $iArrayIndex < 0 Then
			$iArrayIndex = _ArrayAdd($aReplaceInfo, '')
			$aReplaceInfo[$iArrayIndex][0] = $sProgram
			$aReplaceInfo[$iArrayIndex][5] = 1
		EndIf
;~~~~~~~~~~~~~~~~~ Data Types ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][1] = FileRead("X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\DTs.xml")

;~~~~~~~~~~~~~~~~~ AOIs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][2] = FileRead("X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\AOIs.xml")

;~~~~~~~~~~~~~~~~~ Tags ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][3] &= @CRLF & StringReplace(StringReplace(FileRead("X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\" & $sType & "_Tags.xml"), '[Name]', $sName), '[CLXTagName]', $sName)

;~~~~~~~~~~~~~~~~~ Rungs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		$aReplaceInfo[$iArrayIndex][4] &= @CRLF & StringReplace(StringReplace(StringReplace(FileRead("X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Use_Files\" & $sType & "_Rungs.xml"), '[Name]', $sName), '[RungNum]', $aReplaceInfo[$iArrayIndex][5]), '[CLXTagName]', $sName)
		$aReplaceInfo[$iArrayIndex][5] += 1


;~ 	Exit

	Next

;~ _ArrayDisplay($aReplaceInfo)

	For $x = 1 To UBound($aReplaceInfo) - 1
		$sFilePath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Main_' & $aReplaceInfo[$x][0] & '.L5X'

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

