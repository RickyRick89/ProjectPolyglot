
While 1
	Sleep(100)
	If WinExists('Microsoft Excel', 'Overwrite Cells in Worksheet') Then
		ControlClick('Microsoft Excel', 'Overwrite Cells in Worksheet', '[CLASS:Button; INSTANCE:1]')
	EndIf
	If WinExists('Microsoft Excel', 'CLX Read Complete!') Then
		ControlClick('Microsoft Excel', 'CLX Read Complete!', '[CLASS:Button; INSTANCE:1]')
	EndIf
WEnd

