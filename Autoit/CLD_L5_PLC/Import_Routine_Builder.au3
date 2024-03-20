#include <Excel.au3>
#include <ExcelConstants.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sWinTitle = 'Access - '

Global $sPIDUnitPath = "C:\Users\rgrov\OneDrive - Triplex Automation LLC\My_Docs\My_Projects\Simplot-Line5\My_Work\PID_Drawings.xlsx"
Global $sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Motor And Instrument List Rev 0.5.xlsx"
$sTemplateRoot = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\CLD_L5_PLC\Templates\'

$sMotorSheetName = 'Motor List'
$sInstrumentSheetName = 'Instrument List'

$aTemplateFiles = _FileListToArray($sTemplateRoot, '*.L5X', Default, True)
$aTemplateNames = _FileListToArray($sTemplateRoot, '*.L5X', Default, False)

$oWorkbook = _Excel_BookAttach($sPIDUnitPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sPIDUnitPath)
Else
	$oExcel = $oWorkbook.Application
EndIf
$aPIDList = _Excel_RangeRead($oWorkbook)


$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf
$aMotorList = _Excel_RangeRead($oWorkbook, $sMotorSheetName)
$aInstrumentList = _Excel_RangeRead($oWorkbook, $sInstrumentSheetName)


For $iRow = 1 To UBound($aInstrumentList) - 1
	$sID = $aInstrumentList[$iRow][2]
	$sDesc = $aInstrumentList[$iRow][6]
	$sConn = $aInstrumentList[$iRow][7]
	$sSig = $aInstrumentList[$iRow][8]
	$sPID = $aInstrumentList[$iRow][19]

	Switch $sSig
		Case 'DI'
			$sUseTemplate = 'Template_DIN.L5X'
		Case 'AS-I'
			$sUseTemplate = 'Template_V2S.L5X'
		Case 'AI'
			$sUseTemplate = 'Template_AIN.L5X'
		Case 'DO'
			$sUseTemplate = 'Template_DOUT.L5X'
		Case 'OEM Provided'
			ContinueLoop
		Case 'Load Cell'
			ContinueLoop
		Case 'Ethernet'
			$sUseTemplate = 'Template_AIN.L5X'
		Case 'AI/24VDC'
			$sUseTemplate = 'Template_AIN.L5X'
		Case 'AI/AO'
			$sUseTemplate = 'Template_AOUT.L5X'
		Case 'AI(RTD)'
			$sUseTemplate = 'Template_AIN.L5X'
		Case '?'
			ContinueLoop
		Case 'RTD'
			$sUseTemplate = 'Template_AIN.L5X'
	EndSwitch

;~ '[Instrument_ID]'
;~ '[Instrument_Description]'
;~ '[Instrument_Tag_Description]'
;~ '[Routine_Name]'
;~ '[Unit]'
;~ '[Line]'
;~ '[Area]'

Next


; #FUNCTION# ====================================================================================================================
; Name ..........: _Exit
; Description ...:
; Syntax ........: _Exit()
; Parameters ....: None
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Exit()
	Exit
EndFunc   ;==>_Exit





