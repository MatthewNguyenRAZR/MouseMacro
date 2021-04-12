#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global guiWindowX := 0
global guiWindowY := 0

refresh:
Gui,+LastFound
WinGetPos,xWindow,yWindow
if (xWindow != "" or yWindow != ""){
	guiWindowX = %xWindow%
	guiWindowY = %yWindow%
}
Gui, 1:Destroy


;Global Variable
isRecording := 0
global saveMacroDirectory := A_ScriptDir . "\IndividualMacros\"
global xTempCoordArray := []
global yTempCoordArray := []
global tTempCoordArray := []
global windowTempArray := []
global gui_Id := ""
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
Gui, 1:Show, x%guiWindowX% y%guiWindowY% w420 h600, Mouse Macro

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

runMacro: ; Should Minimize GUI
	if(isRecording = 1){
		Msgbox, Can't Run Macro When Recording
	}else{
		Gui, +OwnDialogs
		Gui, Submit,NoHide
		runningMacroPath := saveMacroDirectory . MacroList
		runningMacro := new MacroObject(runningMacroPath)
		runningMacro.runMacro()
	}
	return

editMacro:
	runningMacroPath := saveMacroDirectory . MacroList
	runningMacro := new MacroObject(runningMacroPath)
	; coordDispositionInput :=
	; timeDelayInput :=
	; runChanceInput :=
	; repeatAmountInput :=
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
	Gui, 2:Add, Edit, y+20 w50 vrunChance, 100
	Gui, 2:Add, Text, y+20, Repeat Amount (Repeat Range:1-10)
	Gui, 2:Add, Edit, y+20 w50 vrepeatAmount, 1
	EditMacroAttributes()
	return

2GuiClose:
	Gui, 1:-Disabled
	Gui, 2:Destroy
	return

record:
	isRecording=1
	MouseGetPos,,,MacroWindowID
	gui_Id = %MacroWindowID%
	Msgbox, %gui_Id%
	xTempCoordArray := []
	yTempCoordArray := []
	tTempCoordArray := []
	windowTempArray := []
	return


stopRecording:
	isRecording=0
	OutputRecordedFile()
	Goto, refresh


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
MouseGetPos,XPos,YPos,Window
time:=A_TimeSincePriorHotkey
If (isRecording=1 and gui_Id != Window)
{
	xTempCoordArray.Push(XPos)
	yTempCoordArray.Push(YPos)
	tTempCoordArray.Push(time)
	windowTempArray.Push(Window)
}
return



;Methods________________________________________________________________________
CheckFolderExistence() ; Checks if macro save directory is created
{
	if (!FileExist(saveMacroDirectory))
	{
		Msgbox, Create this directory before using:`n%saveMacroDirectory%
		return 0
	}
	return 1
}
OutputRecordedFile() ; outputs recorded clicks onto a text file in the macro save directory
{
	if (xTempCoordArray.MaxIndex()=1 || xTempCoordArray.MaxIndex()=""){
		Msgbox, No actions were recorded. (Or actions were with this program)
	}
	else{
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
			FileAppend, 0`n0`n100`n1`n, %filePath% ; Default Input For Coordinate Dispostion (0), Time Delay Onclick (0), Random Run Chance (100), Repeat Amount (1)
			xTemp := xTempCoordArray.RemoveAt(1)
			yTemp := yTempCoordArray.RemoveAt(1)
			tTemp :=tTempCoordArray.RemoveAt(1)
			winTemp := windowTempArray.RemoveAt(1)

			xTemp := xTempCoordArray.RemoveAt(1)
			yTemp := yTempCoordArray.RemoveAt(1)
			tTemp := 0
			winTemp := windowTempArray.RemoveAt(1)
			FileAppend, %xTemp%`n%yTemp%`n%tTemp%`n%winTemp%`n, %filePath%
			while xTempCoordArray.MaxIndex()>0
			{
				xTemp := xTempCoordArray.RemoveAt(1)
				yTemp := yTempCoordArray.RemoveAt(1)
				tTemp :=tTempCoordArray.RemoveAt(1)
				winTemp := windowTempArray.RemoveAt(1)
				FileAppend, %xTemp%`n%yTemp%`n%tTemp%`n%winTemp%`n, %filePath%
			}
		}
		xTempCoordArray := []
		yTempCoordArray := []
		tTempCoordArray := []
		windowTempArray := []
	}
}
EditMacroAttributes()
{

}

Class MacroObject{
 ; C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroKordRefill.txt
 ; Instantiate Arrays
	locationDataArray := [] ; Array used to save every line of text file as an array index to organize and set the attributes
	randomCoordDisposition := 0
	randomTimeDelay := 0
	runChance := 100
	repeatAmount:= 1
	xCoordArray := []
	yCoordArray := []
	tCoordArray := []
	windowArray := []


	__New(macroFilePath)
	{
		this.macroFilePath := macroFilePath
		Loop, read, %macroFilePath%
		this.locationDataArray.Push(A_LoopReadLine)


		this.randomCoordDisposition := this.locationDataArray.RemoveAt(1)
		this.randomTimeDelay := this.locationDataArray.RemoveAt(1)
		this.runChance := this.locationDataArray.RemoveAt(1)
		this.repeatAmount:= this.locationDataArray.RemoveAt(1)

		while this.locationDataArray.MaxIndex()>0
		{
			this.xCoordArray.Push(this.locationDataArray.RemoveAt(1))
			this.yCoordArray.Push(this.locationDataArray.RemoveAt(1))
			this.tCoordArray.Push(this.locationDataArray.RemoveAt(1))
			this.windowArray.Push(this.locationDataArray.RemoveAt(1))
		}
	}
	runMacro()
	{
		repeatCounter := this.repeatAmount
		while(repeatCounter>=1)
		{
				Random, runChanceCounter, 0,100
				if(runChanceCounter<(this.runChance+1)){
						this.runMacroOnce()
				}
				repeatCounter -= 1
		}
		MsgBox, Macro Success
	}
	runMacroOnce() ; runs recorded macro with random poistioning and timing offsets
	{
		if(this.xCoordArray.MaxIndex()=this.yCoordArray.MaxIndex() and this.yCoordArray.MaxIndex()=this.tCoordArray.MaxIndex()){
			for index, element in this.xCoordArray ; Runs Coordinates in File
			{
				Random, randCoordDisposition, (this.randomCoordDisposition*-1),this.randomCoordDisposition
				Random, randTimeDisposition, 0,this.randomTimeDelay
				x := this.xCoordArray[index]+randCoordDisposition
				y := this.yCoordArray[index]+randCoordDisposition
				sleeptime := this.tCoordArray[index] + randTimeDisposition

				sleep, %sleeptime%
				window_id := this.windowArray[index]
				WinActivate, ahk_id %window_id%
				KeyWait Control
				KeyWait Alt
				BlockInput On
				MouseClick, left, %x%, %y%
				BlockInput Off
			}
		}else{
			MsgBox, Macro Failed, Press Tab
		}
		return
	}
	editAttributes(coordDispositionInput, timeDelayInput, runChanceInput, repeatAmountInput){
		return
	}
}




GuiClose:
ExitApp

; In case of a critical error in macro execution press Esc to end program
Esc::
MsgBox, Macro is Exiting...
ExitApp
