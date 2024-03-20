#include <File.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

; Specify the directory to start the search
Local $sStartDir = 'Y:\School\ECE 530 - Digital Hardware Design\Activities\03\Soda_Machine'
; Specify the destination directory
Local $sDestDir = $sStartDir & "\Code"

ConsoleWrite("Starting the script..." & @CRLF)
ConsoleWrite("Source Directory: " & $sStartDir & @CRLF)
ConsoleWrite("Destination Directory: " & $sDestDir & @CRLF)

; Create the destination directory if it doesn't exist
If Not FileExists($sDestDir) Then
	DirCreate($sDestDir)
	ConsoleWrite("Destination directory created." & @CRLF)
EndIf

; Call the recursive function to find and move files
_FindAndMoveFiles($sStartDir, $sDestDir)

Func _FindAndMoveFiles($sDir, $sDestDir)
	ConsoleWrite("Searching in directory: " & $sDir & @CRLF)

	$aFiles = _FileListToArray($sDir, '*.bit', $FLTA_FILES)
	$aFolders = _FileListToArray($sDir, '*', $FLTA_FOLDERS)

	If IsArray($aFiles) Then
		ConsoleWrite("Found " & $aFiles[0] & " .bit files in directory: " & $sDir & @CRLF)
		For $x = 1 To $aFiles[0]
			FileCopy($sDir & '\' & $aFiles[$x], $sDestDir & '\' & $aFiles[$x], 9)
			ConsoleWrite("Copied file: " & $sDir & '\' & $aFiles[$x] & " to " & $sDestDir & '\' & $aFiles[$x] & @CRLF)
		Next
	EndIf

	If IsArray($aFolders) Then
		ConsoleWrite("Found " & $aFolders[0] & " folders in directory: " & $sDir & @CRLF)
		For $x = 1 To $aFolders[0]
			If $aFolders[$x] <> "." And $aFolders[$x] <> ".." Then
				_FindAndMoveFiles($sDir & '\' & $aFolders[$x], $sDestDir)
			EndIf
		Next
	EndIf

EndFunc   ;==>_FindAndMoveFiles

ConsoleWrite("Script execution completed." & @CRLF)
