#include <Array.au3>
#include <Excel.au3>
#include <File.au3>
#include <Date.au3>

HotKeySet('{esc}', '_Exit')



$sWorkbookPath = "C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\New folder\TradingView_Crypto_Data\1INCHUSD_5m.csv"
Local $aSummary[1][1]
$sProcessingTime = 0

$oWorkbook = _Excel_BookAttach($sWorkbookPath)
If Not IsObj($oWorkbook) Then
	$oExcel = _Excel_Open()
	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
Else
	$oExcel = $oWorkbook.Application
EndIf
$aSheet = _Excel_RangeRead($oWorkbook)

;~ _ArrayDisplay($aSheet)
Local $aSummary[1][2]
$aSummary[0][0] = $aSheet[0][0]
$aSummary[0][1] = $aSheet[0][1]

For $iCol = 0 To UBound($aSheet, 2) - 1
	$sHeader = $aSheet[0][$iCol]
	If StringInStr($sHeader, '_Sig_') Then
		$iNewCol = UBound($aSummary, 2)
		ReDim $aSummary[UBound($aSummary)][UBound($aSummary, 2) + 1]

		$aSummary[0][$iNewCol] = $sHeader

		For $iRow = 1 To UBound($aSheet) - 1
			If $iRow > UBound($aSummary) - 1 Then
				ReDim $aSummary[UBound($aSummary) + 1][UBound($aSummary, 2)]
			EndIf
			If $iNewCol = 2 Then
				$aSummary[$iRow][0] = $aSheet[$iRow][0]
				$aSummary[$iRow][1] = $aSheet[$iRow][1]

				If $aSheet[$iRow][0] = '' Then
					$aSummary[$iRow][0] = $aSummary[$iRow - 1][0]
				EndIf
			EndIf

			Switch $aSheet[$iRow][$iCol]
				Case 'Buy'
					$aSummary[$iRow][$iNewCol] = 1
				Case 'Sell'
					$aSummary[$iRow][$iNewCol] = -1
				Case 'Neutral'
					$aSummary[$iRow][$iNewCol] = 0
			EndSwitch
		Next
	EndIf

Next

;~ _ArrayDisplay($aSummary)
$oWorkbookNew = _Excel_BookNew($oExcel)
_Excel_RangeWrite($oWorkbookNew, 1, $aSummary)


Local $aResults[1][5]
$aResults[0][0] = 'Signals'
$aResults[0][1] = 'Unanimous Fiat'
$aResults[0][2] = 'Unanimous Trades'
$aResults[0][3] = 'Majority Fiat'
$aResults[0][4] = 'Majority Trades'


$iInc = 6710887
$iEnd = 7270126

