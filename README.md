# MouseMacro
A macro program written in AutoHotKey that records and runs mouse macros.  
Main purpose to make gacha games easier lul.

## Goal Stuff
**Problem:**
1. Gacha games are too grindy
2. Macro Detection in place

**Solution:**
1. Automate repetitive tasks
2. Prevent Macro Detection (Randomness)

## Features To Add
- Basic
  - Record, Export, Import Macros
  - Mouse Click-Only Macros (Option)
  - Mouse & Drag Macros (Not Planning to do option yet)
- Multi-macro compiler: Combine and organize multiple macros to run
- Random Settings for macro

## Planning Stuff
**Menu Options**
- List currently recorded macros to select
  - Run Macro
  - Macro Settings
    - Edit Pixel Disposition
  	- Edit Time Delay Randomization
    - Edit Random Run Chance
    - Amount of times repeated
- Record Macro
- End Macro Recording
- List currently created macro list
  - Add Macro (from list)
  - Remove Macro (from list)
  - Run MacroList
  - Amount of times repeated

**Objects:**

Object MouseClickMacroObject- Used to Create, Modify and Run A MouseClickMacro
- Parameters
	- macroPath(string)
- Attributes
  - macroPath(string)
 	- pixelDisposition(int)
 	- randomTimeDelay(int)
  - randomRunChance=1 (decimal,percentage)
  - repeatAmount(int)
  - xCoordArray[]
  - yCoordArray[]
  - tCoordArray[]
- Methods
  - isRunnable
  - SetCoordDisposition
  - SetRandomTimeDelay
  - runMacro (will check isRunnable, willHaveChanceToRun)
  - editAttributes (can edit attributes of macro)
