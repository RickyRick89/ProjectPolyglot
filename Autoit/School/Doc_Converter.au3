; AutoIt script to convert .doc to .tex using pandoc

; Path to pandoc executable
Global $pandocPath = 'C:\Program Files\Pandoc\pandoc.exe'

; Source and destination files
Global $sourceFile = 'C:\Users\Richard\Downloads\Test Title.rtf'
Global $destFile = 'C:\Users\Richard\Downloads\Test Title.tex'

; Convert using pandoc
ConvertDocToTex($sourceFile, $destFile)

Func ConvertDocToTex($src, $dst)
	; Run pandoc to convert
	RunWait($pandocPath & ' -f rtf -t latex -s "' & $src & '" -o "' & $dst & '"')
	If @error Then
		MsgBox(16, 'Error', 'Conversion failed!')
	Else
		MsgBox(64, 'Success', 'Conversion completed successfully!')
	EndIf
EndFunc   ;==>ConvertDocToTex