While 1
	$dtStartTime = TimerInit()
	$sBinary = _Convert_To_Binary($iInc)

	$sTimeLeft = (((2 ^ 26) - $iInc) * $sProcessingTime) / (1000 * 60 * 60 * 24) ;Days
	ConsoleWrite(@CRLF & '---------' & $sTimeLeft & @CRLF)

	If $iInc > $iEnd Then
		ExitLoop
	EndIf

	$aBits = StringSplit($sBinary, '')

	$iUnanimousTrades = 0
	$iMajorityTrades = 0
	$iUnanimousFiat = 100
	$iMajorityFiat = 100
	$iUnanimousCrypto = 0
	$iMajorityCrypto = 0

	$sSigList = ''
	$sSigCount = $aBits[0]
	For $iSig = $sSigCount To 1 Step -1
		If $aBits[$iSig] = 0 Then ContinueLoop
		$iCol = ($sSigCount - $iSig) + 2
		If $iSig <> 1 Then
			$sDelimiter = '&'
		Else
			$sDelimiter = ''
		EndIf

		$sSigList &= $aSummary[0][$iCol] & $sDelimiter
	Next
	ConsoleWrite(@CRLF & '### ' & $sSigList)

	For $iRow = 2 To UBound($aSummary) - 1
		;Check previous value
		$bPrevUnanimousBuy = 1
		$bPrevMajorityBuy = 0
		$bPrevUnanimousSell = 1
		$bPrevMajoritySell = 0
		$iPrevSum = 0
		$iPrevCount = 0
		$iPrevAverage = 0
		For $iPrevSig = $sSigCount To 1 Step -1
			If $aBits[$iPrevSig] = 0 Then ContinueLoop
			$iCol = ($sSigCount - $iPrevSig) + 2
			$iPrevSum += $aSummary[$iRow - 1][$iCol]
			$iPrevCount += 1
			If $aSummary[$iRow - 1][$iCol] < 1 Then $bPrevUnanimousBuy = 0
			If $aSummary[$iRow - 1][$iCol] > -1 Then $bPrevUnanimousSell = 0
		Next
		$iPrevAverage = $iPrevSum / $iPrevCount
		If $iPrevAverage < .5 Then $bPrevMajoritySell = 1
		If $iPrevAverage > .5 Then $bPrevMajorityBuy = 1


		;Check current values
		$bUnanimousBuy = 1
		$bMajorityBuy = 0
		$bUnanimousSell = 1
		$bMajoritySell = 0
		$iSum = 0
		$iCount = 0
		$iAverage = 0
		For $iSig = $sSigCount To 1 Step -1
			If $aBits[$iSig] = 0 Then ContinueLoop
			$iCol = ($sSigCount - $iSig) + 2
			$iSum += $aSummary[$iRow][$iCol]
			$iCount += 1
			If $aSummary[$iRow][$iCol] < 1 Then $bUnanimousBuy = 0
			If $aSummary[$iRow][$iCol] > -1 Then $bUnanimousSell = 0
		Next
		$iAverage = $iSum / $iCount
		If $iAverage < .5 Then $bMajoritySell = 1
		If $iAverage > .5 Then $bMajorityBuy = 1

		$bUnanimousBuySignal = $bUnanimousBuy And Not $bPrevUnanimousBuy
		$bMajorityBuySignal = $bMajorityBuy And Not $bPrevMajorityBuy
		$bUnanimousSellSignal = $bUnanimousSell And Not $bPrevUnanimousSell
		$bMajoritySellSignal = $bMajoritySell And Not $bPrevMajoritySell

		If $bUnanimousBuySignal And $iUnanimousFiat > 0 Then
			$iUnanimousCrypto = $iUnanimousFiat / $aSummary[$iRow][0]
			$iUnanimousFiat = 0
			$iUnanimousTrades += 1
			ConsoleWrite(@CRLF & '-->Unanimous Buy @Row ' & $iRow & '(Crypto=' & $iUnanimousCrypto & ')')
		EndIf
		If $bMajorityBuySignal And $iMajorityFiat > 0 Then
			$iMajorityCrypto = $iMajorityFiat / $aSummary[$iRow][0]
			$iMajorityFiat = 0
			$iMajorityTrades += 1
			ConsoleWrite(@CRLF & '-->Majority Buy @Row ' & $iRow & '(Crypto=' & $iMajorityCrypto & ')')
		EndIf
		If ($bUnanimousSellSignal Or ($iRow = UBound($aSummary) - 1)) And $iUnanimousCrypto > 0 Then
			$iUnanimousFiat = $iUnanimousCrypto * $aSummary[$iRow][0]
			$iUnanimousCrypto = 0
			ConsoleWrite(@CRLF & '<--Unanimous Sell @Row ' & $iRow & '(Fiat=' & $iUnanimousFiat & ')')
		EndIf
		If ($bMajoritySellSignal Or ($iRow = UBound($aSummary) - 1)) And $iMajorityCrypto > 0 Then
			$iMajorityFiat = $iMajorityCrypto * $aSummary[$iRow][0]
			$iMajorityCrypto = 0
			ConsoleWrite(@CRLF & '<--Majority Sell @Row ' & $iRow & '(Fiat=' & $iMajorityFiat & ')')
		EndIf


	Next
;~ 	MsgBox(0, '', $sSigList & @CRLF & 'Unanimous:$' & $iUnanimousFiat & ' Over ' & $iUnanimousTrades & ' Trades' & @CRLF & 'Majority:$' & $iMajorityFiat & ' Over ' & $iMajorityTrades & ' Trades')
	_ArrayAdd($aResults, $sSigList & '|' & $iUnanimousFiat & '|' & $iUnanimousTrades & '|' & $iMajorityFiat & '|' & $iMajorityTrades)
;~ 	_ArrayDisplay($aResults)

	$iInc += 1


	$sProcessingTime = TimerDiff($dtStartTime)

WEnd
$oSheet = _Excel_SheetAdd($oWorkbook)
_Excel_RangeWrite($oWorkbook, $oSheet, $aResults)
_Excel_BookSaveAs($oWorkbook,'C:\Users\rgrov\OneDrive - Bit-Wise Automation LLC\Richards_Docs\My_Scripts\New folder\'&$iEnd&'xlsx')


Func _Convert_To_Binary($iNumber)
	Local $sBinString = ""
	While $iNumber
		$sBinString = BitAND($iNumber, 1) & $sBinString
		$iNumber = BitShift($iNumber, 1)
	WEnd
	Return $sBinString
EndFunc   ;==>_Convert_To_Binary



Func _Exit()
	Exit
EndFunc   ;==>_Exit


