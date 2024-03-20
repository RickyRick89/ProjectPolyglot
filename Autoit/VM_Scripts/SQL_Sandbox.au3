#include <Excel.au3>
#include <Array.au3>
#include <_sql.au3>

$sWorkbookPath = "C:\Users\Triplex\Downloads\Rover_Status_History.csv"
$sSheetName = 'Sheet1'
$sServerName = '10.84.61.10'
$sDatabaseName = 'RoverControl'

_SQL_RegisterErrorHandler() ;register the error handler to prevent hard crash on COM error


;~ $oWorkbook = _Excel_BookAttach($sWorkbookPath)
;~ If Not IsObj($oWorkbook) Then
;~ 	$oExcel = _Excel_Open()
;~ 	$oWorkbook = _Excel_BookOpen($oExcel, $sWorkbookPath)
;~ Else
;~ 	$oExcel = $oWorkbook.Application
;~ EndIf

;~ $aSheet = _Excel_RangeRead($oWorkbook, $sSheetName)

$aSheet = ''

;~ _ArrayDisplay($aSheet)


$oADODB = _SQL_Startup()
;~ For $oProperty In $oADODB.Properties
;~ 	ClipPut($oProperty.Name)
;~ 	MsgBox(0, $oProperty.Name, $oProperty.Value)
;~ Next


If $oADODB = $SQL_ERROR Then
	MsgBox(0 + 16 + 262144, "Error", _SQL_GetErrMsg())
EndIf
If _sql_Connect($oADODB, $sServerName, $sDatabaseName, "rover", "rover1234", True) = $SQL_ERROR Then ;"1gn1t10n"
	MsgBox(0 + 16 + 262144, "Error", _SQL_GetErrMsg())
	_SQL_Close()
	Exit
EndIf
Exit

For $x = 1 To UBound($aSheet) - 1
	$sDescription = $aSheet[$x][1]
	$sLGVID = $aSheet[$x][2]
	$sDCSID = $aSheet[$x][3]
	ConsoleWrite(@CRLF & '--> ' & $x & '/' & UBound($aSheet) - 1)
	__StoreDescription($sDCSID, $sLGVID, $sDescription)
	For $y = 1 To UBound($aSheet) - 1
		$sDCSID2 = $aSheet[$y][3]
		If $sDCSID = $sDCSID2 Or $sDCSID = '' Or $sDCSID2 = '' Then ContinueLoop
		__StorePath($sDCSID, $sDCSID2)
	Next
Next

_SQL_Close($oADODB)


Func __StoreDescription($sDCSID, $sLGVID, $sDescription)
	Local $aTable, $iRows, $iColumns
	$sTableName = 'TBL_LGV_Stations'
	If _SQL_GetTable2D($oADODB, "SELECT * FROM " & $sTableName & " WHERE DCS_ID = " & $sDCSID & ";", $aTable, $iRows, $iColumns) = $SQL_OK Then
		_SQL_Execute($oADODB, "UPDATE " & $sTableName & " SET LGV_ID = '" & $sLGVID & "', DESCRIPTION = '" & $sDescription & "' WHERE DCS_ID = " & $sDCSID & ";")
	Else
		; Insert row
		_SQL_Execute($oADODB, "INSERT INTO " & $sTableName & " VALUES (" & $sDCSID & ", '" & $sLGVID & "', '', '" & $sDescription & "', 0, 0);")
;~ 		MsgBox(0 + 16 + 262144, "SQL Error", _SQL_GetErrMsg())
	EndIf
EndFunc   ;==>__StoreDescription

Func __StorePath($sDCSID, $sDCSID2)
	Local $aTable, $iRows, $iColumns
	$sTableName = 'TBL_LGV_Route'
	If _SQL_GetTable2D($oADODB, "SELECT * FROM " & $sTableName & " WHERE DCS_ID_FROM = " & $sDCSID & " AND DCS_ID_TO = " & $sDCSID2 & ";", $aTable, $iRows, $iColumns) = $SQL_OK Then

		; Don't do anything.

	Else
		; Insert row
		_SQL_Execute($oADODB, "INSERT INTO " & $sTableName & " (DCS_ID_FROM, DCS_ID_TO) VALUES (" & $sDCSID & ", " & $sDCSID2 & ");")
;~ 		MsgBox(0 + 16 + 262144, "SQL Error", _SQL_GetErrMsg())
	EndIf
EndFunc   ;==>__StorePath
