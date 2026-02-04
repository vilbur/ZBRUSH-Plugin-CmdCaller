#NoEnv
#SingleInstance Force


/**
	CONVERT FILE PATH TO ZBRUSH PATH
  
	E.G.:"Tool\Masking\ViewMask" >>> "Tool\Masking\ViewMask"
  
  
	@param string command_path_file E.G.: "C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins\INSTALLED\CmdCaller\CmdCallerData\Commands\Tool\Masking\ViewMask.ahk"
  
	@return string path to zbrush comman dderivated from command_path_file E.G.: "Tool:Masking:ViewMask"

 */

; Define the input path
command_path_file = %1%

split_directory := "Commands\" ;"

; 1. Remove .ahk extension
SplitPath, command_path_file, , dir, , name_no_ext

path_no_ext := dir ":" name_no_ext

; trim path up to split_directory
Pos := InStr( path_no_ext, split_directory )

trimmed_path := SubStr( path_no_ext, Pos + StrLen(split_directory))

; 3. Replace "/" with ":"
command_path := RegExReplace( trimmed_path, "[\\/]+", ":" )

