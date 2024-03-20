#include <Array.au3>
#include <File.au3>


$sSearchText1 = 'Rover33'
$sSearchText2 = 'R33'
$sSearchText3 = 'vRoverIndex := 33'
$sSearchText4 = '1033'
$sSearchText5 = '[33]'
$sSearchText6 = 'RoverMessage33'

$sPath = "C:\Users\Triplex\Downloads\Exports\Rover33_Ctrl.L5X"

$sText = FileRead($sPath)
;~ MsgBox(0, '', $sText)

For $x = 15 To 37
	If $x = 33 Then ContinueLoop
	$sIndex = StringFormat("%02i", $x)

	$sReplaceText1 = 'Rover' & $sIndex
	$sReplaceText2 = 'R' & $sIndex
	$sReplaceText3 = 'vRoverIndex := ' & $x
	$sReplaceText4 = '10' & $sIndex
	$sReplaceText5 = '[' & $sIndex&']'
	$sReplaceText6 = 'RoverMessage' & $sIndex

	$sNewPath = StringReplace($sPath, $sSearchText1, $sReplaceText1)
	$sNewText = StringReplace($sText, $sSearchText1, $sReplaceText1)
	$sNewText = StringReplace($sNewText, $sSearchText2, $sReplaceText2)
	$sNewText = StringReplace($sNewText, $sSearchText3, $sReplaceText3)
	$sNewText = StringReplace($sNewText, $sSearchText4, $sReplaceText4)
	$sNewText = StringReplace($sNewText, $sSearchText5, $sReplaceText5)
	$sNewText = StringReplace($sNewText, $sSearchText6, $sReplaceText6)
	_FileCreate($sNewPath)
	FileWrite($sNewPath, $sNewText)
Next
