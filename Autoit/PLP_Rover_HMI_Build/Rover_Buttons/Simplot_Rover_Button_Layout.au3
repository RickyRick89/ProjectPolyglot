#include <array.au3>
#include <Excel.au3>
#include <File.au3>

$sGridTemplate = FileRead("C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Rover_Buttons\Rover_Button_Template.xml")

$sRootPath = 'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\PLP_Rover_HMI_Build\Rover_Buttons\'
$sNewFileSub = 'rover_map_'


Global $iGridIncX = 155
Global $iGridIncY = 65
Global $iGridOffsetX = 900
Global $iGridOffsetY = 400
Global $iColumns = 7



Global $sNewRoverButtons

$iInc = 1

For $x = 1 To 30
	If $x >= 19 And $x <= 28 Then ContinueLoop
	_RoverButton($iInc, StringFormat('%02d', $x))
	$iInc += 1
Next


_FileCreate($sRootPath & $sNewFileSub & 'NewRoverButtons.xml')

FileWrite($sRootPath & $sNewFileSub & 'NewRoverButtons.xml', $sNewRoverButtons)





Func _RoverButton($iInc, $vVariable)
	$sTemp = $sGridTemplate
	$iInc = $iInc - 1

	$iLeft = ((Mod($iInc, $iColumns)) * $iGridIncX) + $iGridOffsetX
	$iTop = (Floor($iInc / $iColumns) * $iGridIncY) + $iGridOffsetY

	$iLeft2 = $iLeft + 5
	$iLeft3 = $iLeft + 70
	$iLeft4 = $iLeft + 5
	$iLeft5 = $iLeft + 137
	$iLeft6 = $iLeft + 135

	$iTop4 = $iTop + 25
	$iTop5 = $iTop + 19



	$sTemp = StringReplace($sTemp, '[Index]', $vVariable)
	$sTemp = StringReplace($sTemp, '[Label]', $vVariable)
	$sTemp = StringReplace($sTemp, '[Left]', $iLeft)
	$sTemp = StringReplace($sTemp, '[Left2]', $iLeft2)
	$sTemp = StringReplace($sTemp, '[Left3]', $iLeft3)
	$sTemp = StringReplace($sTemp, '[Left4]', $iLeft4)
	$sTemp = StringReplace($sTemp, '[Left5]', $iLeft5)
	$sTemp = StringReplace($sTemp, '[Left6]', $iLeft6)
	$sTemp = StringReplace($sTemp, '[Top]', $iTop)
	$sTemp = StringReplace($sTemp, '[Top4]', $iTop4)
	$sTemp = StringReplace($sTemp, '[Top5]', $iTop5)
	$sNewRoverButtons &= @CRLF & $sTemp
EndFunc   ;==>_RoverButton
