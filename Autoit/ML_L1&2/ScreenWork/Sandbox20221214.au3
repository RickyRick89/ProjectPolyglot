#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

Local $aScreenFile[1]

$sEnetTemplate = FileRead("Y:\My_Scripts\ML_L1&2\ScreenWork\Templates\CommandTemplate.txt")


$sScreenPath = "Y:\My_Scripts\ML_L1&2\ScreenWork\export\mf_l5_system_5b.xml"
$sWorkbookPath = "Y:\My_Scripts\ML_L1&2\ScreenWork\L5b_Report.xlsx"

$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf
$aSheet = _Excel_RangeRead($oWorkbook)


$sMotrTagsPath = "Y:\My_Scripts\ML_L1&2\ScreenWork\Motor_Tags.xlsx"

$oWorkbook = _Excel_BookAttach($sMotrTagsPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sMotrTagsPath)
Else
	$oExcel = $oWorkbook.Application
EndIf
$aMotorTags = _Excel_RangeRead($oWorkbook)


_FileReadToArray($sScreenPath, $aScreenFile, $FRTA_NOCOUNT)

$sNewText = ''
$iRowStart = 17
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

	ConsoleWrite(@CRLF & '-->' & $sModuleName)

	$sTemp = StringReplace($sEnetTemplate, '{PLC}', $sPLC)

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
	$sSearch = $sTag & '.IP[' & $sForthOctet & '].0.@Description}'


	If StringInStr($sModule, ' 525') Then
		$sType = 'pf52x'
	ElseIf StringInStr($sModule, ' 755') Then
		$sType = 'pf755'
	ElseIf StringInStr($sModule, '193-ECM') Then
		$sType = 'e300ovld'
		For $iMotor = 0 To UBound($aMotorTags) - 1
			If $sModuleName = StringRight($aMotorTags[$iMotor], StringLen($sModuleName)) Then
				$sModuleName = $aMotorTags[$iMotor] & '_Ovld&quot;},{&quot;' & $sModuleName

				ExitLoop
			EndIf
		Next

	Else
;~ 		MsgBox(0, '', $sModule)
		ContinueLoop
	EndIf



	$sTemp = StringReplace($sTemp, '{Name}', $sModuleName)
	$sTemp = StringReplace($sTemp, '{Type}', $sType)



	For $iInc = UBound($aScreenFile) - 1 To 0 Step -1
		If StringInStr($aScreenFile[$iInc], $sSearch) And Not StringInStr($aScreenFile[$iInc + 2], $sModuleName) Then
			$aScreenFile[$iInc + 2] = $sTemp
			ExitLoop
		EndIf


	Next



Next

$sNewText = _ArrayToString($aScreenFile, @CRLF)
_FileCreate($sScreenPath)
FileWrite($sScreenPath, $sNewText)
;~ MsgBox(0, '', $sNewText)




Func _Exit()
	Exit
EndFunc   ;==>_Exit



