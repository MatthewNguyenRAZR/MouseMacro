#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

refresh:
Gui, 1:Destroy

;Global Variable
isRecording := 0
global saveMacroDirectory := A_ScriptDir . "\IndividualMacros\"
global xCoordArray := []
global yCoordArray := []
global tCoordArray := []
FileList := ""
CheckFolderExistence()

;GUI_____________________________________________________________________________
;GUI Variable
xMacroOptions := 20
yMacroOptions := 20
xMacroListOptions := 20
yMacroListOptions := 320

; General Layout
GUI, 1:-AlwaysOnTop ; + makes it always stay up, - will make it go behind other windows
Gui, 1:Color, 222222
Gui, 1:Color,,222222
Gui, 1:Show, w420 h600, Mouse Macro

; Options Layout


	; Macro Layout
Gui, 1:Font, s14 cDDDDDD
Gui, 1:Add, Text, x%xMacroOptions% y%yMacroOptions%, Options
Gui, 1:Font, s8 cDDDDDD
Gui, 1:Add, Button, x+40 grefresh, Refresh Window
Gui, 1:Add, Button, x%xMacroOptions% y+20 grunMacro, Run Macro
Gui, 1:Add, Button, x+40 geditMacro, Edit Macro
Gui, 1:Add, Button, x+40 grecord, Record
Gui, 1:Add, Button, x+40 gstopRecording, End Recording
SetTimer, MouseRecordingNotification, 1
Loop, %saveMacroDirectory%\*.txt
{
	FileList = %FileList%|%A_LoopFileName%|
}
Gui, 1:Add, ListBox,  x%xMacroOptions% y+20 w380 h200 vMacroList, %FileList%
	; Macro Compiler Layout
Gui, 1:Font, s14 cDDDDDD
Gui, 1:Add, Text, x%xMacroListOptions% y%yMacroListOptions%, Macro Compiler
Gui, 1:Font, s8 cDDDDDD
Gui, 1:Add, Button, y+20, Add Macro
Gui, 1:Add, Button, x+40, Remove Macro
Gui, 1:Add, Button, x+40, Run Macro List
return




;Labels_________________________________________________________________________

runMacro:
	Gui, +OwnDialogs
	Gui, Submit,NoHide
	msgbox, %MacroList%
	return

editMacro:
	Gui, 2:Show, w430 h400, Settings
	Gui, 2:Color, 222222
	Gui, 1:+Disabled
	Gui, 2:Font, s14 cDDDDDD
	Gui, 2:Add, Text, x%xMacroOptions% y%yMacroOptions%, Settings
		Gui, 2:Font, s10 cDDDDDD
	Gui, 2:Add, Text, y+20, Random Coordinate Dispostion (Pixel Displacement Range:0-10)
	Gui, 2:Add, Edit, y+20 w50 vCoord, 0
	Gui, 2:Add, Text, y+20, Random Time Delay Onclick (Millisecond Range:0-10000)
	Gui, 2:Add, Edit, y+20 w50 vTime, 0
	Gui, 2:Add, Text, y+20, Random Run Chance (Percent Range:1-100)
	Gui, 2:Add, Edit, y+20 w50 vrunChance, 1
	Gui, 2:Add, Text, y+20, Repeat Amount (Repeat Range:1-10)
	Gui, 2:Add, Edit, y+20 w50 vrepeatAmount, 1
	return

2GuiClose:
	Gui, 1:-Disabled
	Gui, 2:Destroy
	return

record:
	isRecording=1
	return


stopRecording:
	isRecording=0
	OutputRecordedFile()
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

; Sends Mouse Coordinates and time into a variable
~LButton::
Keywait,LButton
MouseGetPos,XPos,YPos
time:=A_TimeSincePriorHotkey
If isRecording=1
{
	MsgBox, X: %XPos% Y: %YPos% T: %time%
	xCoordArray.Push(XPos)
	yCoordArray.Push(YPos)
	tCoordArray.Push(time)
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
	return 1
}

OutputRecordedFile()
{
	InputBox, Name, Input Name of Recorded Macro
	if (Name = ""){
		Msgbox, Invalid Name, Macro Not Saved
	}
	else
	{
		filePath:= saveMacroDirectory . name . ".txt"
		MsgBox, Path: %filePath%
		if FileExist(filePath)
		{
			FileDelete, %filePath%
		}
		FileAppend, 0`n0`n100`n1`n, %filePath%
		xCoordArray.RemoveAt(1)
		yCoordArray.RemoveAt(1)
		tCoordArray.RemoveAt(1)
		xTemp := xCoordArray.RemoveAt(1)
		yTemp := yCoordArray.RemoveAt(1)
		tTemp := 0
		FileAppend, %xTemp%`n%yTemp%`n%tTemp%`n, %filePath%
		while xCoordArray.MaxIndex()>0
		{
			xTemp := xCoordArray.RemoveAt(1)
			yTemp := yCoordArray.RemoveAt(1)
			tTemp :=tCoordArray.RemoveAt(1)
			FileAppend, %xTemp%`n%yTemp%`n%tTemp%`n, %filePath%
		}
	}
	xCoordArray := []
	yCoordArray := []
	tCoordArray := []
}

GuiClose:
ExitApp
