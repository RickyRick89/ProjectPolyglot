#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>
#include <Date.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')
HotKeySet('{`}', '_UpdateName')


$sPIDPath = "Y:\My_Scripts\PID_CHECK\2022-05-18 Line 5 PIDs.pdf"
$sWinTitlePID = '2022-05-18 Line 5 PIDs.pdf'

Global $sGroupName, $bUpdateComplete

$sTemplatePath = 'X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sMIWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_M&I.xlsx"
;~ $sMISheetName = 'Motors'
$sMISheetName = 'Instruments'
$sCLXTagNameWorkbookPath = "X:\2021_Caldwell_L5_Fry\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\My_Tag_Generator.xlsm"
$sCLXTagNameSheetName = 'Tags'

ShellExecute($sPIDPath)
WinWait($sWinTitlePID)
WinActivate($sWinTitlePID)
ControlSend($sWinTitlePID, '', '', '{alt}')
Sleep(100)
ControlSend($sWinTitlePID, '', '', '{k}{1}')
Sleep(100)
ControlSend($sWinTitlePID, '', '', '{b}')
Sleep(1000)

$sIniPath = @ScriptDir & '\UpdatedList.ini'
;~ _FileCreate($sIniPath)


$oMIWorkbook = _Excel_BookAttach($sMIWorkbookPath)
If Not IsObj($oMIWorkbook) Then
	$oExcel = _Excel_Open()
	$oMIWorkbook = _Excel_BookOpen($oExcel, $sMIWorkbookPath)
Else
	$oExcel = $oMIWorkbook.Application
EndIf

$aMISheet = _Excel_RangeRead($oMIWorkbook, $sMISheetName)

$oTagWorkbook = _Excel_BookAttach($sCLXTagNameWorkbookPath)
If Not IsObj($oTagWorkbook) Then
	$oExcel = _Excel_Open()
	$oTagWorkbook = _Excel_BookOpen($oExcel, $sCLXTagNameWorkbookPath)
Else
	$oExcel = $oTagWorkbook.Application
EndIf

$aTagSheet = _Excel_RangeRead($oTagWorkbook, $sCLXTagNameSheetName, Default, 1, True)

;~ _ArrayDisplay($aMISheet)
;~ _ArrayDisplay($aTagSheet)

For $x = UBound($aMISheet) - 1 To 1 Step -1
	If $aMISheet[$x][1] = '' Then
		ReDim $aMISheet[UBound($aMISheet) - 1][UBound($aMISheet, 2)]
	EndIf
Next

For $iRow = 1 To UBound($aMISheet) - 1
	ConsoleWrite(@CRLF & '-->' & $iRow & '/' & UBound($aMISheet) - 1)

	If $sMISheetName = 'Motors' Then
		$sName = StringReplace($aMISheet[$iRow][0], '-', '')
		$sDesc = $aMISheet[$iRow][3]
		$sUnit = $aMISheet[$iRow][4]
		$sLine = $aMISheet[$iRow][5]
		$sArea = $aMISheet[$iRow][6]
		$sType = $aMISheet[$iRow][11]
	ElseIf $sMISheetName = 'Instruments' Then
		$sName = StringReplace($aMISheet[$iRow][0], '-', '')
		$sDesc = $aMISheet[$iRow][4]
		$sUnit = $aMISheet[$iRow][8]
		$sLine = $aMISheet[$iRow][9]
		$sArea = $aMISheet[$iRow][10]
		$sType = $aMISheet[$iRow][7]
	EndIf
	$iTagIndex = _ArraySearch($aTagSheet, $sName, 0, 0, 0, 0, 1, 6)
	If $iTagIndex < 0 Then
		MsgBox(0, '', 'Device not found on TagList: ' & $sName)
		ContinueLoop
;~ 		Exit
	EndIf

	$sCLXTagName = $aTagSheet[$iTagIndex][11]

;~ 	If $sUnit = $sUnitSearch Then
	ConsoleWrite(@CRLF & '-->' & $sCLXTagName)
	$sGroupName = 'grp' & $sName

	If IniRead($sIniPath, $sGroupName, 'UpdateTime', '') <> '' Then
		ConsoleWrite(@CRLF & '++++> Already Updated')
		ContinueLoop
	EndIf

	ControlSetText($sWinTitlePID, '', '[CLASS:Edit; INSTANCE:2]', StringReplace($aMISheet[$iRow][0], '-', ' '))
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:16]')
	Sleep(2500)
	$sResults = ControlGetText($sWinTitlePID, '', '[CLASS:Static; INSTANCE:11]')
	If $sResults = '0 document(s) with 0 instance(s)' Then
		$bFound = 0
	Else
		$bFound = 1
	EndIf
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:17]')
	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Static; INSTANCE:16]')
	Sleep(100)
	ControlClick($sWinTitlePID, '', '[CLASS:Button; INSTANCE:18]')
	Sleep(100)


	While 1
		If $bUpdateComplete Then
			$bUpdateComplete = False
			IniWriteSection($sIniPath, $sGroupName, 'UpdateTime='&_now())
;~ 			IniWrite($sIniPath, $sGroupName, 'UpdateTime', _Now())
			ExitLoop
		EndIf
		Sleep(100)
	WEnd
;~ 	ControlSend('Global Object Parameter Values', '', '[CLASS:GXWND; INSTANCE:1]', '{tab}{space}')
;~ 	Sleep(100)
;~ 	ControlSetText('Global Object Parameter Values', '', '[CLASS:GXEDIT; INSTANCE:1]', '')
;~ 	ControlSend('Global Object Parameter Values', '', '[CLASS:GXEDIT; INSTANCE:1]', '{[MyCLX]' & $sCLXTagName & '}', 1)
;~ 	ControlClick('Global Object Parameter Values', '', '[CLASS:Button; INSTANCE:1]')
;~ 	EndIf
	Sleep(100)
Next


Func _UpdateName()

	$sWinTitle = 'FactoryTalk View Studio - '

	$sCntrlItemName = '[CLASS:Button; INSTANCE:18]'
	$sCntrlListBox = '[CLASS:ListBox; INSTANCE:1]'


	WinActivate($sWinTitle)
	ControlSend($sWinTitle, '', $sCntrlListBox, '{Home}')
	$iIteration = 0
	While ControlGetText($sWinTitle, '', $sCntrlItemName) <> 'Name:'
		ControlSend($sWinTitle, '', $sCntrlListBox, '{Down}')
		If $iIteration = 100 Then ExitLoop
		$iIteration += 1
	WEnd
	Sleep(250)
	ControlSend($sWinTitle, '', $sCntrlListBox, '{enter}')
	Sleep(250)
	ControlSend($sWinTitle, '', $sCntrlListBox, $sGroupName)
	Sleep(250)
	ControlSend($sWinTitle, '', $sCntrlListBox, '{enter}')
	$bUpdateComplete = True
EndFunc   ;==>_UpdateName


Func _Exit()
	Exit
EndFunc   ;==>_Exit

