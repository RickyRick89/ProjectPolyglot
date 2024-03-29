#include <Array.au3>
#include <File.au3>


$sSearchText1 = '_0_'
$sSearchText2 = '[0]'

$sPath = "C:\Users\rgrov\Downloads\Update\CaseRecord_0_.xml"
$sBeginning = '<Tags MinVersion="8.0.0" locale="en_US">'
$sEnding = '</Tags>'

$sText = FileRead($sPath)
;~ MsgBox(0, '', $sText)
$sNewTextAll=$sBeginning

For $x = 2000 To 3000
	If $x = 31 Then ContinueLoop
	$sIndex = $x;StringFormat("%02i", $x)

	$sReplaceText1 = '_' & $sIndex&'_'
	$sReplaceText2 = '[' & $sIndex&']'

	$sNewPath = StringReplace($sPath, $sSearchText1, $sReplaceText1)

	$sNewText = StringReplace($sText, $sSearchText1, $sReplaceText1)
	$sNewText = StringReplace($sNewText, $sSearchText2, $sReplaceText2)
	$sNewText = StringReplace($sNewText,$sBeginning,'')
	$sNewText = StringTrimRight($sNewText,7)

	$sNewTextAll &= $sNewText
;~ 	_FileCreate($sNewPath)
;~ 	FileWrite($sNewPath, $sNewText)
Next
$sNewTextAll &= $sEnding
	ClipPut($sNewTextAll)