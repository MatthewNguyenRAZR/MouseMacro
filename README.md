# MouseMacro
A macro program written in AutoHotKey that records and runs mouse macros.  
Main purpose to make gacha games easier lul.

## Goal Stuff
**Problem:**
1. Gacha games are too grindy
2. Macro Detection in place

**Solution:**
1. Automate repetitive tasks
2. Prevent Macro Detection (Randmness)

## Features To Add
- Basic
  - Record, Export, Import Macros
  - Mouse Click-Only Macros (Option)
  - Mouse & Drag Macros (Not Planning to do option yet)
- Multi-macro compiler: Combine and organize multiple macros to run
- Random Settings for macro

## Planning Stuff
**Menu Options**
- Create Macro
  - Import Macro
  - Record Macro
    - Mouse Click Only Macro
- List currently recorded macros
  - Select Macro:
    - Run Macro
    - Export Macro
  	- Macro Settings
  		- Edit Name
  		- Edit Time Delay Randomization
  		- Edit Pixel Disposition
      - Edit Random Chance of Running or Not
- List currently created macro list
  - Run MacroList
  - Multi macro compiler
  	- Menu that adds listed macros to an array

**Objects:**

Object MouseClickMacroObject extends MouseMacro- Used to Create, Modify and Run A MouseClickMacro
- Parameters
	- macro_txt_input(optional)
	- dispoition (optional)
	- type (optional, 1-3 Default=1)
- Attributes
	- runnable=0
	- MacroName(String)
	- MacroType(int)
 	- xCoordArray[]
 	- yCoordArray[]
 	- tCoordArray[]
 	- pixelDisposition(int)
 	- randomTimeDelay(int)
  - randomRunChance=1 (decimal,percentage)
- Methods
 	- RunMacro
		- RunNormal
		- RunByRandomChance
 	- RecordMacro (will ExportMacro)
 	- ExportMacro
 	- ImportMacro (will SetMacro)
  - SetMacro
	- SetMacroName
	- SetCoordDisposition
  - SetRandomTimeDelay
  - runMacro (will check isRunnable, willHaveChanceToRun)
  - isRunnable
  - willHaveChanceToRun


Object MacroList(MacroObject_Input) - Used to mix and match macros or repeat a single macro
- Attributes
	- MacroListName(String)
	- MacroArray[]
	- TimeBetweenMacro(int)
- Methods:
	- RunMacros
	- AddMacro
	- RemoveMacro
	- ExportMacroList (Exports a Windows Folder with list of macros and a txt file that organizes it into a MacroList Object)
	- ImportMacroList (Organizes Folder into a MacroList Object based on a txt file)
  - SwapMacroObject
