#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <String.au3>

;[INST_NAME],[DESCRIPTION],[JB_NAME],[NODE_NUM],[INPUT_NUM],[OUTPUT_NUM],[ASM_NAME],[TRUNK_NUM]

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Global $sLastSelected = 'CLXL4B_ASI01_JB01'
Global $aOptions[1] = [$sLastSelected]
Global $iSheetXInc = 31.9038

Global $sFirstPageTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\First_Page.scr"
Global $sPLCPanelTemplatePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\PLC_Panel.scr"

Global $sNewFilePath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Sandbox\New_File.dwg"
Global $sFirstScriptPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\First_Page.scr"
Global $sRemotePanelPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\Remote_Panel.scr"
Global $sTempPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Templates\Temp.scr"

$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Motor And Instrument List Rev 1.xlsx"



$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf

$aSheet = _Excel_RangeRead($oWorkbook, 'ASi')
$aNodes = $aSheet
For $iCol = 0 To UBound($aNodes, 2) - 1
	If $aNodes[0][$iCol] <> '' Then
		ContinueLoop
	Else
		ReDim $aNodes[UBound($aNodes)][$iCol]
		ExitLoop
	EndIf
Next

$aIO = $aSheet
For $iCol = UBound($aIO, 2) - 1 To 0 Step -1
	If $aIO[0][$iCol] <> '' Then
		ContinueLoop
	Else
		For $iCol2 = $iCol To 0 Step -1
			_ArrayColDelete($aIO, $iCol2)
		Next
		ExitLoop
	EndIf
Next


$aSheet = _Excel_RangeRead($oWorkbook, 'Panels')
_ArrayColDelete($aSheet, 0)
_ArrayColDelete($aSheet, 0)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
_ArrayColDelete($aSheet, UBound($aSheet, 2) - 1)
$aMasters = $aSheet
For $iCol = 0 To UBound($aMasters, 2) - 1
	If $aMasters[0][$iCol] <> '' Then
		ContinueLoop
	Else
		ReDim $aMasters[UBound($aMasters)][$iCol]
		ExitLoop
	EndIf
Next

$aModules = $aSheet
For $iCol = UBound($aModules, 2) - 1 To 0 Step -1
	If $aModules[0][$iCol] <> '' Then
		ContinueLoop
	Else
		For $iCol2 = $iCol To 0 Step -1
			_ArrayColDelete($aModules, $iCol2)
		Next
		ExitLoop
	EndIf
Next


For $iRow = UBound($aNodes) - 1 To 0 Step -1
	If $aNodes[$iRow][0] = '' Then
		_ArrayDelete($aNodes, $iRow)
	EndIf
Next
For $iRow = UBound($aIO) - 1 To 0 Step -1
	If $aIO[$iRow][0] = '' Then
		_ArrayDelete($aIO, $iRow)
	EndIf
Next
For $iRow = UBound($aMasters) - 1 To 0 Step -1
	If $aMasters[$iRow][0] = '' Then
		_ArrayDelete($aMasters, $iRow)
	EndIf
Next
For $iRow = UBound($aModules) - 1 To 0 Step -1
	If $aModules[$iRow][0] = '' Then
		_ArrayDelete($aModules, $iRow)
	EndIf
Next


;~ _ArrayDisplay($aNodes)
;~ _ArrayDisplay($aIO)
;~ _ArrayDisplay($aMasters)
;~ _ArrayDisplay($aModules)


;~ _ArrayDisplay($aSheet)
;~ Exit

If WinExists('AutoCAD 2024') Then
	MsgBox(0, '', 'Close AutoCAD 2024')
EndIf

Run('"C:\Program Files\Autodesk\AutoCAD 2024\acad.exe" "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\GFK_L4\Drawings\Sandbox.dwg" /b "' & $sFirstScriptPath & '"')

_CheckFileDate()

