Private Sub bttRoverZone[Index]_Released()
	Dim vParameters As String
    
	vParameters = bttRoverZone[Index].Caption
    Call ZoneSelected(vParameters)
End Sub