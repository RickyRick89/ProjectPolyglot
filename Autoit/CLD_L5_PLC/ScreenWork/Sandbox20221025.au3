#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sEnetTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\ScreenWork\ENET.xml")
$sASMTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\ScreenWork\ASM.xml")


$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\ScreenWork\Report.xlsx"

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
$iRowStart = 7
;~ $sPLC = 'CA_DIST_5'
;~ $sPLC = 'CA_PROC_5A'
$sPLC = 'CA_PROC_5B'
For $iRow = $iRowStart To UBound($aSheet) - 1
	$sModuleName = $aSheet[$iRow][0]
	$sModule = $aSheet[$iRow][1]
	$sIP = $aSheet[$iRow][2]
	$sForthOctet = StringTrimLeft($sIP, StringInStr($sIP, '.', 0, 3))
	$sThirdOctet = StringReplace(StringTrimLeft($sIP, StringInStr($sIP, '.', 0, 2)), '.' & $sForthOctet, '')
;~ 	MsgBox(0, '', $sThirdOctet & @CRLF & $sForthOctet)

	If $sModule = 'AC1422' Then
		$sTemp = StringReplace($sASMTemplate, '{Number}', $iRow)
	Else
		$sTemp = StringReplace($sEnetTemplate, '{Number}', $iRow)
	EndIf

	If $sThirdOctet = 164 Then
		If $sPLC = 'CA_PROC_5A' Then
			$sTag = 'L5A_IO_A'
		Else
			$sTag = 'L5B_IO_A'
		EndIf
	ElseIf $sThirdOctet = 165 Then
		If $sPLC = 'CA_PROC_5A' Then
			$sTag = 'L5A_IO_B'
		Else
			$sTag = 'L5B_IO_B'
		EndIf
	Else
		MsgBox(0, '', 'Third Octet?')
		Exit
	EndIf
	If $sPLC = 'CA_DIST_5' Then
		$sTag = 'DIST_IO_A'
	EndIf

	$sTemp = StringReplace($sTemp, '{Top1}', Floor(($iRow - $iRowStart) / 6) * 50)
	$sTemp = StringReplace($sTemp, '{Top2}', Floor(($iRow - $iRowStart) / 6) * 50 + 17)
	$sTemp = StringReplace($sTemp, '{Left1}', Mod(($iRow - $iRowStart), 6) * 150)
	$sTemp = StringReplace($sTemp, '{Left2}', Mod(($iRow - $iRowStart), 6) * 150 + 3)
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
