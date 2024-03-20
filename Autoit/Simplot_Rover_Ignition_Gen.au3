#include <Array.au3>
#include <File.au3>


$sSearchText1 = 'Rover21'
$sSearchText2 = 'R21'
$sSearchText3 = 'vRoverIndex := 21'
$sSearchText4 = '.RoverID := 1000 + 21'
$sSearchText5 = '[21]'
$sSearchText6 = 'RoverMessage21'
$sSearchText7 = '.Owner := 21'
$sPath = "C:\Users\Triplex\Downloads\Exports\Ignition\Rover21_Data.xml"

$sText = FileRead($sPath)
;~ MsgBox(0, '', $sText)

For $x = 1 To 50
	If $x = 22 Then ContinueLoop
	$sIndex = StringFormat("%02i", $x)

	$sReplaceText1 = 'Rover' & $sIndex
	$sReplaceText2 = 'R' & $sIndex
	$sReplaceText3 = 'vRoverIndex := ' & $x
	$sReplaceText4 = '.RoverID := 1000 + ' & $x
	$sReplaceText5 = '[' & $x & ']'
	$sReplaceText6 = 'RoverMessage' & $sIndex
	$sReplaceText7 = '.Owner := ' & $x

	$sNewPath = StringReplace($sPath, $sSearchText1, $sReplaceText1)
	$sNewText = StringReplace($sText, $sSearchText1, $sReplaceText1)
	$sNewText = StringReplace($sNewText, $sSearchText2, $sReplaceText2)
	$sNewText = StringReplace($sNewText, $sSearchText3, $sReplaceText3)
	$sNewText = StringReplace($sNewText, $sSearchText4, $sReplaceText4)
	$sNewText = StringReplace($sNewText, $sSearchText5, $sReplaceText5)
	$sNewText = StringReplace($sNewText, $sSearchText6, $sReplaceText6)
	$sNewText = StringReplace($sNewText, $sSearchText7, $sReplaceText7)
	_FileCreate($sNewPath)
	FileWrite($sNewPath, $sNewText)
Next
