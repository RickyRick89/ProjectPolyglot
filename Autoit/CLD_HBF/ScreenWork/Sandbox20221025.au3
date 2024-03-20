#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sEnetTemplate = FileRead("Y:\My_Scripts\CLD_HBF\ScreenWork\ENET.xml")
$sASMTemplate = FileRead("Y:\My_Scripts\CLD_HBF\ScreenWork\ASM.xml")
$sMotorTemplate = FileRead("Y:\My_Scripts\CLD_HBF\ScreenWork\Motor.xml")
$sVSDTemplate = FileRead("Y:\My_Scripts\CLD_HBF\ScreenWork\VSD.xml")
$sTextTemplate = FileRead("Y:\My_Scripts\CLD_HBF\ScreenWork\Text.xml")

$s15Path = "Y:\My_Scripts\CLD_HBF\1515 Vlan Network Devices - 20230303.xlsx"
$s18Path = "Y:\My_Scripts\CLD_HBF\1518 Vlan Network Devices - 20230224.xlsx"


$oWorkbook = _Excel_BookAttach($s15Path)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $s15Path)
Else
	$oExcel = $oWorkbook.Application
EndIf
$a15Sheet = _Excel_RangeRead($oWorkbook)

$oWorkbook = _Excel_BookAttach($s18Path)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $s18Path)
Else
	$oExcel = $oWorkbook.Application
EndIf
$a18Sheet = _Excel_RangeRead($oWorkbook)



$sWorkbookPath = "Y:\My_Scripts\CLD_HBF\ScreenWork\HBF_B_Report.xlsx"

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
;~ 	$sPLC = 'HBF_A'
	$sPLC = 'HBF_B'

	$sModuleName = $aSheet[$iRow][0]
	$sModule = $aSheet[$iRow][1]
	$sIP = $aSheet[$iRow][2]
	$sForthOctet = StringTrimLeft($sIP, StringInStr($sIP, '.', 0, 3))
	$sThirdOctet = StringReplace(StringTrimLeft($sIP, StringInStr($sIP, '.', 0, 2)), '.' & $sForthOctet, '')
;~ 	MsgBox(0, '', $sThirdOctet & @CRLF & $sForthOctet)

	$sMCP = ''
	If Number($sThirdOctet) = 15 Then
		$iIndex = _ArraySearch($a15Sheet, $sIP, 0, 0, 0, 0, 1, 6)
		If $iIndex >= 0 Then
			If StringInStr($a15Sheet[$iIndex][0], 'MCP') Then
				$iStart = StringInStr($a15Sheet[$iIndex][0], 'MCP') + 3
				$iEnd = StringInStr($a15Sheet[$iIndex][0], ' ', 0, 1, $iStart)
				$sMCP = Abs(Number(StringMid($a15Sheet[$iIndex][0], $iStart, $iEnd - $iStart)))
			Else
				$sMCP = ''
			EndIf
		Else
			$sMCP = ''
		EndIf
	ElseIf Number($sThirdOctet) = 18 Then
		$iIndex = _ArraySearch($a18Sheet, $sIP, 0, 0, 0, 0, 1, 6)
		If $iIndex >= 0 Then
			If StringInStr($a18Sheet[$iIndex][0], 'MCP') Then
				$iStart = StringInStr($a18Sheet[$iIndex][0], 'MCP') + 3
				$iEnd = StringInStr($a18Sheet[$iIndex][0], ' ', 0, 1, $iStart)
				$sMCP = Abs(Number(StringMid($a18Sheet[$iIndex][0], $iStart, $iEnd - $iStart)))
			Else
				$sMCP = ''
			EndIf
		Else
			$sMCP = ''
		EndIf
	EndIf

	If $sModule = 'AC1422' Then
		$sTemp = StringReplace($sASMTemplate, '{Number}', $iRow)
	ElseIf StringInStr($sModule, 'PowerFlex 525') Then
		$sTemp = StringReplace($sVSDTemplate, '{Number}', $iRow)
	ElseIf StringInStr($sModule, '193-ECM') Then
		$sTemp = StringReplace($sMotorTemplate, '{Number}', $iRow)
	Else
		$sTemp = StringReplace($sEnetTemplate, '{Number}', $iRow)
	EndIf

	$sTag = $sPLC & '_IO'

	$sPLC = 'CA_' & $sPLC

	$sTemp = StringReplace($sTemp, '{Top1}', Floor(($iRow - $iRowStart) / 10) * 50)
	$sTemp = StringReplace($sTemp, '{Top2}', Floor(($iRow - $iRowStart) / 10) * 50 + 17)
	$sTemp = StringReplace($sTemp, '{Left1}', Mod(($iRow - $iRowStart), 10) * 150)
	$sTemp = StringReplace($sTemp, '{Left2}', Mod(($iRow - $iRowStart), 10) * 150 + 3)
	$sTemp = StringReplace($sTemp, '{Index}', $sForthOctet)
	$sTemp = StringReplace($sTemp, '{TagName}', $sTag)
	$sTemp = StringReplace($sTemp, '{PLC}', $sPLC)
	$sTemp = StringReplace($sTemp, '{ModName}', $sModuleName)

	$sNewText &= @CRLF & $sTemp

	$sTemp = StringReplace($sTextTemplate, '{Top1}', Floor(($iRow - $iRowStart) / 10) * 50)
	$sTemp = StringReplace($sTemp, '{Left1}', Mod(($iRow - $iRowStart), 10) * 150)
	$sTemp = StringReplace($sTemp, '{MCP}', 'MCP-' & $sMCP)
	$sTemp = StringReplace($sTemp, '{Number}', $iRow)

	$sNewText &= @CRLF & $sTemp


Next

ClipPut($sNewText)
MsgBox(0, '', $sNewText)




Func _Exit()
	Exit
EndFunc   ;==>_Exit
