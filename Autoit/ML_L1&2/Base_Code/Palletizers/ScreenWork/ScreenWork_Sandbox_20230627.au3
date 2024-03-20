#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Global $bSkipExisting = True

$sChainMotorPath = "W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\ChainMotor.xml"
$sConveyorLRPath = "W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\ConveyorLR.XML"
$sConveyorUDPath = "W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\ConveyorUD.XML"
$sPalletPath = "W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\Pallet.xml"
$sPopupValvePath = "W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\PopupValve.xml"
$sImportPath = "W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\Import.xml"

$sTemplatePath = 'X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Exports\Templates\'

$sZoneWorkbookPath = "X:\2022_MosesLake\SystemIntegrator\_Shared\PLC_HMI_Code\RichardGroves_Sandbox\Pallet_Conv_Layout.xlsx"

_Routine_Generator('Zones')

Func _Routine_Generator($sZoneSheetName)
	$sNewText = ''
	$oZoneWorkbook = _Excel_BookAttach($sZoneWorkbookPath)
	If Not IsObj($oZoneWorkbook) Then
		$oExcel = _Excel_Open()
		$oZoneWorkbook = _Excel_BookOpen($oExcel, $sZoneWorkbookPath)
	Else
		$oExcel = $oZoneWorkbook.Application
	EndIf

	$aZoneSheet = _Excel_RangeRead($oZoneWorkbook, $sZoneSheetName)
	$sMainText = ''
	For $iRow = UBound($aZoneSheet) - 1 To 0 Step -1
		For $iCol = 0 To UBound($aZoneSheet, 2) - 1
			$sCell = $aZoneSheet[$iRow][$iCol]
			If $sCell = '' Or Not StringInStr($sCell, 'Zone') Then ContinueLoop

			$sZone = _GetZone($sCell)
			ConsoleWrite('--->Zone = ' & $sZone & @CRLF)
			$sDirections = _GetDirections($sCell, $sZone)
			ConsoleWrite('--->Directions = ' & $sDirections & @CRLF)

			$iEqNum = Number(StringReplace($sZone, 'Zone', ''))

			$iTop = $iRow * 90
			$iLeft = $iCol * 90

			If $iRow = UBound($aZoneSheet) - 1 Then
				$sConveyorText = FileRead($sConveyorLRPath)
				$sConveyorText = StringReplace($sConveyorText, '[NAME]', 'EC' & $iEqNum)
			Else
				$sConveyorText = FileRead($sConveyorUDPath)
				$sConveyorText = StringReplace($sConveyorText, '[NAME]', 'EC' & $iEqNum & 'A')
			EndIf

			If $sDirections <> 'FB' Then
				$sChainMotorText = FileRead($sChainMotorPath)
				$sChainMotorText = StringReplace($sChainMotorText, '[NAME]', 'EC' & $iEqNum & 'B')

				$sPopupValveText = FileRead($sPopupValvePath)
				$sPopupValveText = StringReplace($sPopupValveText, '[NAME]', 'XV' & $iEqNum & 'E')
			Else
				$sChainMotorText = ''
				$sPopupValveText = ''
			EndIf
			$sPalletText = FileRead($sPalletPath)
			$sPalletText = StringReplace($sPalletText, '[NAME]', 'Pallet' & $iEqNum)
			$sPalletText = StringReplace($sPalletText, '[EQNUM]', $iEqNum)

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			ConsoleWrite('--->Conveyor Text' & @CRLF)
			ConsoleWrite('->Top' & @CRLF)
			$sConveyorText = StringReplace($sConveyorText, '[TOP]', $iTop)
			For $iInc = -20 To 200

				$sConveyorText = StringReplace($sConveyorText, '[TOP+' & $iInc & ']', $iTop + $iInc)
			Next
			ConsoleWrite('->Left' & @CRLF)
			$sConveyorText = StringReplace($sConveyorText, '[LEFT]', $iLeft)
			For $iInc = -20 To 200

				$sConveyorText = StringReplace($sConveyorText, '[LEFT+' & $iInc & ']', $iLeft + $iInc)
			Next
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			ConsoleWrite('--->Chain Motor Text' & @CRLF)
			ConsoleWrite('->Top' & @CRLF)
			$sChainMotorText = StringReplace($sChainMotorText, '[TOP]', $iTop)
			For $iInc = -20 To 200

				$sChainMotorText = StringReplace($sChainMotorText, '[TOP+' & $iInc & ']', $iTop + $iInc)
			Next
			ConsoleWrite('->Left' & @CRLF)
			$sChainMotorText = StringReplace($sChainMotorText, '[LEFT]', $iLeft)
			For $iInc = -20 To 200

				$sChainMotorText = StringReplace($sChainMotorText, '[LEFT+' & $iInc & ']', $iLeft + $iInc)
			Next
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			ConsoleWrite('--->Popup Valve Text' & @CRLF)
			ConsoleWrite('->Top' & @CRLF)
			$sPopupValveText = StringReplace($sPopupValveText, '[TOP]', $iTop)
			For $iInc = -20 To 200

				$sPopupValveText = StringReplace($sPopupValveText, '[TOP+' & $iInc & ']', $iTop + $iInc)
			Next
			ConsoleWrite('->Left' & @CRLF)
			$sPopupValveText = StringReplace($sPopupValveText, '[LEFT]', $iLeft)
			For $iInc = -20 To 200

				$sPopupValveText = StringReplace($sPopupValveText, '[LEFT+' & $iInc & ']', $iLeft + $iInc)
			Next
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			ConsoleWrite('--->Pallet Text' & @CRLF)
			ConsoleWrite('->Top' & @CRLF)
			$sPalletText = StringReplace($sPalletText, '[TOP]', $iTop)
			For $iInc = -20 To 200

				$sPalletText = StringReplace($sPalletText, '[TOP+' & $iInc & ']', $iTop + $iInc)
			Next
			ConsoleWrite('->Left' & @CRLF)
			$sPalletText = StringReplace($sPalletText, '[LEFT]', $iLeft)
			For $iInc = -20 To 200

				$sPalletText = StringReplace($sPalletText, '[LEFT+' & $iInc & ']', $iLeft + $iInc)
			Next

			$sNewText &= $sConveyorText & @CRLF
			$sNewText &= $sChainMotorText & @CRLF
			$sNewText &= $sPopupValveText & @CRLF
			$sNewText &= $sPalletText

		Next
	Next
	FileCopy("W:\My_Scripts\ML_L1&2\Base_Code\Palletizers\ScreenWork\Templates\Archive\Import.xml", $sImportPath, 9)
	$sImportText = FileRead($sImportPath)
	$sImportText = StringReplace($sImportText, '[TEXT]', $sNewText)

	FileDelete($sImportPath)
	FileWrite($sImportPath, $sImportText)
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

