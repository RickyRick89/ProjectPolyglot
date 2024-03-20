
While 1
	If WinExists('Microsoft Excel','Overwrite Cells in Worksheet') Then
		ControlClick('Microsoft Excel','Overwrite Cells in Worksheet','[CLASS:Button; INSTANCE:1]')
	EndIf
	If WinExists('Microsoft Excel','Write Cell Data in Worksheet') Then
		ControlClick('Microsoft Excel','Write Cell Data in Worksheet','[CLASS:Button; INSTANCE:1]')
	EndIf
	If WinExists('Microsoft Excel','You will OVERWRITE the configuration of an ONLINE') Then
		ControlClick('Microsoft Excel','You will OVERWRITE the configuration of an ONLINE','[CLASS:Button; INSTANCE:1]')
	EndIf
	If WinExists('Microsoft Excel','CLX Read Complete!') Then
		ControlClick('Microsoft Excel','CLX Read Complete!','[CLASS:Button; INSTANCE:1]')
	EndIf
	If WinExists('Microsoft Excel','CLX Write Complete!') Then
		ControlClick('Microsoft Excel','CLX Write Complete!','[CLASS:Button; INSTANCE:1]')
	EndIf
	Sleep(50)
WEnd
