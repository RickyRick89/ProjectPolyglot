#include <Array.au3>
#include <File.au3>

$sDir = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\School\ECE 530 - Digital Hardware Design\Activities\Sources'
$sFileExt = '.v'

$aFiles = _FileListToArray($sDir, '*' & $sFileExt, 1, True)

$sFileConcat = ''
For $x = 1 To $aFiles[0]
	$sFileConcat &= FileRead($aFiles[$x])
Next
_FileCreate($sDir & '/AllFiles' & $sFileExt)
FileWrite($sDir & '/AllFiles' & $sFileExt, $sFileConcat)

