
While 1
	Sleep(100)
	If WinExists('[Class:#32770]', 'A Graphics file with the name ') Then
		ControlClick('[Class:#32770]', 'A Graphics file with the name ', '[CLASS:Button; INSTANCE:3]')
	EndIf
WEnd

