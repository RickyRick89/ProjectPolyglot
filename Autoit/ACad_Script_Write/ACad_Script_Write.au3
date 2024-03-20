#include <Array.au3>
#include <File.au3>
#include <Excel.au3>

$sNewFileRoot = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\ACad_Script_Write\"
$sMainScriptFile = $sNewFileRoot & '_Runner.scr'

$sWindowTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\ACad_Script_Write\Templates\Window_Template.scr")
$sTextTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\ACad_Script_Write\Templates\Text_Template.scr")
$sLineTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\ACad_Script_Write\Templates\Line_Template.scr")

_FileCreate($sMainScriptFile)

For $iWinCol = 1 To 7
	For $iWinRow = 1 To 9

		$iWindowGap = 5
		$iWindowWidth = 29.9038
		$iWindowHeight = -21.25
		$iWindowLeft = ($iWindowWidth + $iWindowGap) * ($iWinCol - 1)
		$iWindowTop = ($iWindowHeight + $iWindowGap) * ($iWinRow - 1)


		$iRowLabelXOffset = 0.3759
		$iRowLabelYOffset = -0.9650
		$iRowLabelYGap = 0.5

		$iColumnLabelXOffset = 1.8613
		$iColumnLabelYOffset = -0.2391
		$iColumnLabelXGap = 3.7601

;~~~~~~~~~~~~~~Row Labels~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		$sNewText = ''

		For $iRow = (5001 + (100 * $iWinRow)) To (5040 + (100 * $iWinRow))
			$sTemp = $sTextTemplate
			$sTemp = StringReplace($sTemp, '[JUSTIFICATION]', 'LEFT')
			$sTemp = StringReplace($sTemp, '[LEFT]', $iRowLabelXOffset)
			$sTemp = StringReplace($sTemp, '[TOP]', $iRowLabelYOffset - (($iRow - 5101) * $iRowLabelYGap))
			$sTemp = StringReplace($sTemp, '[SIZE]', 0.18)
			$sTemp = StringReplace($sTemp, '[ROTATION]', 0)
			$sTemp = StringReplace($sTemp, '[TEXT]', $iRow)
			$sNewText &= $sTemp
		Next


		_FileCreate($sNewFileRoot & 'RowLabels' & $iWinCol & $iWinRow & '.scr')
		FileWrite($sNewFileRoot & 'RowLabels' & $iWinCol & $iWinRow & '.scr', $sNewText)
		FileWrite($sMainScriptFile, 'SCRIPTCALL "' & $sNewFileRoot & 'RowLabels' & $iWinCol & $iWinRow & '.scr"' & @CRLF)
		$sNewText = ''

;~~~~~~~~~~~~~~Column Labels~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		$sNewText = ''

		For $iColumn = 1 To 8
			$sTemp = $sTextTemplate
			$sTemp = StringReplace($sTemp, '[JUSTIFICATION]', 'CENTER')
			$sTemp = StringReplace($sTemp, '[LEFT]', $iColumnLabelXOffset + (($iColumn - 1) * $iColumnLabelXGap))
			$sTemp = StringReplace($sTemp, '[TOP]', $iColumnLabelYOffset)
			$sTemp = StringReplace($sTemp, '[SIZE]', 0.18)
			$sTemp = StringReplace($sTemp, '[ROTATION]', 0)
			$sTemp = StringReplace($sTemp, '[TEXT]', _Excel_ColumnToLetter($iColumn))
			$sNewText &= $sTemp

			If $iColumn > 1 Then
				$sTemp = $sLineTemplate
				$sTemp = StringReplace($sTemp, '[X1]', ($iColumnLabelXOffset + (($iColumn - 1) * $iColumnLabelXGap)) - $iColumnLabelXGap / 2)
				$sTemp = StringReplace($sTemp, '[Y1]', $iWindowTop + 0.25)
				$sTemp = StringReplace($sTemp, '[X2]', ($iColumnLabelXOffset + (($iColumn - 1) * $iColumnLabelXGap)) - $iColumnLabelXGap / 2)
				$sTemp = StringReplace($sTemp, '[Y2]', $iWindowTop - 0.25)
				$sNewText &= $sTemp
			EndIf

		Next


		_FileCreate($sNewFileRoot & 'ColumnLabels' & $iWinCol & $iWinRow & '.scr')
		FileWrite($sNewFileRoot & 'ColumnLabels' & $iWinCol & $iWinRow & '.scr', $sNewText)
		FileWrite($sMainScriptFile, 'SCRIPTCALL "' & $sNewFileRoot & 'ColumnLabels' & $iWinCol & $iWinRow & '.scr"' & @CRLF)
		$sNewText = ''



;~~~~~~~~~~~~~~Window~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		$sTemp = $sWindowTemplate
		$sTemp = StringReplace($sTemp, '[LEFT]', $iWindowLeft)
		$sTemp = StringReplace($sTemp, '[TOP]', $iWindowTop)
		$sTemp = StringReplace($sTemp, '[WIDTH]', $iWindowLeft + $iWindowWidth)
		$sTemp = StringReplace($sTemp, '[HEIGHT]', $iWindowTop + $iWindowHeight)

		$sNewText &= $sTemp

		_FileCreate($sNewFileRoot & 'Windows' & $iWinCol & $iWinRow & '.scr')
		FileWrite($sNewFileRoot & 'Windows' & $iWinCol & $iWinRow & '.scr', $sNewText)
		FileWrite($sMainScriptFile, 'SCRIPTCALL "' & $sNewFileRoot & 'Windows' & $iWinCol & $iWinRow & '.scr"' & @CRLF)
		$sNewText = ''
	Next
Next
