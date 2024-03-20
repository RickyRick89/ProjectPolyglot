#include <array.au3>
#include <file.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


$sRSLogixPath = 'C:\Program Files (x86)\Rockwell Software\RSLogix 500 English\Rs500.exe'
$sFileDir = 'X:\Raul Barrios - Simplot\2021_Caldwell_Rovers\Rover_PLC_Changes\20210810\Compare'

$sMasterSearch = 'ROVER33'

$aFilePaths = _FileListToArray($sFileDir, '*.rss', $FLTA_FILES, True)
$aFileNames = _FileListToArray($sFileDir, '*.rss', $FLTA_FILES, False)
;~ _ArrayDisplay($aFileNames)

;~ _ArrayDisplay($aFileNames)

$sWinName = 'RSLogix 500'
$sWinNameExport = 'Documentation Database ASCII Export'
$sWinNameDest = 'Select Export Destination Directory'
$sWinNameResults = 'Export Results'


For $x = 1 To $aFilePaths[0]
	ShellExecute($aFilePaths[$x])

	WinWait($sWinName)

	ControlSend($sWinName, '', '', '!{t}{d}{e}')
	WinWait($sWinNameExport)
	For $y = 1 To 14
		ControlSend($sWinNameExport, '', '', '{tab}')
	Next
	ControlSend($sWinNameExport, '', '', '{right}')
	ControlSend($sWinNameExport, '', '', '{enter}')

	WinWait($sWinNameDest)
	ControlSend($sWinNameDest, '', '', '{enter}')

	WinWait($sWinNameResults)
	ControlSend($sWinNameResults, '', '', '{enter}')
	WinKill($sWinName)
Next
