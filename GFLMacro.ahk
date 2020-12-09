#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


CoordSaveFile := "C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroLocationData.txt"
RandomCoordSaveFile := "C:\Users\matth\Downloads\AutoHotKeyStuff\GFLRandomLocationData.txt"
CoordLoadFile := "C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroExperiment.txt"
recordingMacro := 0
MsgBox, GFLScript Running


^#!x::
Send, C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroBattleRandom.txt
return

^#!c::
Send, C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroCrateFarm.txt
return

^#!v::
Send, C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroMK26.txt
return

^#!b::
Send, C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroKordRefill.txt
return

^#!1::
CheckIfGachaExist("Girl's Frontline", "Arknights")
return

^#!2::
SaveClickDisplayMouseCoord()
return

; TOOLS_________________________________________________________________________
CheckIfGachaExist(WinTitle, WinTitle2) ; Reorganize Emulator Windows
{
	IfWinExist, %WinTitle%
	{
		IfWinActive, %WinTitle%
		{
			WinMove, %WinTitle%, , 0,0, A_ScreenWidth, A_ScreenHeight
			MsgBox, %WinTitle% Maximized!
		}else{
			WinMove, %WinTitle%, , 0,0, (A_ScreenWidth/2), (A_ScreenHeight/2)
			MsgBox, %WinTitle% Resized!
		}
	}else
	{
		MsgBox, %WinTitle% Does Not Exist.
	}

	IfWinExist, %WinTitle2%
	{
		IfWinActive, %WinTitle2%
		{
			WinMove, %WinTitle2%, , 0,0, A_ScreenWidth, A_ScreenHeight
			MsgBox, %WinTitle2% Maximized!
		}else{
			WinMove, %WinTitle2%, , (A_ScreenWidth/2),0, (A_ScreenWidth/2), (A_ScreenHeight/2)
			MsgBox, %WinTitle2% Resized!
		}
	}else
	{
		MsgBox, %WinTitle2% Does Not Exist.
	}
	return
}

SaveClickDisplayMouseCoord() ; Clipboard and Click Mouse Location
{
	MouseGetPos testx, testy ; mouse coordinates saved in xx, yy
	clipboard = Click, %testx%, %testy%
	Click
	MsgBox Mouse Coordinates X: %testx% Y: %testy%
	return
}










^#!3::
ActivateMacroRecording()
 ; MsgBox, %recordingMacro%
MsgBox, 4, , Macro Recording Started,3
return

^#!4::
EndMacroRecording()
MsgBox, Macro Recording Ended
return

