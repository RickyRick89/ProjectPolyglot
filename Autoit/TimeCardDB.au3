; -- Rev 02

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "Access.au3"

Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 0)
;Constatnt
Const $conProgName = "Phone Book Rev 02"
Const $conMyName = "Ayman Henry"
Const $conMyEmail = "AymHenry@Hotmail.com"

Const $conDbFile = "PhoneBook.mdb" ; it has to be on script current Dir
Const $conTable = "tblPhoneBook"
Const $conOK = 1, $conEdit = 1, $conAdd = 0, $conShow = -1

;Global var

Global $o_PhoneBook
Global $n_RecCount, $n_RecPos

Global $cmdAdd, $cmdEdit, $cmdDelete, $cmdCancel
Global $cmdNext, $cmdFirst, $cmdPrev, $cmdLast
Global $cmdSave
Global $n_Status

; Sreen Fields
Global $txtFirstName, $txtMidName, $txtLastName
Global $txtMobile, $txtHomePhone, $txtAddress
Global $lblRecPos

If Setup() = $conOK Then
	Main()
EndIf

Exit
;==================

; #FUNCTION# ====================================================================================================================
; Name ..........: Setup
; Description ...:
; Syntax ........: Setup()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Setup()

	$o_PhoneBook = _AccessOpen(@ScriptDir & "\" & $conDbFile)
	If $o_PhoneBook = 0 Then
		MsgBox(16, $conProgName, "Database File is not found " & @LF & @ScriptDir & "\" & $conDbFile)
		Exit
	EndIf

	$n_RecCount = _AccessRecordsCount($o_PhoneBook, $conTable)

	$n_RecPos = $n_RecCount

	Return $conOK
EndFunc   ;==>Setup

; #FUNCTION# ====================================================================================================================
; Name ..........: Shtdown
; Description ...:
; Syntax ........: Shtdown()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Shtdown() ; Close data base
	_AccessClose($o_PhoneBook)
EndFunc   ;==>Shtdown

; #FUNCTION# ====================================================================================================================
; Name ..........: KeysSetup
; Description ...:
; Syntax ........: KeysSetup($lngMode)
; Parameters ....: $lngMode             - An unknown value.
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func KeysSetup($lngMode)
	Local $nState1, $nState2
	Local $n_State, $n_Color, $n_Cursor

	If $lngMode = 1 Then ; Blank Table
		$nState1 = $GUI_ENABLE
		$nState2 = $GUI_DISABLE
		$n_State = Not $ES_READONLY
		$n_Color = 0x000000
		$n_Cursor = 5
	Else
		$nState1 = $GUI_DISABLE
		$nState2 = $GUI_ENABLE
		$n_State = $ES_READONLY
		$n_Color = 0x0000ff
		$n_Cursor = 2
	EndIf

	GUICtrlSetState($cmdSave, $nState1)
	GUICtrlSetState($cmdAdd, $nState2)
	GUICtrlSetState($cmdEdit, $nState2)
	GUICtrlSetState($cmdCancel, $nState1)
	GUICtrlSetState($cmdDelete, $nState2)

	GUICtrlSetState($cmdNext, $nState2)
	GUICtrlSetState($cmdPrev, $nState2)
	GUICtrlSetState($cmdFirst, $nState2)
	GUICtrlSetState($cmdLast, $nState2)

	; Screen Fields
	GUICtrlSetStyle($txtFirstName, $n_State)
	GUICtrlSetStyle($txtMidName, $n_State)
	GUICtrlSetStyle($txtLastName, $n_State)
	GUICtrlSetStyle($txtMobile, $n_State)
	GUICtrlSetStyle($txtHomePhone, $n_State)
	GUICtrlSetStyle($txtAddress, $n_State)

	GUICtrlSetColor($txtFirstName, $n_Color)
	GUICtrlSetColor($txtMidName, $n_Color)
	GUICtrlSetColor($txtLastName, $n_Color)
	GUICtrlSetColor($txtMobile, $n_Color)
	GUICtrlSetColor($txtHomePhone, $n_Color)
	GUICtrlSetColor($txtAddress, $n_Color)

	GUICtrlSetColor($txtFirstName, $n_Color)
	GUICtrlSetColor($txtMidName, $n_Color)
	GUICtrlSetColor($txtLastName, $n_Color)
	GUICtrlSetColor($txtMobile, $n_Color)
	GUICtrlSetColor($txtHomePhone, $n_Color)
	GUICtrlSetColor($txtAddress, $n_Color)

	GUICtrlSetCursor($txtFirstName, $n_Cursor)
	GUICtrlSetCursor($txtMidName, $n_Cursor)
	GUICtrlSetCursor($txtLastName, $n_Cursor)
	GUICtrlSetCursor($txtMobile, $n_Cursor)
	GUICtrlSetCursor($txtHomePhone, $n_Cursor)
	GUICtrlSetCursor($txtAddress, $n_Cursor)

EndFunc   ;==>KeysSetup

; #FUNCTION# ====================================================================================================================
; Name ..........: Main
; Description ...:
; Syntax ........: Main()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Main()
	Local $frmMain
	Local $Label1, $Label2, $Label3, $Label4, $Label5, $Label6, $Label7

	Local $Graphic1, $nMsg

	#region ### START Koda GUI section ### Form=K:\Ayman\Script\PhoneBook\frmMain.kxf
	$frmMain = GUICreate("Phone Book", 489, 355, 549, 207)

	$Label1 = GUICtrlCreateLabel("First Name", 40, 72, 69, 20)
	$Label2 = GUICtrlCreateLabel("Mobile", 40, 182, 45, 20)
	$Label3 = GUICtrlCreateLabel("Home Phone", 40, 219, 83, 20)
	$Label5 = GUICtrlCreateLabel("Middel Name", 40, 109, 85, 20)
	$Label6 = GUICtrlCreateLabel("Last Name", 40, 146, 69, 20)

	$txtFirstName = GUICtrlCreateInput("", 128, 72, 161, 24)
	GUICtrlSetLimit(-1, 30)

	$txtMidName = GUICtrlCreateInput("", 128, 108, 161, 24)
	GUICtrlSetLimit(-1, 30)

	$txtLastName = GUICtrlCreateInput("", 128, 144, 161, 24)
	GUICtrlSetLimit(-1, 30)

	$txtMobile = GUICtrlCreateInput("", 128, 180, 161, 24)
	GUICtrlSetLimit(-1, 30)

	$txtHomePhone = GUICtrlCreateInput("", 128, 216, 161, 24)
	GUICtrlSetLimit(-1, 30)

	$Label4 = GUICtrlCreateLabel("Address", 47, 256, 55, 20)
	$txtAddress = GUICtrlCreateInput("", 129, 252, 289, 24)
	GUICtrlSetLimit(-1, 200)

	$Label7 = GUICtrlCreateLabel("Phone Book", 40, 24, 142, 32, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 800, 0, "Tahoma")

	$cmdAdd = GUICtrlCreateButton("&Add", 352, 50, 92, 31, 0)
	$cmdEdit = GUICtrlCreateButton("&Edit", 352, 90, 92, 31, 0)
	$cmdDelete = GUICtrlCreateButton("&Delete", 352, 130, 92, 31, 0)
	$cmdSave = GUICtrlCreateButton("&Save", 352, 170, 92, 31, 0)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$cmdCancel = GUICtrlCreateButton("&Cancel", 352, 210, 92, 31, 0)

	$cmdFirst = GUICtrlCreateButton("|<", 132, 296, 33, 33, 0)
	$cmdPrev = GUICtrlCreateButton("<", 176, 296, 33, 33, 0)

	$lblRecPos = GUICtrlCreateLabel("", 220, 300, 70, 24, $ES_CENTER)
	GUICtrlSetBkColor(-1, 0xFFffFF)
	GUICtrlSetColor(-1, 0x0000FF)

	$cmdNext = GUICtrlCreateButton(">", 296, 296, 33, 33, 0)
	$cmdLast = GUICtrlCreateButton(">|", 337, 296, 33, 33, 0)

	GUISetState(@SW_SHOW)

	If $n_RecCount = 0 Then
		cmdAdd_Click()
	Else
		KeysSetup(0)
		cmdLast_Click()
	EndIf

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Shtdown()
				Return
			Case $cmdNext
				cmdNext_Click()
			Case $cmdPrev
				cmdPrev_Click()
			Case $cmdFirst
				cmdFirst_Click()
			Case $cmdLast
				cmdLast_Click()

			Case $cmdAdd
				cmdAdd_Click()
			Case $cmdEdit
				cmdEdit_CLick()
			Case $cmdDelete
				cmdDelete_Click()
			Case $cmdSave
				cmdSave_Click()
			Case $cmdCancel
				cmdCancel_Click()

		EndSwitch
	WEnd
EndFunc   ;==>Main

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdAdd_Click
; Description ...:
; Syntax ........: cmdAdd_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdAdd_Click()
	$n_Status = $conAdd
	ShowData()

	GUICtrlSetData($lblRecPos, $n_RecCount + 1 & " of " & $n_RecCount + 1)

	KeysSetup(1)
EndFunc   ;==>cmdAdd_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdEdit_Click
; Description ...:
; Syntax ........: cmdEdit_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdEdit_Click()
	$n_Status = $conEdit

	KeysSetup(1)
EndFunc   ;==>cmdEdit_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdCancel_Click
; Description ...:
; Syntax ........: cmdCancel_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdCancel_Click()
	If $n_RecCount = 0 Then ; Blank Table
		Return
	EndIf

	ShowData()
	KeysSetup(0)
EndFunc   ;==>cmdCancel_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdSave_Click
; Description ...:
; Syntax ........: cmdSave_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdSave_Click()
	SaveRec()

	If $n_Status = $conAdd Then
		cmdLast_Click()
	Else
		ShowData()
	EndIf

	$n_Status = $conShow
	KeysSetup(0)
EndFunc   ;==>cmdSave_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdDelete_Click
; Description ...:
; Syntax ........: cmdDelete_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdDelete_Click()
	If 7 = MsgBox(32 + 4, $conProgName, "Are you sure delete the current record Permanently?") Then ; if no
		Return
	EndIf

	;------------------------
	Local $n_FeedBack = _AccessRecordDelete($o_PhoneBook, $conTable, $n_RecPos)
	If $n_FeedBack = 1 Then

		$n_RecCount = _AccessRecordsCount($o_PhoneBook, $conTable)
		; or
		;$n_RecCount = $n_RecCount - 1
	Else
		MsgBox(16, $conProgName, "Error, Can not delete record.")
	EndIf
	;-------------------

	If $n_RecCount <= 0 Then ; Blank Table
		$n_RecCount = 0
		cmdAdd_Click()
	Else
		cmdLast_Click()
	EndIf
EndFunc   ;==>cmdDelete_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdNext_Click
; Description ...:
; Syntax ........: cmdNext_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdNext_Click()
	$n_Status = $conShow
	$n_RecPos = $n_RecPos + 1
	If $n_RecPos >= $n_RecCount Then $n_RecPos = $n_RecCount
	If $n_RecPos < 0 Then $n_RecPos = 0

	ShowData()
EndFunc   ;==>cmdNext_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdPrev_Click
; Description ...:
; Syntax ........: cmdPrev_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdPrev_Click()
	$n_Status = $conShow
	$n_RecPos = $n_RecPos - 1
	If $n_RecPos <= 0 Then $n_RecPos = 1

	ShowData()
EndFunc   ;==>cmdPrev_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdFirst_Click
; Description ...:
; Syntax ........: cmdFirst_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdFirst_Click()
	$n_Status = $conShow
	$n_RecPos = 1
	ShowData()
EndFunc   ;==>cmdFirst_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: cmdLast_Click
; Description ...:
; Syntax ........: cmdLast_Click()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func cmdLast_Click()
	$n_Status = $conShow
	$n_RecPos = $n_RecCount
	ShowData()
EndFunc   ;==>cmdLast_Click

; #FUNCTION# ====================================================================================================================
; Name ..........: ShowData
; Description ...:
; Syntax ........: ShowData()
; Parameters ....:
; Return values .: None
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func ShowData()
	Local $a_Data
	If $n_RecCount = 0 Or $n_Status = $conAdd Then ; Blank Table
		GUICtrlSetData($lblRecPos, $n_RecPos & " of " & $n_RecCount)
		;GUICtrlSetData($lblRecPos, "0 of 0")
		GUICtrlSetData($txtFirstName, "")
		GUICtrlSetData($txtMidName, "")
		GUICtrlSetData($txtLastName, "")
		GUICtrlSetData($txtMobile, "")
		GUICtrlSetData($txtHomePhone, "")
		GUICtrlSetData($txtAddress, "")
		Return
	EndIf

	$a_Data = _AccessRecordList($o_PhoneBook, $conTable, $n_RecPos)

	If $a_Data[0] = 0 Then
		MsgBox(16, $conProgName, "Error in Reading Data..")
		Return
	EndIf

	GUICtrlSetData($lblRecPos, $n_RecPos & " of " & $n_RecCount)

	;AutoID is not shown $a_Data[1] )

	GUICtrlSetData($txtFirstName, $a_Data[2])
	GUICtrlSetData($txtMidName, $a_Data[3])
	GUICtrlSetData($txtLastName, $a_Data[4])
	GUICtrlSetData($txtMobile, $a_Data[5])
	GUICtrlSetData($txtHomePhone, $a_Data[6])
	GUICtrlSetData($txtAddress, $a_Data[7])

EndFunc   ;==>ShowData

; #FUNCTION# ====================================================================================================================
; Name ..........: SaveRec
; Description ...: Copy data from text box to database
; Syntax ........: SaveRec()
; Parameters ....:
; Return values .: Sucess True, Fail False
; Author ........: Ayman Henry
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func SaveRec()
	Local $n_FeedBack
	Local $avData[6][2]
	;---------- Data Setup
	$avData[0][0] = "phoFirstName"
	$avData[1][0] = "phoMidName"
	$avData[2][0] = "phoLastName"
	$avData[3][0] = "phoMobile"
	$avData[4][0] = "phoHomePhone"
	$avData[5][0] = "phoAddress"

	$avData[0][1] = GUICtrlRead($txtFirstName)
	$avData[1][1] = GUICtrlRead($txtMidName)
	$avData[2][1] = GUICtrlRead($txtLastName)
	$avData[3][1] = GUICtrlRead($txtMobile)
	$avData[4][1] = GUICtrlRead($txtHomePhone)
	$avData[5][1] = GUICtrlRead($txtAddress)

	If $n_Status = $conAdd Then
		$n_FeedBack = _AccessRecordAdd($o_PhoneBook, $conTable, $avData)
	Else
		$n_FeedBack = _AccessRecordEdit($o_PhoneBook, $conTable, $avData, $n_RecPos)
	EndIf

	If $n_FeedBack <> 1 Then
		MsgBox(16, $conProgName, "Error in writting Data..")
		Return False
	EndIf

	If $n_Status = $conAdd Then
		$n_RecCount = $n_RecCount + 1
		$n_RecPos = $n_RecCount
	EndIf

	Return True
EndFunc   ;==>SaveRec
