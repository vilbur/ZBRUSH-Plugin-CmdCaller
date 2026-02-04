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
	
	$header	:= "[If, 1,`n" ; SCRIPT MUST BE WRAPPED INTO SOMETHING TO MAKE IT RUN -- prevent error with top level command
	$ipress	:= "`n	[IPress, """ $zbrush_command """]"
	$footer	:= "`n]"

	FileDelete, %$import_zscript%


	FileAppend, %$header%,	%$import_zscript%
	FileAppend, %$ipress%,	%$import_zscript%
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
;
;$argument = %1%
;
;$zbrush_command := % convertFilePathToCommand( $argument )
;
;writeCommandToDynamicScript( $zbrush_command )

executeDynamicScript()


;MsgBox, %  $zbrush_command
