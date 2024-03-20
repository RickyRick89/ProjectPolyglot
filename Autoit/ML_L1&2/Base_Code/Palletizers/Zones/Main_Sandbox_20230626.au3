#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiTreeView.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

Global $bSkipExisting = True

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
	$sMainText = ''
	For $iRow = UBound($aZoneSheet) - 1 To 0 Step -1
		For $iCol = 0 To UBound($aZoneSheet, 2) - 1
			$sCell = $aZoneSheet[$iRow][$iCol]
			If $sCell = '' Or Not StringInStr($sCell, 'Zone') Then ContinueLoop

			$sZone = _GetZone($sCell)
			ConsoleWrite('--->Zone = ' & $sZone & @CRLF)
			$sMainText &= 'JSR(' & $sZone & ');'
		Next
	Next
	ClipPut($sMainText)


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