#If recordingMacro=1 ; Sends Mouse Coordinates and time into CoordSaveFile
~LButton::
Keywait,LButton
MouseGetPos,XPos,YPos
FileAppend,%xPos%`n%yPos%`n%A_TimeSincePriorHotkey%`n, %CoordSaveFile%
return
#If

 ; SAVE MACROS___________________________________________________________________
ActivateMacroRecording() ; allows mouse coordinates to be recorded
{
	global recordingMacro:=1
	global CoordSaveFile
	FileOpen(CoordSaveFile, "w")
}

EndMacroRecording() ; stops mouse coordinates from being recorded
{
	global recordingMacro:=0
}









^#!6::
InputBox, Input1, Input File Path Name Of Specified Macro
InputBox, Quantity, Input Amount of Times Macro Will Repeat (1-10)
InputBox, Input2, Input File Path Name Of Specified Random Macro
RunMacroRecording(Input1, Quantity, Input2)
return


 ; RUN MACROS____________________________________________________________________
FileAndQuanityIsValid(FilePathInput, Quantity, FilePathRandomInput) ; HELPER
{
	; Input Check
	if !FileExist(FilePathInput){
	 MsgBox, Input File Does Not Exist
	 return 0
	}

	counter := Quantity
	If counter is digit
	{
	 if (counter>10 or counter <1){
		 MsgBox, Counter has to range from 1-10
		 return 0
	 }
	}else{
	 MsgBox, Counter is NOT a Number
	 return 0
	}

	if !FileExist(FilePathRandomInput){
	 MsgBox, Random Input File Does Not Exist
	 return 0
	}
	return 1
}


Class MacroObject{
 ; C:\Users\matth\Downloads\AutoHotKeyStuff\GFLMacroKordRefill.txt
 ; Instantiate Arrays
	locationDataArray := []
	xCoordArray := []
	yCoordArray := []
	tCoordArray := []

	__New(macroFilePath, whichMacro)
	{
		this.macroFilePath := macroFilePath
		this.whichMacro := whichMacro ; 0 a macro with randomized timings, 1 a macro with randomized removal of actions and random timings
		Loop, read, %macroFilePath%
		this.locationDataArray.Push(A_LoopReadLine)

		while this.locationDataArray.MaxIndex()>0
		{
			this.xCoordArray.Push(this.locationDataArray.RemoveAt(1))
			this.yCoordArray.Push(this.locationDataArray.RemoveAt(1))
			this.tCoordArray.Push(this.locationDataArray.RemoveAt(1))
		}
		 ; MsgBox % "X:"this.xCoordArray.MaxIndex()" Y:"this.yCoordArray.MaxIndex()" T:"this.tCoordArray.MaxIndex()
	}
	runMacro()
	{
		if (this.whichMacro=1){ ; random removal of random 2 step actions
			counter := this.xCoordArray.MaxIndex()/2 ;ex: if there are 8 steps, you can remove 4 2 step actions
			while(counter!=0) ; Runs Removal of groups of 2 step actions  for "counter" amount of times
			{
				Random, willRemove, 0,1 ; 50% chance to actually remove 2 steps
				if (willremove=1)
				{
					maxIndex := this.xCoordArray.MaxIndex()
					Random, removeAt, 0, Floor(((maxIndex/2)-1)) ; where to remove 2 steps
					removeLocation := 1+(2*removeAt)
					 ; MsgBox, Length: %maxIndex% removeAt: %removeAt% removeLocation: %removeLocation%
					this.xCoordArray.RemoveAt(removeLocation)
					this.yCoordArray.RemoveAt(removeLocation)
					this.tCoordArray.RemoveAt(removeLocation)
					this.xCoordArray.RemoveAt(removeLocation)
					this.yCoordArray.RemoveAt(removeLocation)
					this.tCoordArray.RemoveAt(removeLocation)
				}
				counter-=1
			}
		}
		this.runMacroNormal()
	}
	runMacroNormal() ; runs recorded macro with random poistioning and timing offsets
	{
		if(this.xCoordArray.MaxIndex()=this.yCoordArray.MaxIndex() and this.yCoordArray.MaxIndex()=this.tCoordArray.MaxIndex()){
			WinActivate Girl's Frontline
			for index, element in this.xCoordArray ; Runs Coordinates in File
			{
				Random, randCoordDisposition, -10,10
				Random, randTimeDisposition, 0,2000
				x := this.xCoordArray[index]+randCoordDisposition
				y := this.yCoordArray[index]+randCoordDisposition
				sleeptime := this.tCoordArray[index] + randTimeDisposition

				sleep, %sleeptime%
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
}


RunMacroRecording(FilePathInput, Quantity, FilePathRandomInput)
{
	if (FileAndQuanityIsValid(FilePathInput, Quantity, FilePathRandomInput)=0)
	{
		return
	}
	mainMacro := new MacroObject(FilePathInput, 0)
	counter := Quantity

	; Run Macro Combination
	while (counter>0){
		; MsgBox, 4, , Counter: %counter%,1
		; MsgBox, Counter: %counter%
		Random, randTimeDisposition2, 3000,5000
		sleep, randTimeDisposition2
		randomMacro := new MacroObject(FilePathRandomInput, 1)
		randomMacro.runMacro()
		mainMacro.runMacro()
		counter -=1
	}
	MsgBox, Macro Success
	return
}















Tab::
MsgBox, Macro is Exiting...
ExitApp

^#!p::
MsgBox, Toggle Pause
Pause
