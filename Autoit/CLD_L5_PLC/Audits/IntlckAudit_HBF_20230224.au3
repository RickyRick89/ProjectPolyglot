#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>


Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Local $aTags[1][2]

$sTagPathRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\Tags'
$sL5XPathRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\L5X'
$sConfigRootDir = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\ConfigTools'

$aConfigFiles = _FileListToArray($sConfigRootDir, '*.xls', Default, True)
$aConfigFileNames = _FileListToArray($sConfigRootDir, '*.xls', Default, False)

$aTagFiles = _FileListToArray($sTagPathRoot, '*.csv', Default, True)
$aTagFileNames = _FileListToArray($sTagPathRoot, '*.csv', Default, False)

$aL5XFiles = _FileListToArray($sL5XPathRoot, '*.L5X', Default, True)
$aL5XFileNames = _FileListToArray($sL5XPathRoot, '*.L5X', Default, False)


For $x = 1 To $aTagFileNames[0]
	Local $aL5XFileLinesTemp[1]
	Local $aNewTagFile[7][7]
	Local $aList[1][3]
	$aList[0][0] = 'Interlock'
	$aList[0][1] = 'Description'
	$aList[0][2] = 'Logic'

	$aNewTagFile[0][0] = 'remark'
	$aNewTagFile[1][0] = 'remark'
	$aNewTagFile[2][0] = 'remark'
	$aNewTagFile[3][0] = 'remark'
	$aNewTagFile[4][0] = 'remark'
	$aNewTagFile[5][0] = '0.3'
	$aNewTagFile[0][1] = 'CSV-Import-Export'
	$aNewTagFile[1][1] = 'Date = Sat Oct 22 08:29:40 2022'
	$aNewTagFile[2][1] = 'Version = RSLogix 5000 v31.02'
	$aNewTagFile[3][1] = 'Owner = Triplex'
	$aNewTagFile[4][1] = 'Company = '
	$aNewTagFile[6][0] = 'TYPE'
	$aNewTagFile[6][1] = 'SCOPE'
	$aNewTagFile[6][2] = 'NAME'
	$aNewTagFile[6][3] = 'DESCRIPTION'
	$aNewTagFile[6][4] = 'DATATYPE'
	$aNewTagFile[6][5] = 'SPECIFIER'
	$aNewTagFile[6][6] = 'ATTRIBUTES'

	$sWorkbookPath = $aTagFiles[$x]
	$sControllerName = StringLeft($aTagFileNames[$x], StringInStr($aTagFileNames[$x], '_', 0, 3) - 1)
	ConsoleWrite(@CRLF & '==================>' & $sControllerName)
	$sNewFilePath = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Audits\Report\' & $sControllerName & '.csv'

	FileDelete($sNewFilePath)

	For $y = 1 To $aL5XFileNames[0]

		If StringInStr($aL5XFileNames[$y], $sControllerName) Then
			$iL5XFileInc = $y
			_FileReadToArray($aL5XFiles[$y], $aL5XFileLinesTemp)
			Local $aL5XFileLines[1]

			For $z = 1 To $aL5XFileLinesTemp[0] - 2
				If StringInStr($aL5XFileLinesTemp[$z], '_Intlk.Inp_') Then
					$aL5XFileLines[0] = _ArrayAdd($aL5XFileLines, $aL5XFileLinesTemp[$z])
;~ 					ConsoleWrite(@CRLF & '-->' & $aL5XFileLines[0])
				EndIf
			Next
			ExitLoop
		EndIf


		If $y = $aL5XFileNames[0] Then
			MsgBox(0, '', 'L5X not found for ' & $sControllerName)
			Exit
		EndIf
	Next
	For $y = 1 To $aConfigFileNames[0]

		If StringInStr($aConfigFileNames[$y], $sControllerName) Then

			$oWorkbook = _Excel_BookAttach($aConfigFiles[$y])
			If Not IsObj($oWorkbook) Then
				$oExcel = _Excel_Open()
				$oWorkbook = _Excel_BookOpen($oExcel, $aConfigFiles[$y])
			Else
				$oExcel = $oWorkbook.Application
			EndIf

			$aConfigSheet = _Excel_RangeRead($oWorkbook, 'P_Intlk')

