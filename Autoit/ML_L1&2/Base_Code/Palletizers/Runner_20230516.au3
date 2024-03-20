
HotKeySet('{esc}', '_Exit')
$sPLCWinTitle = 'Logix Designer - GFK_L04_CLX'



;~ ConsoleWrite(@CRLF & '>>>>>>> Routine_Gen.au3')
;~ $iRoutinePID = Run(@AutoItExe & ' "Y:\My_Scripts\GFK_L4\Base_Code\Routine_Gen.au3"')
;~ ConsoleWrite(@CRLF & '>>>>>>> Main_Gen.au3')
;~ $iMainPID = Run(@AutoItExe & ' "Y:\My_Scripts\GFK_L4\Base_Code\Main_Gen.au3"')


;~ ControlSend($sPLCWinTitle, '', '', '{ALT DOWN}{4}{ALT UP}')
;~ ConsoleWrite(@CRLF & '>>>>>>> Logical_Organizer_Start.au3')
;~ RunWait(@AutoItExe & ' "Y:\My_Scripts\GFK_L4\Base_Code\Logical_Organizer_Start.au3"')

;~ ControlSend($sPLCWinTitle, '', '', '{ALT DOWN}{0}{ALT UP}')

;~ While ProcessExists($iRoutinePID) Or ProcessExists($iMainPID)
;~ 	Sleep(1000)
;~ 	ConsoleWrite(@CRLF & '-----> Waiting for GEN to complete.')
;~ WEnd

ConsoleWrite(@CRLF & '>>>>>>> Routine_Import.au3')
RunWait(@AutoItExe & ' "Y:\My_Scripts\GFK_L4\Base_Code\Routine_Import.au3"')
ConsoleWrite(@CRLF & '>>>>>>> Main_Import.au3')
RunWait(@AutoItExe & ' "Y:\My_Scripts\GFK_L4\Base_Code\Main_Import.au3"')


Func _Exit()
	Exit
EndFunc   ;==>_Exit
