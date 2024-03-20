#include <array.au3>
#include <file.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


$sRSLogixPath = 'C:\Program Files (x86)\Rockwell Software\RSLogix 500 English\Rs500.exe'
$sFileDir = 'x:\Raul Barrios - Simplot\2021_Caldwell_Rovers\Rover_PLC_Changes\20210810\Compare'

$sMasterSearch = 'ROVER33'

$aFilePaths = _FileListToArray($sFileDir, '*.rss', $FLTA_FILES, True)
$aFileNames = _FileListToArray($sFileDir, '*.rss', $FLTA_FILES, False)
;~ _ArrayDisplay($aFileNames)

For $x = 1 To $aFileNames[0]
	If StringInStr($aFileNames[$x], $sMasterSearch) Then
		$sMasterPath = $aFilePaths[$x]
		$sMasterName = $aFileNames[$x]
		$aFilePaths[0] = _ArrayDelete($aFilePaths, $x) - 1
		$aFileNames[0] = _ArrayDelete($aFileNames, $x) - 1
		ExitLoop
	EndIf
Next

;~ _ArrayDisplay($aFileNames)

$sWinName = 'RSLogix 500'
$sWinNameCmpr = 'Compare Projects'
$sWinNameCmprOpt = 'Compare Options'


For $x = 1 To $aFilePaths[0]
	ShellExecute($sRSLogixPath)

	WinWait($sWinName)

	ControlSend($sWinName, '', '', '!{t}{c}')

	WinWait($sWinNameCmpr)

	ControlSend($sWinNameCmpr, '', '', $sMasterPath)
	ControlSend($sWinNameCmpr, '', '', '{tab}')
	ControlSend($sWinNameCmpr, '', '', '{tab}')
	ControlSend($sWinNameCmpr, '', '', '{tab}')

	ControlSend($sWinNameCmpr, '', '', $aFilePaths[$x])
	ControlSend($sWinNameCmpr, '', '', '{enter}')

	WinWait($sWinNameCmprOpt)
	ControlSend($sWinNameCmprOpt, '', '', '{enter}')
	ExitLoop
Next
