#NoEnv
#SingleInstance Force


/**
	CONVERT FILE PATH TO ZBRUSH PATH
  
	E.G.:"Tool\Masking\ViewMask" >>> "Tool\Masking\ViewMask"
  
  
	@param string $command_path_file E.G.: "C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins\INSTALLED\CmdCaller\CmdCallerData\Commands\Tool\Masking\ViewMask.ahk"
  
	@return string path to zbrush comman dderivated from $command_path_file E.G.: "Tool:Masking:ViewMask"

 */

/**
 */
convertFilePathToCommand( $command_path_file )
{
	; Define the input path
	;$command_path_file = %1%
	
	$split_directory := "Commands\" ;"
	
	; 1. Remove .ahk extension
	SplitPath, $command_path_file, ,$dir, , $name_no_ext
	
	$path_no_ext := $dir ":" $name_no_ext
	
	; trim path up to $split_directory
	Pos := InStr( $path_no_ext, $split_directory )
	
	$trimmed_path := SubStr( $path_no_ext, Pos + StrLen($split_directory))
	
	; 3. Replace "/" with ":"
	$command_path := RegExReplace( $trimmed_path, "[\\/]+", ":" )
	
	return % $command_path
	
}

/**
 */
writeCommandToDynamicScript( $zbrush_command )
{
	$export_dir	:= "C:/Windows/Temp"
	
	$execute := ""

	$import_zscript	:= $export_dir "/dynamic-script.txt"

	$header	:= "[If, 1,`n" ; SCRIPT MUST BE WRAPPED INTO SOMETHING TO MAKE IT RUN -- prevent error with top level command
	$ipress	:= "`n	[IToggle, " $zbrush_command " ]"
	
	$execute .= "`n	[If, [IExists, " $zbrush_command " ]"
	$execute .= "`n	, // THEN"
	$execute .= "`n		" $ipress 
	$execute .= "`n	, // ELSE"
	$execute .= "`n		[MessageOKCancel, [StrMerge, ""ZBRUSH PLUGIN: DynamicCmd\n\nCONTROL WAS NOT FOUND: "", " $zbrush_command "] ]"
	$execute .= "`n	]"
	
	
	$footer	:= "`n]"

	FileDelete, %$import_zscript%


	FileAppend, %$header%,	%$import_zscript%
	FileAppend, %$execute%,	%$import_zscript%
	FileAppend, %$footer%,	%$import_zscript%



}

/**
 */
executeDynamicScript(  )
{
	if( $zbrush_window	:= WinExist( "ahk_exe ZBrush.exe" ) )
	{
		WinActivate, ahk_exe ZBrush.exe

		sleep 100

		/*
			Execute command 
		*/
		Send, {End}
	}
}

$argument = %1%

$zbrush_command := % convertFilePathToCommand( $argument )

;writeCommandToDynamicScript( $zbrush_command )


SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ==============================================================================
; CONFIGURATION SECTION - EDIT THESE VARIABLES
; ==============================================================================

$filename := "dynamic-script.txt"

; 1. The path to your original template file
SourceFile := A_ScriptDir "/" $filename

; 2. The path where you want the new file to be created
DestFile := "C:/Windows/Temp/" $filename

; 3. The text inside the file you want to find (The Placeholder)
Placeholder := "{interface_path}"



; ==============================================================================
; MAIN LOGIC
; ==============================================================================

; Check if the source file actually exists before proceeding
if !FileExist(SourceFile)
{
    MsgBox, 16, Error, Source file not found at:`n%SourceFile%
    ExitApp
}

; 1. COPY THE FILE
; The '1' at the end means "Overwrite if destination already exists"
FileCopy, %SourceFile%, %DestFile%, 1

if (ErrorLevel)
{
    MsgBox, 16, Error, Failed to copy file. Check permissions or file paths.
    ExitApp
}

; 2. READ THE DESTINATION FILE INTO MEMORY
FileRead, FileContent, %DestFile%

; 3. PERFORM THE REPLACEMENT
; Note: StrReplace() is case-insensitive by default in AHK v1.
; Use StringCaseSense, On if you need strict casing.
NewContent := StrReplace(FileContent, Placeholder, $zbrush_command)

; 4. SAVE THE CHANGES
; We must delete the file first, otherwise FileAppend adds to the end of the file.
FileDelete, %DestFile%
FileAppend, %NewContent%, %DestFile%

; Notify the user
;MsgBox, 64, Success, File copied and updated successfully!`nSaved to: %DestFile%

executeDynamicScript()
