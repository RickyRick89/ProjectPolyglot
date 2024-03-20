#include <Array.au3>
#include <File.au3>


$sSearchText1 = 'Rover31'
$sSearchText2 = 'R31'
$sSearchText3 = 'vRoverIndex := 31'
;~ $sSearchText4 = '[31]'
$sSearchText5 = '1031'
$sSearchText6 = 'RoverMessage31'

$sPath = "C:\Users\rgrov\Downloads\Exports\Rover31.L5X"

$sText = FileRead($sPath)
;~ MsgBox(0, '', $sText)

For $x = 1 To 31
	If $x = 31 Then ContinueLoop
	$sIndex = StringFormat("%02i", $x)

	$sReplaceText1 = 'Rover' & $sIndex
	$sReplaceText2 = 'R' & $sIndex
	$sReplaceText3 = 'vRoverIndex := ' & $x
	$sReplaceText4 = '[' & $x & ']'
	$sReplaceText5 = '10' & $sIndex
	$sReplaceText6 = 'RoverMessage' & $sIndex

	$sNewPath = StringReplace($sPath, $sSearchText1, $sReplaceText1)
	$sNewText = StringReplace($sText, $sSearchText1, $sReplaceText1)
	$sNewText = StringReplace($sNewText, $sSearchText2, $sReplaceText2)
	$sNewText = StringReplace($sNewText, $sSearchText3, $sReplaceText3)
;~ 	$sNewText = StringReplace($sNewText, $sSearchText4, $sReplaceText4)
	$sNewText = StringReplace($sNewText, $sSearchText5, $sReplaceText5)
	$sNewText = StringReplace($sNewText, $sSearchText6, $sReplaceText6)
	_FileCreate($sNewPath)
	FileWrite($sNewPath, $sNewText)
Next
