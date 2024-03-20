#include <EventLog.au3>
#include <Array.au3>

HotKeySet('{esc}', '_Exit')

Global $hEventLog = _EventLog__Open('', 'Security')

While 1
	$aLog = _EventLog__Read($hEventLog, True, False)

	$sDate = $aLog[2]
	$aDate = StringSplit($sDate, '/')
	$sTime = $aLog[3]
	ConsoleWrite(@CRLF & '====>' & $sDate & ' ' & $sTime)

	If $aLog[6] <> 4801 And $aLog[6] <> 4800 Then ContinueLoop
	$aLines = StringSplit($aLog[13], @CR)
	For $x = 1 To $aLines[0]
		$aLines[$x] = StringStripWS($aLines[$x], 8)
	Next
	If Not StringInStr($aLines[5], 'AccountName:rgroves') Then ContinueLoop

	ConsoleWrite(@CRLF & '^^^^^^^ Logged On')
	_ArrayDisplay($aLog)
WEnd




_Exit()

Func _Exit()
	_EventLog__Close($hEventLog)
	Exit
EndFunc   ;==>_Exit


