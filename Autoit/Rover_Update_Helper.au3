#include <Array.au3>
#include <File.au3>
#include <Date.au3>

$sRootPath = 'C:\Local_VM_Rover_Code'
$sFileNameStart = 'SIMPLOT_CALDWELL_ROVER'
$sLogPath = @ScriptDir & '\Log.ini'

For $iRover = 1 To 50
	$iRoverNumer = StringFormat('%02d', $iRover)
	$aFilePaths = _FileListToArray($sRootPath, $sFileNameStart & $iRoverNumer & '*', $FLTA_FILES, True)
	$aFiles = _FileListToArray($sRootPath, $sFileNameStart & $iRoverNumer & '*', $FLTA_FILES, False)
	If Not IsArray($aFilePaths) Then
		MsgBox(0, '', 'No File For Rover ' & $iRoverNumer)
		$aFilePaths = _FileListToArray($sRootPath, $sFileNameStart & $iRoverNumer & '*', $FLTA_FILES, True)
		$aFiles = _FileListToArray($sRootPath, $sFileNameStart & $iRoverNumer & '*', $FLTA_FILES, False)
		If Not IsArray($aFilePaths) Then Exit
	EndIf
	$sUpdated = IniRead($sLogPath, 'ROVER' & $iRoverNumer, 'Updated', '')
	If $sUpdated <> '' Then ContinueLoop


	$sWinName = 'RSLogix 500 Pro - ' & $aFiles[1]
	ShellExecute($aFilePaths[1])

	WinWait($sWinName)
	WinSetState($sWinName, '', @SW_MAXIMIZE)
	Sleep(250)
	ControlSend($sWinName, '', '', '!{w}{a}')
	WinWait('Arrange Windows')
	ControlSend('Arrange Windows', '', '', '{enter}')
	Sleep(250)
	ControlSend($sWinName, '', '', '!{c}{o}')
	If WinWait('Going to Online Programming State', '', 2) Then
		ControlSend('Going to Online Programming State', '', '', '{b}')
		WinWait('Look For SLC Source File')
		ControlSend('Look For SLC Source File', '', '[CLASS:ListBox; INSTANCE:2]', '{down}{up}{enter}')
		ControlSend('Look For SLC Source File', '', '[CLASS:ListBox; INSTANCE:2]', '{down}{down}{enter}{enter}')
		Sleep(250)
		ControlSend('Going to Online Programming State', '', '', '!{u}')
		Sleep(250)
		While WinExists('Uploading Processor Image')
			Sleep(100)
		WEnd
		Sleep(1000)
	EndIf
	If Not WinExists($sWinName) Then
		MsgBox(0, '', 'Different File Used')
		Exit

	EndIf

	$iResponse = MsgBox($MB_OKCANCEL, '', 'Click OK When Done')
	If $iResponse = $IDCANCEL Then
		ContinueLoop
	EndIf
	ControlSend($sWinName, '', '', '^{s}')
	WinWait('RSLogix 500 Pro', 'Warning! Data Table values may have changed', 1)
	ControlSend('RSLogix 500 Pro', 'Warning! Data Table values may have changed', '', '{enter}')
	Sleep(250)
	While WinExists('Uploading Processor Image')
		Sleep(100)
	WEnd

	IniWrite($sLogPath, 'ROVER' & $iRoverNumer, 'Updated', _Now())


Next


