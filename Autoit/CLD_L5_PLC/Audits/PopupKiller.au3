

While 1
	If WinExists('Microsoft Excel', 'Overwrite Cells in Worksheet') Then
		ControlClick('Microsoft Excel', 'Overwrite Cells in Worksheet', '[CLASS:Button; INSTANCE:1]')
	ElseIf WinExists('Microsoft Excel', 'CLX Read Complete!') Then
		ControlClick('Microsoft Excel', 'CLX Read Complete!', '[CLASS:Button; INSTANCE:1]')
	EndIf
	Sleep(100)
WEnd