;~ 			_Excel_BookClose($oWorkbook)
		EndIf
	Next


	$oWorkbook = _Excel_BookAttach($sWorkbookPath)
	If Not IsObj($oWorkbook) Then
		$oExcel = _Excel_Open()
		$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
	Else
		$oExcel = $oWorkbook.Application
	EndIf

	$aSheet = _Excel_RangeRead($oWorkbook)

	_Excel_BookClose($oWorkbook)


	For $iRow = 7 To UBound($aSheet) - 1
		$sType = $aSheet[$iRow][0]
		$sScope = $aSheet[$iRow][1]
		$sTagName = $aSheet[$iRow][2]
		$sDesc = $aSheet[$iRow][3]
		$sDataType = $aSheet[$iRow][4]
		$sDataSpecifier = $aSheet[$iRow][5]
		$sDataAttributes = $aSheet[$iRow][6]

		If Not StringInStr($sDataType, 'P_Intlk') Then
			ContinueLoop
		EndIf

		ConsoleWrite(@CRLF & '++++++>' & $sTagName)

		$iConfigRow = _ArraySearch($aConfigSheet, $sTagName, 0, 0, 0, 1, 1, 2)


		For $iIntlkNum = 0 To 8
			$sTempLogic = ''
			If $iConfigRow < 0 Then ExitLoop

			$sInterlockTag = $sTagName & '.Inp_Intlk0' & $iIntlkNum
			ConsoleWrite(@CRLF & '>>>>>' & $sInterlockTag)
			$sInterlockDesc = $aConfigSheet[$iConfigRow][($iIntlkNum * 6) + 7]
			ConsoleWrite(@CRLF & '>>>' & $sInterlockDesc)

			$iL5XRow = _ArraySearch($aL5XFileLines, 'OTE(' & $sInterlockTag & ')', 0, 0, 0, 1)
			If $iL5XRow >= 0 Then
				$aBranches = StringSplit($aL5XFileLines[$iL5XRow], ',')
				$iTempRow = _ArraySearch($aBranches, 'OTE(' & $sTagName & '.Inp_Intlk0' & $iIntlkNum & ')', 0, 0, 0, 1)
				$sTempLogic = $aBranches[$iTempRow]

				$aTemp = StringSplit($sTempLogic, ')')
				$iCloseCount = $aTemp[0] - 1

				$aTemp = StringSplit($sTempLogic, '(')
				$iOpenCount = $aTemp[0] - 1

				If $iCloseCount <> $iOpenCount Then
					$bNotComplete = 1
				Else
					$bNotComplete = 0
				EndIf

				If StringInStr($sTempLogic, ']') Or $bNotComplete Then
					For $iInc = $iTempRow - 1 To 1 Step -1
						$sTempLogic = $aBranches[$iInc] & ',' & $sTempLogic

						$aTemp = StringSplit($sTempLogic, ')')
						$iCloseCount = $aTemp[0] - 1

						$aTemp = StringSplit($sTempLogic, '(')
						$iOpenCount = $aTemp[0] - 1

						If (StringInStr($aBranches[$iInc], '[') And Not StringInStr($aBranches[$iInc], ']')) Or ($bNotComplete And $iCloseCount = $iOpenCount) Then
							ExitLoop
						EndIf

					Next
				EndIf
			EndIf

			ConsoleWrite(@CRLF & '>' & $sTempLogic)

			Local $aTemp[1][3] = [[$sInterlockTag, $sInterlockDesc, $sTempLogic]]
			_ArrayAdd($aList, $aTemp)
		Next



	Next

	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookNew($oExcel)
	_Excel_BookSaveAs($oWorkbook, $sNewFilePath, $xlCSV)

	_Excel_RangeWrite($oWorkbook, $sControllerName, $aList)
	_Excel_BookSave($oWorkbook)
	_Excel_BookClose($oWorkbook)

Next





Func _Exit()
	Exit
EndFunc   ;==>_Exit

