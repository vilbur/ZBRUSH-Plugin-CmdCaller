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

/**
 */
copyTemplateAndReplacePlaceholders( $dynamic_script_template, $dynamic_script, $zbrush_command )
{
	; The text inside the file you want to find (The $placeholder)
	$placeholder := "{interface_path}"

	; Check if the source file actually exists before proceeding
	if !FileExist($dynamic_script_template)
	{
		MsgBox, 16, Error, Source file not found at:`n%$dynamic_script_template%
		ExitApp
	}
	
	; 1. COPY THE FILE
	; The '1' at the end means "Overwrite if destination already exists"
	FileCopy, %$dynamic_script_template%, %$dynamic_script%, 1
	
	if (ErrorLevel)
	{
		MsgBox, 16, Error, Failed to copy file. Check permissions or file paths.
		ExitApp
	}
	
	; 2. READ THE DESTINATION FILE INTO MEMORY
	FileRead, $file_content, %$dynamic_script%
	
	; 3. PERFORM THE REPLACEMENT
	; Note: StrReplace() is case-insensitive by default in AHK v1.
	; Use StringCaseSense, On if you need strict casing.
	$new_content := StrReplace($file_content, $placeholder, $zbrush_command)
	
	; 4. SAVE THE CHANGES
	; We must delete the file first, otherwise FileAppend adds to the end of the file.
	FileDelete, %$dynamic_script%
	FileAppend, %$new_content%, %$dynamic_script%

}

/*
	CREATE HARDLINK OF FILE WITHOUT EXTENSION - used in wacom center as label

*/ 
createHardlink( $command_file )
{
	SplitPath, $command_file, $file_name, $dir_path, file_ext, file_name_no_ext
	
	$link_path := $dir_path "\" file_name_no_ext ;;; "

	
	if ! FileExist($link_path)
	{
		; Use Windows mklink to create hardlink
		$command := ComSpec " /c mklink /H """ $link_path """ """ $command_file """"
		
		RunWait, %$command%,, Hide
	}
}


/*==============================================================================
	CONFIGURATION SECTION - EDIT THESE VARIABLES
================================================================================
*/

/*------ GET APRAMETER ------
*/
$command_file = %1% ;;; E.G.: "...\Tool\Masking\ViewMask.exe"

/*------ PATHS ------
*/
$filename := "dynamic-script.txt"

; 1. The path to your original template file
$dynamic_script_template := A_ScriptDir "/" $filename

; 2. The path where you want the new file to be created
$dynamic_script := "C:/Windows/Temp/" $filename




/*==============================================================================
	MAIN LOGIC
================================================================================
*/

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

$zbrush_command := % convertFilePathToCommand( $command_file )


copyTemplateAndReplacePlaceholders( $dynamic_script_template, $dynamic_script, $zbrush_command )

createHardlink( $command_file )

executeDynamicScript()
