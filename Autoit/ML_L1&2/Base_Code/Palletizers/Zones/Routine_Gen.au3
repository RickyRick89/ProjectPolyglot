#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

$sTemplatePath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sZoneWorkbookPath = "X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Pallet_Conv_Layout.xlsx"

_Routine_Generator('Zones')

Func _Routine_Generator($sZoneSheetName)

	$oZoneWorkbook = _Excel_BookAttach($sZoneWorkbookPath)
	If Not IsObj($oZoneWorkbook) Then
		$oExcel = _Excel_Open()
		$oZoneWorkbook = _Excel_BookOpen($oExcel, $sZoneWorkbookPath)
	Else
		$oExcel = $oZoneWorkbook.Application
	EndIf

	$aZoneSheet = _Excel_RangeRead($oZoneWorkbook, $sZoneSheetName)

;~ _ArrayDisplay($aZoneSheet)
;~ _ArrayDisplay($aTagSheet)

	For $iRow = UBound($aZoneSheet) - 1 To 0 Step -1
		For $iCol = 0 To UBound($aZoneSheet, 2) - 1
			$sCell = $aZoneSheet[$iRow][$iCol]
			If $sCell = '' Or Not StringInStr($sCell, 'Zone') Then ContinueLoop

			$sZone = _GetZone($sCell)
			ConsoleWrite('--->Zone = ' & $sZone & @CRLF)
			$sDirections = _GetDirections($sCell, $sZone)
			ConsoleWrite('--->Directions = ' & $sDirections & @CRLF)


			If $iCol = UBound($aZoneSheet, 2) - 1 Then
				If $iRow = UBound($aZoneSheet) - 1 Then
					$sFZone = 'PalletEmpty'
					$sBZone = _GetZone($aZoneSheet[$iRow][$iCol - 1])
					$sLZone = _GetZone($aZoneSheet[$iRow - 1][$iCol])
					$sRZone = 'PalletEmpty'
				Else
					$sFZone = _GetZone($aZoneSheet[$iRow - 1][$iCol])
					$sBZone = _GetZone($aZoneSheet[$iRow + 1][$iCol])
					$sLZone = _GetZone($aZoneSheet[$iRow][$iCol - 1])
					$sRZone = 'PalletEmpty'
				EndIf
			Else
				If $iRow = UBound($aZoneSheet) - 1 Then
					$sFZone = _GetZone($aZoneSheet[$iRow][$iCol + 1])
					$sBZone = _GetZone($aZoneSheet[$iRow][$iCol - 1])
					$sLZone = _GetZone($aZoneSheet[$iRow - 1][$iCol])
					$sRZone = 'PalletEmpty'
				Else
					$sFZone = _GetZone($aZoneSheet[$iRow - 1][$iCol])
					$sBZone = _GetZone($aZoneSheet[$iRow + 1][$iCol])
					$sLZone = _GetZone($aZoneSheet[$iRow][$iCol - 1])
					$sRZone = _GetZone($aZoneSheet[$iRow][$iCol + 1])
				EndIf
			EndIf
			If Not StringInStr($sFZone, 'Zone') Then
				$sFPallet = 'PalletEmpty'
			Else
				$iFEqNum = Number(StringReplace($sFZone, 'Zone', ''))
				$sFPallet = 'Pallet' & $iFEqNum
			EndIf
			If Not StringInStr($sBZone, 'Zone') Then
				$sBPallet = 'PalletEmpty'
			Else
				$iBEqNum = Number(StringReplace($sBZone, 'Zone', ''))
				$sBPallet = 'Pallet' & $iBEqNum
			EndIf
			If Not StringInStr($sLZone, 'Zone') Then
				$sLPallet = 'PalletEmpty'
			Else
				$iLEqNum = Number(StringReplace($sLZone, 'Zone', ''))
				$sLPallet = 'Pallet' & $iLEqNum
			EndIf
			If Not StringInStr($sRZone, 'Zone') Then
				$sRPallet = 'PalletEmpty'
			Else
				$iREqNum = Number(StringReplace($sRZone, 'Zone', ''))
				$sRPallet = 'Pallet' & $iREqNum
			EndIf

			$iEqNum = Number(StringReplace($sZone, 'Zone', ''))
			$sZoneID = Number(StringRight($iEqNum, 2))


			If $sDirections = 'FB' Then
				$sType = 'FBZone'
			Else
				$sType = 'AWZone'
			EndIf


			$sTemplate = FileRead($sTemplatePath & $sType & 'Tag.L5X')
			$sNewText = $sTemplate

			$sNewText = StringReplace($sNewText, 'TargetName="' & $sType & 'Tag' & '"', 'TargetName="' & $sZone & '"')
			$sNewText = StringReplace($sNewText, '<Routine Use="Target" Name="' & $sType & 'Tag' & '" Type="FBD">', '<Routine Use="Target" Name="' & $sZone & '" Type="FBD">')
			$sNewText = StringReplace($sNewText, $sType & 'MotorTag', 'EC' & $iEqNum)
			$sNewText = StringReplace($sNewText, $sType & 'ProxTag', 'ZS' & $iEqNum & 'A')
			$sNewText = StringReplace($sNewText, $sType & 'Tag', $sZone)
			$sNewText = StringReplace($sNewText, '1234567890', $sZoneID)
			$sNewText = StringReplace($sNewText, $sType & 'PalletTag', 'Pallet' & $iEqNum)
			$sNewText = StringReplace($sNewText, 'RPalletTag', $sRPallet)
			$sNewText = StringReplace($sNewText, 'LPalletTag', $sLPallet)
			$sNewText = StringReplace($sNewText, 'FPalletTag', $sFPallet)
			$sNewText = StringReplace($sNewText, 'BPalletTag', $sBPallet)

			_FileCreate('X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Zones\' & $sZone & '.L5X')
			FileWrite('X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Imports\Zones\' & $sZone & '.L5X', $sNewText)

		Next
	Next
EndFunc   ;==>_Routine_Generator

Func _GetZone($sCell)
	$sZone = StringLeft($sCell, StringInStr($sCell, '[') - 1)
	Return ($sZone)
EndFunc   ;==>_GetZone

Func _GetDirections($sCell, $sZone)
	$sDirections = StringReplace(StringReplace(StringReplace($sCell, $sZone, ''), '[', ''), ']', '')
	Return ($sDirections)
EndFunc   ;==>_GetDirections

Func _Exit()
	Exit
EndFunc   ;==>_Exit