$iMasterInc = 1
For $iRow = 1 To UBound($aMasters) - 1
	$sPanel = $aMasters[$iRow][0]
	For $iCol = 1 To UBound($aMasters, 2) - 1
		$sMaster = $aMasters[$iRow][$iCol]

		If $sMaster = '' Then ContinueLoop

		WinActivate('AutoCAD 2024')
		ControlSend('AutoCAD 2024', '', '', 'script{enter}')

		$sTempText = FileRead($sRemotePanelPath)
		$sNewText = StringReplace($sTempText, '[X]', $iSheetXInc * $iMasterInc)
		_FileCreate($sTempPath)
		FileWrite($sTempPath, $sNewText)

		WinWait('Select Script File')
		ControlSend('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', @DesktopCommonDir)
		ControlSetText('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', @DesktopCommonDir)
		ControlClick('Select Script File', '', '[CLASS:Button; INSTANCE:7]')
		ControlSetText('Select Script File', '', '[CLASS:Edit; INSTANCE:1]', $sTempPath)
		Sleep(250)
		ControlClick('Select Script File', '', '[CLASS:Button; INSTANCE:7]')

		$iMasterInc += 1
		_CheckFileDate()

		_OpenFile($sNewFilePath)
		_FindReplace('[PANEL_NAME]', $sPanel)
		_FindReplace('[ASM_NAME]', $sMaster)
		Exit
	Next
Next

Func _CheckFileDate()
	$sFileTime = FileGetTime($sNewFilePath, $FT_MODIFIED, $FT_STRING)
	$dtFileTime = _StringInsert(_StringInsert(_StringInsert(_StringInsert(_StringInsert($sFileTime, ' ', -6), ':', -4), ':', -2), '/', 6), '/', 4)
;~ ConsoleWrite("-> File Time: " & $dtFileTime & @CRLF)
	$iTimeDiff = _DateDiff('s', $dtFileTime, _NowCalc())
;~ ConsoleWrite("-> File Age: " & $iTimeDiff & " Seconds" & @CRLF)

	While $iTimeDiff > 2
		$sFileTime = FileGetTime($sNewFilePath, $FT_MODIFIED, $FT_STRING)
		$dtFileTime = _StringInsert(_StringInsert(_StringInsert(_StringInsert(_StringInsert($sFileTime, ' ', -6), ':', -4), ':', -2), '/', 6), '/', 4)
		$iTimeDiff = _DateDiff('s', $dtFileTime, _NowCalc())
		Sleep(100)
	WEnd
	Sleep(2000)
EndFunc   ;==>_CheckFileDate

Func _FindReplace($sFind, $sReplace)
	ConsoleWrite("_FindReplace(" & $sFind & ", " & $sReplace & ")" & @CRLF)
	WinKill('Autodesk AutoCAD 2024 - Help')
	WinWaitClose('Autodesk AutoCAD 2024 - Help')
	Sleep(1000)
	WinActivate('AutoCAD 2024')
	ControlSend('AutoCAD 2024', '', '', 'find{enter}')

	WinWait('Find and Replace', 'Find &what:')
	ControlSend('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', 'Temp')
	ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:1]', '[PANEL_NAME]')
	ControlSetText('Find and Replace', 'Find &what:', '[CLASS:Edit; INSTANCE:2]', 'New Text')
	ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:5]')
	WinWait('Find and Replace', 'The system has finished searching the drawing.')
	ControlClick('Find and Replace', 'The system has finished searching the drawing.', '[CLASS:Button; INSTANCE:1]')
	ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:7]')
EndFunc   ;==>_FindReplace

Func _OpenFile($sPath)
	ConsoleWrite("_OpenFile(" & $sPath & ")" & @CRLF)
	WinKill('Autodesk AutoCAD 2024 - Help')
	WinWaitClose('Autodesk AutoCAD 2024 - Help')
	Sleep(1000)
	WinActivate('AutoCAD 2024')
	ControlSend('AutoCAD 2024', '', '', 'open{enter}')

	WinWait('Select File')
	ControlSend('Select File', '', '[CLASS:Edit; INSTANCE:1]', 'Temp')
	ControlSetText('Select File', '', '[CLASS:Edit; INSTANCE:1]', $sPath)
	ControlClick('Find and Replace', 'Find &what:', '[CLASS:Button; INSTANCE:7]')
	Sleep(5000)

EndFunc   ;==>_OpenFile

Func _Exit()
	Exit
EndFunc   ;==>_Exit
