#include <Excel.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <Word.au3>

Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet('{esc}', '_Exit')

$sTemplatePath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_MosesLake\SystemIntegrator\_Shared\Commissioning\Reports\Templates\ICO_Issues_Report_Template.docx"
$sTemplateName = 'ICO_Issues_Report_Template.docx'
$sConversationPath = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_MosesLake\SystemIntegrator\_Shared\Commissioning\Reports\Exports\WhatsApp Chat with Moses Lake Issues.txt"
$sConversationRoot = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_MosesLake\SystemIntegrator\_Shared\Commissioning\Reports\Exports\"
$sINIFile = "C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_MosesLake\SystemIntegrator\_Shared\Commissioning\Reports\ScriptData.ini"

;~ MsgBox(0,'','Delete files from:'&@CRLF'C:\Users\rgrov\OneDrive - Triplex Automation LLC\Exports')
;~ MsgBox(0,'','Export conversation to :'&@CRLF'C:\Users\rgrov\OneDrive - Triplex Automation LLC\Exports')


$aConversation = FileReadToArray($sConversationPath)

DirRemove('C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_MosesLake\SystemIntegrator\_Shared\Commissioning\Reports\Exports', 1)
DirCopy('C:\Users\rgrov\OneDrive - Triplex Automation LLC\Exports', 'C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_MosesLake\SystemIntegrator\_Shared\Commissioning\Reports\Exports', 1)

$oApp = _Word_Create()
$oDoc = _Word_DocOpen($oApp, $sTemplatePath)



;~ _ArrayDisplay($aConversation)

$bStarted = 0
$iBullet = 1

$sPreviousReportEndDT = IniRead($sINIFile, 'ICO ISSUE REPORT', 'LastPost', '')

For $x = 0 To UBound($aConversation) - 1
	If Not $bStarted And Not StringInStr($aConversation[$x], ':') Then
		ContinueLoop
	ElseIf StringInStr($aConversation[$x], ':') Then
		$bStarted = 1
	EndIf

	If StringInStr($aConversation[$x], ': ') Then

		$sDT = StringReplace(StringLeft($aConversation[$x], StringInStr($aConversation[$x], ' - ')), ',', '')
		$sDT = _FormatDT($sDT)

		If _DateDiff('n', $sPreviousReportEndDT, $sDT) < 0 Then ContinueLoop

		IniWrite($sINIFile, 'ICO ISSUE REPORT', 'LastPost', $sDT)

		If Not StringInStr($aConversation[$x], 'IMG-') Then
			$iResponse = MsgBox($MB_YESNO, '', 'Include in report?' & @CRLF & $aConversation[$x])
			If $iResponse = $IDYES Then
				$iStart = StringInStr($aConversation[$x], ': ') + 1
				$sTempString = StringTrimLeft($aConversation[$x], $iStart)
				$oApp.Selection.TypeText($iBullet & '.' & @TAB & $sTempString & @CRLF & @CRLF)
				$iBullet += 1
			Else
				ContinueLoop
			EndIf
		Else
			$iStart = StringInStr($aConversation[$x], ': ') + 2
			$iEnd = StringInStr($aConversation[$x], '.jpg') + 4
			$sImageFile = StringMid($aConversation[$x], $iStart, $iEnd - $iStart)
			$sImagePath = $sConversationRoot & $sImageFile
			If Not StringInStr($aConversation[$x + 1], ': ') Then
				$oApp.Selection.TypeText($iBullet & '.' & @TAB & $aConversation[$x + 1] & @CRLF)
				$iBullet += 1
			EndIf
;~ 			WinActivate($sTemplateName)
;~ 			ControlSend($sTemplateName, '', '', '{backspace}')

			$oPic = _Word_DocPictureAdd($oDoc, $sImagePath, False, True)
			$oPic.ScaleHeight = 20
			$oPic.ScaleWidth = 20
			WinActivate($sTemplateName)
			ControlSend($sTemplateName, '', '', '^{end}{enter 2}')
		EndIf
	EndIf


Next

$oDoc.SaveAs('C:\Users\rgrov\RJX AUTOMATION LLC\Raul Barrios - Simplot\2022_MosesLake\SystemIntegrator\_Shared\Commissioning\Reports\ICO_Issues_Report_' & @YEAR & @MON & @MDAY & '.docx')

;~ _Word_DocClose($oDoc)


Func _FormatDT($sInput)

	$aTemp = StringSplit($sInput, ' ')
	$sDate = $aTemp[1]
	$sTime = $aTemp[2]
	$iFirst = StringInStr($sDate, '/')
	$iSecond = StringInStr($sDate, '/', 0, 2)
	$sMonth = StringLeft($sDate, $iFirst - 1)
	$sDay = StringMid($sDate, $iFirst + 1, $iSecond - $iFirst - 1)
	$sYear = StringTrimLeft($sDate, $iSecond) + 2000

	$iFirst = StringInStr($sTime, ':')
	$sHour = StringLeft($sTime, $iFirst - 1)
	$sMinutes = StringMid($sTime, $iFirst + 1, 2)

	$sDT = $sYear & '/' & $sMonth & '/' & $sDay & ' ' & $sHour & ':' & $sMinutes & ':00'
	Return ($sDT)
EndFunc   ;==>_FormatDT



Func _Exit()
	Exit
EndFunc   ;==>_Exit

