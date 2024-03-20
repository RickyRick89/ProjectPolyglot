#include <Array.au3>
#include <File.au3>

Local $aFile[1], $aResults[1][5], $aNames[1]
$sFilePath = "Y:\My_Scripts\ML_L1&2\Comms\MOLA_L01_CLX_20230331_RBG.L5X"

$aResults[0][0] = 'Module'
$aResults[0][1] = 'Catalog Number'
$aResults[0][2] = 'IP'
$aResults[0][3] = 'Text'
$aResults[0][4] = 'Tag Desc'

$aNames[0] = 'Name Array Text'

_FileReadToArray($sFilePath, $aFile)

$bModuleFound = 0

For $x = 1 To UBound($aFile) - 1
	If StringInStr($aFile[$x], '<Module Name="') Then
		$bModuleFound = 1
		$sSearch = 'Name="'
		$iStart = StringInStr($aFile[$x], $sSearch) + StringLen($sSearch) - 1
		$iEnd = StringInStr($aFile[$x], '"', 0, 1, $iStart + 1) - 1
		$sName = StringTrimLeft(StringLeft($aFile[$x], $iEnd), $iStart)

		$sSearch = 'CatalogNumber="'
		$iStart = StringInStr($aFile[$x], $sSearch) + StringLen($sSearch) - 1
		$iEnd = StringInStr($aFile[$x], '"', 0, 1, $iStart + 1) - 1
		$sCatNum = StringTrimLeft(StringLeft($aFile[$x], $iEnd), $iStart)

		$sIP = ''
	ElseIf StringInStr($aFile[$x], '" Type="Ethernet"') And $bModuleFound = 1 Then
		$bModuleFound = 0
		$sSearch = 'Address="'
		$iStart = StringInStr($aFile[$x], $sSearch) + StringLen($sSearch) - 1
		$iEnd = StringInStr($aFile[$x], '"', 0, 1, $iStart + 1) - 1
		$sIP = StringTrimLeft(StringLeft($aFile[$x], $iEnd), $iStart)
		$aIP = StringSplit($sIP, '.')
		If IsArray($aIP) Then
			If $aIP[0] = 4 Then
				$sText = $aIP[4] & ": GSV(Module," & $sName & ",EntryStatus,ENET_ModuleSts); Module_Status_BTDT.Source := ENET_ModuleSts; BTDT(Module_Status_BTDT); MOLA_L01_IO_ModuleName := '" & $sName & "';"
				$sNameText = "MOLA_L01_IO_ModuleNames[" & $aIP[4] & "] := '" & $sName & "';"
				Local $aTemp[1][5] = [[$sName, $sCatNum, $sIP, $sText, 'MOLA_L01_IO_' & @TAB & $sName & @TAB & @TAB & 'MOLA_L01_IO_.IP[' & $aIP[4] & ']' & @TAB & @TAB & 'MOLA_L01_IO_' & @TAB & $sName & ' - ' & $sCatNum & ' Ethernet/IP $NIP: ' & $sIP & @TAB & @TAB & 'MOLA_L01_IO_.IP[' & $aIP[4] & '].0']]
				_ArrayAdd($aResults, $aTemp)
			Else
				$sText = ''
				$sNameText = ''
			EndIf
		Else
			$sText = ''
			$sNameText = ''
		EndIf

		_ArrayAdd($aNames, $sNameText)




		ConsoleWrite(@CRLF & '--> ' & $sName & ' - ' & $sIP)
	EndIf
Next

_ArrayToClip($aNames, @CRLF)
_ArrayDisplay($aNames)

_ArrayToClip($aResults, @TAB)
_ArrayDisplay($aResults)
