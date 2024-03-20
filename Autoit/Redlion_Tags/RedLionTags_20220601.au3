#include <Excel.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')
Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

$sRegisterFilePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\Redlion_Tags\Registers.csv"

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\Redlion_Tags\Redlion_Tags.csv"

$sSheetName = 'Redlion_Tags'


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)


$sWinTitle = ' - Crimson 3.1'
$sWinTitleModbus = 'Modbus TCP/IP Master'
$sWinTitleExpression = 'Edit General Expression'

$sFileText = FileRead($sRegisterFilePath)

$aFileLines = StringSplit($sFileText, @CR)

Local $aRegisters[$aFileLines[0] - 2][3]

For $x = 2 To $aFileLines[0]
	$aTemp = StringSplit($aFileLines[$x], ',')
	If Not IsArray($aTemp) Then ContinueLoop
	If $aTemp[0] <> 3 Then ContinueLoop
;~ 	_ArrayDisplay($aTemp)
;~ 	Exit
	$aRegisters[$x - 2][0] = StringReplace($aTemp[1], @LF, '')
	$aRegisters[$x - 2][1] = StringReplace($aTemp[2], @LF, '')
	$aRegisters[$x - 2][2] = StringReplace($aTemp[3], @LF, '')

Next
;~ _ArrayDisplay($aRegisters)

$sPreviousInch = 1
Local $aNamesInInch[1]

For $x = 0 To UBound($aRegisters) - 1
	$sRegister = $aRegisters[$x][0]
	$sTagName = 'RejectCount_' & $aRegisters[$x][1] & 'mm'
	$sInch = $aRegisters[$x][2]

	If $sInch <> $sPreviousInch Then
		$sTemp = ''
		For $y = 1 To $aNamesInInch[0]
			$sTemp &= $aNamesInInch[$y] & '+'
		Next
		$sTemp = StringTrimRight($sTemp, 1)
		_AddTag('Calc', 'RejectCount_' & $sPreviousInch & 'Inch', '', $sTemp)

		Local $aNamesInInch[1]
;~ _ArrayDisplay($aSheet)
;~ 		Exit
	EndIf

	$aNamesInInch[0] = _ArrayAdd($aNamesInInch, $sTagName)

	_AddTag('Data', $sTagName, $sRegister)
	If $x = UBound($aRegisters) - 1 Then
		$sTemp = ''
		For $y = 1 To $aNamesInInch[0]
			$sTemp &= $aNamesInInch[$y] & '+'
		Next
		$sTemp = StringTrimRight($sTemp, 1)
		_AddTag('Calc', 'RejectCount_' & $sInch & 'Inch', '', $sTemp)

		Local $aNamesInInch[1]
	EndIf

	$sPreviousInch = $sInch
Next

_Excel_RangeWrite($oWorkbook, $sSheetName, $aSheet)


Func _AddTag($sType, $sName, $sRegister = '', $sExpression = '')

;~ 	_ArrayDisplay($aSheet)
	If $sType = 'Calc' Then
		$aTemp = _ArrayExtract($aSheet, 3, 3)
		$aTemp[0][1] = $sExpression
	ElseIf $sType = 'Data' Then
		$aTemp = _ArrayExtract($aSheet, 4, 4)
;~ 	_ArrayDisplay($aTemp)
		$aTemp[0][1] = StringReplace($aTemp[0][1], '400066', $sRegister)
	Else
		MsgBox(0, '', 'Type Error')
		Exit
	EndIf

	$aTemp[0][0] = $sName
;~ 	_ArrayDisplay($aTemp)

	_ArrayAdd($aSheet, $aTemp)





EndFunc   ;==>_AddTag

Func _Exit()
	Exit
EndFunc   ;==>_Exit
