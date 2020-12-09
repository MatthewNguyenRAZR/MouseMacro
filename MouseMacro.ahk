#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

refresh:
Gui, Destroy

;Global Variable
isRecording := 0
repeatAmount := 1
global saveMacroDirectory := A_ScriptDir . "\IndividualMacros\"
global saveMacroListDirectory := A_ScriptDir . "\MacroList\"
xCoordArray := []
yCoordArray := []
tCoordArray := []
FileList := ""
CheckFolderExistence()

;GUI_____________________________________________________________________________
;GUI Variable
xMacroOptions := 20
yMacroOptions := 20
xMacroListOptions := 20
yMacroListOptions := 320

; General Layout
GUI, -AlwaysOnTop ; + makes it always stay up, - will make it go behind other windows
Gui, Color, 222222
Gui, Color,,222222
Gui, Show, w420 h600, Mouse Macro

; Options Layout


	; Macro Layout
Gui, Font, s14 cDDDDDD
Gui, Add, Text, x%xMacroOptions% y%yMacroOptions%, Options
Gui, Font, s8 cDDDDDD
Gui, Add, Button, x+40 grefresh, Refresh Window
Gui, Add, Button, x%xMacroOptions% y+20 grunMacro, Run Macro
Gui, Add, Button, x+40 geditMacro, Edit Macro
Gui, Add, Button, x+40 grecord, Record
Gui, Add, Button, x+40 gstopRecording, End Recording
SetTimer, MouseRecordingNotification, 1
Loop, %saveMacroDirectory%\*.txt
{
	FileList = %FileList%|%A_LoopFileName%|
}
Gui, Add, ListBox,  x%xMacroOptions% y+20 w380 h200 vMacroList, %FileList%
	; Macro Compiler Layout
Gui, Font, s14 cDDDDDD
Gui, Add, Text, x%xMacroListOptions% y%yMacroListOptions%, Macro Compiler
Gui, Font, s8 cDDDDDD
Gui, Add, Button, y+20, Add Macro
Gui, Add, Button, x+40, Remove Macro
return



;Labels_________________________________________________________________________
runMacro:
	Gui, +OwnDialogs
	Gui, Submit,NoHide
	msgbox, %MacroList%
	return

editMacro:
	msgbox, Edit Test
	return

record:
	isRecording=1
	return

stopRecording:
	isRecording=0
	return

MouseRecordingNotification:
if(isRecording=1)
{
	MouseGetPos, px, py
	ToolTip, Recording..., px+10, py+10
}else{
	ToolTip
}
return






;Methods________________________________________________________________________
CheckFolderExistence()
{
	if (!FileExist(saveMacroDirectory))
	{
		Msgbox, Create this directory before using.%saveMacroDirectory%
		return 0
	}
	if (!FileExist(saveMacroListDirectory))
	{
		Msgbox, Create this directory before using.%saveMacroListDirectory%
		return 0
	}
	return 1
}


GuiClose:
ExitApp
