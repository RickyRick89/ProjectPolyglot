#include <Excel.au3>
#include <Array.au3>

$sFilePath = "C:\Users\Triplex\Desktop\Locations_Table.xlsx"
$sWinTitleMain = 'Free Barcode Generator  6.8.18  (Free Edition)'
$sWinTitlePrint = ' Print Barcode'
$sWinTitleSaveAs = 'Save Print Output As'
$sWinTitleExport = 'Export'
$sRootPath = 'C:\Users\Triplex\Downloads\Stand_Barcodes\BarcodeImages2201131309\'


$oMasterWorkbook = _Excel_BookAttach($sFilePath)
If Not IsObj($oMasterWorkbook) Then
	$oExcel = _Excel_Open()
	$oMasterWorkbook = _Excel_BookOpen($oExcel, $sFilePath)
Else
	$oExcel = $oMasterWorkbook.Application
EndIf

$aCodes = _Excel_RangeRead($oMasterWorkbook)

;~ _ArrayDisplay($aCodes)
;~ Exit


For $x = 1 To UBound($aCodes) - 1
	WinActivate($sWinTitleMain)
	$sCode = $aCodes[$x][18]
	$sDesc = $aCodes[$x][0]
	$sNewFilePath = $sRootPath & $sCode & '.pdf'

	if $sCode = '' then ContinueLoop

	ControlSetText($sWinTitleMain, '', '[CLASS:ThunderRT6TextBox; INSTANCE:7]', $sCode)
	ControlSetText($sWinTitleMain, '', '[CLASS:ThunderRT6TextBox; INSTANCE:5]', $sDesc)
	Sleep(100)
	ControlClick($sWinTitleMain, '', '[CLASS:ThunderRT6CommandButton; INSTANCE:35]')
	WinWait($sWinTitleExport, 'Select Folder ...')
	ControlClick($sWinTitleExport, 'Select Folder ...', '[CLASS:ThunderRT6OptionButton; INSTANCE:3]')
	ControlSetText($sWinTitleExport, 'Select Folder ...', '[CLASS:ThunderRT6TextBox; INSTANCE:1]', $sRootPath)
	ControlClick($sWinTitleExport, 'Select Folder ...', '[CLASS:ThunderRT6CommandButton; INSTANCE:1]')
	Sleep(200)
;~ 	Exit

;~ 	ControlClick($sWinTitleMain, '', '[CLASS:ThunderRT6CommandButton; INSTANCE:36]')
;~ 	WinWait($sWinTitlePrint)
;~ 	Sleep(100)
;~ 	ControlClick($sWinTitlePrint,'','[CLASS:ThunderRT6CommandButton; INSTANCE:2]')
;~ 	Exit

;~ 	WinWait($sWinTitleSaveAs)
;~ 	Sleep(100)
;~ 	ControlSetText($sWinTitleSaveAs,'','[CLASS:Edit; INSTANCE:1]',$sNewFilePath)
;~ 	Sleep(100)
;~ 	ControlClick($sWinTitleSaveAs,'','[CLASS:Button; INSTANCE:2]')

Next
