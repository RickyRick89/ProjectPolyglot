#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sEnetTemplate = FileRead("Y:\My_Scripts\ML_L1&2\ScreenWork\ENET.xml")
$sASMTemplate = FileRead("Y:\My_Scripts\ML_L1&2\ScreenWork\ASM.xml")
$sMotorTemplate = FileRead("Y:\My_Scripts\ML_L1&2\ScreenWork\Motor.xml")
$sVSDTemplate = FileRead("Y:\My_Scripts\ML_L1&2\ScreenWork\VSD.xml")
$sTextTemplate = FileRead("Y:\My_Scripts\ML_L1&2\ScreenWork\Text.xml")

$sWorkbookPath = "Y:\My_Scripts\ML_L1&2\ScreenWork\HBF_B_Report.xlsx"

$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf
$aSheet = _Excel_RangeRead($oWorkbook)

;~ _ArrayDisplay($aSheet)

$sNewText = ''
$iRowStart = 1
For $iRow = $iRowStart To UBound($aSheet) - 1

	$sModuleName = $aSheet[$iRow][0]
	$sModule = $aSheet[$iRow][1]
	$sIP = $aSheet[$iRow][2]
	$sForthOctet = StringTrimLeft($sIP, StringInStr($sIP, '.', 0, 3))
	$sThirdOctet = StringReplace(StringTrimLeft($sIP, StringInStr($sIP, '.', 0, 2)), '.' & $sForthOctet, '')
;~ 	MsgBox(0, '', $sThirdOctet & @CRLF & $sForthOctet)

	If $sModule = 'AC1422' Then
		$sTemp = StringReplace($sASMTemplate, '{Number}', $iRow)
	ElseIf StringInStr($sModule, 'PowerFlex 525') Or StringInStr($sModule, 'ETHERNET-MODULE') Then
		$sTemp = StringReplace($sVSDTemplate, '{Number}', $iRow)
	ElseIf StringInStr($sModule, '193-ECM') Then
		$sTemp = StringReplace($sMotorTemplate, '{Number}', $iRow)
	Else
		$sTemp = StringReplace($sEnetTemplate, '{Number}', $iRow)
	EndIf

	If StringInStr($sIP, '10.97.81') Then
		$sENET = 'A'
	ElseIf StringInStr($sIP, '10.97.82') Then
		$sENET = 'B'
	Else
		$sENET = 'C'
	EndIf

	$sTag = 'MOLA_L01_IO_' & $sENET

	$sPLC = 'MOS_L01_CLX'

	$sTemp = StringReplace($sTemp, '{Top1}', Floor(($iRow - $iRowStart) / 10) * 50)
	$sTemp = StringReplace($sTemp, '{Top2}', Floor(($iRow - $iRowStart) / 10) * 50 + 17)
	$sTemp = StringReplace($sTemp, '{Left1}', Mod(($iRow - $iRowStart), 10) * 150)
	$sTemp = StringReplace($sTemp, '{Left2}', Mod(($iRow - $iRowStart), 10) * 150 + 3)
	$sTemp = StringReplace($sTemp, '{Index}', $sForthOctet)
	$sTemp = StringReplace($sTemp, '{TagName}', $sTag)
	$sTemp = StringReplace($sTemp, '{PLC}', $sPLC)
	$sTemp = StringReplace($sTemp, '{ModName}', $sModuleName)

	$sNewText &= @CRLF & $sTemp


Next

ClipPut($sNewText)
MsgBox(0, '', $sNewText)




Func _Exit()
	Exit
EndFunc   ;==>_Exit
