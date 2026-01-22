#SingleInstance force

global $export_dir	:= "c:/Program Files/Pixologic/ZBrush 2022/ZStartup/ZPlugs64/CmdCaller-ExecuteCommand.txt"


/**
 */
writeImportScript()
{
	$import_zscript	:= $export_dir "/importToolsToZbrush.txt"
	$files_obj	:= []

	/*
		1) Get .obj and .mtl files
		2) Remove counter prefix E.G.: "01-_-fooFile.obj" >>> "fooFile.obj"
	*/
	Loop, Files, %$export_dir%\*.*
	{
		if( A_LoopFileExt == "obj" ||  A_LoopFileExt == "mtl" )
		{
			$nosuffix_path :=  A_LoopFileDir "/" RegExReplace( A_LoopFileName, "\d+\-_\-", "") ;;

			FileMove, %A_LoopFileFullPath%, %$nosuffix_path%

			if( A_LoopFileExt == "obj" )
				$files_obj.push( RegExReplace( $nosuffix_path, "\\", "/") )
		}
	}

	$tools_count := $files_obj.length()

	$header	:= "[If, 1,`n"
	$new_document	:= "`n	[IKeyPress, 78,[IPress, Document:New Document]]"
	$delete_subtools	:= "`n	[IKeyPress,'2',[IPress, Tool:SubTool:Del All]]"
	$select_subtool_1	:= "`n	[SubToolSelect, 0]"
	$restore_tools	:= "`n	[IPress, ""Tool:Restore Configuration""]"
	$enable_perspective	:= "`n	[IPress,Draw:Perspective]"
	$footer	:= "`n]"


	$define_arrays	.= "`n	[VarDef, $tool_names("	$tools_count ") ]"
	$define_arrays	.= "`n	[VarDef, $subt_names("	$tools_count ") ]`n"


	$set_tool_paths := ""
	$set_tool_paths	:= "`n	[VarDef, $set_tool_paths("	$tools_count ") ]"

	For $index, $file_path in $files_obj
		$set_tool_paths .= "`n	[VarSet, $set_tool_paths(" $index - 1 "),	""" $file_path """ ]"


	$import_tools .= "`n`n	/*    IMPORT TOOLS    */"
	$import_tools .= "`n	[Loop, " $tools_count ","
	$import_tools .= "`n		[IPress,Tool:SimpleBrush]"
	$import_tools .= "`n		[FileNameSetNext, $set_tool_paths(i) ]"
	$import_tools .= "`n		[IPress, Tool:Import]"
	$import_tools .= "`n		[VarSet, $tool_names(i),	[IGetTitle, Tool:Current Tool, 0]]"
	$import_tools .= "`n		[VarSet, $subt_names(i),	[IGetTitle, Tool:Current Tool  ]]"
	$import_tools .= "`n		[IPress,Tool:UV Map:Flip V]"
	$import_tools .= "`n	, i]"


	$load_first_tool .= "`n`n	/*    LOAD FIRST TOOL    */"
	$load_first_tool .= "`n	[IPress, [StrMerge, ""Tool:"", $tool_names(0)] ]"
	$load_first_tool .= "`n	[IPress, Stroke:DragRect]"
	;$load_first_tool .= "`n	[CanvasStroke, (ZObjStrokeV02n2=H229V214H229V214)]"
	$load_first_tool .= "`n	[CanvasStroke,(ZObjStrokeV02n10=H126V47DYH126V47DK1Xh1267Fv47C80H126V47EH126V47FH126V480H126V481H126V482H126V483H126V483)]"
	$load_first_tool .= "`n	[IPress, Transform:Edit]"
	$load_first_tool .= "`n	[IPress, Transform:Fit]"


	if( $tools_count > 1 )
	{
		$append_subtools .= "`n`n	/*    APPEND SUBTOOLS    */"
		$append_subtools .= "`n	[Loop, " $tools_count - 1 ","
		$append_subtools .= "`n		[IPress,	Tool:SubTool:Append]"
		$append_subtools .= "`n		[IPress,	[StrMerge, ""PopUp:"", $tool_names(i + 1)]]"
		$append_subtools .= "`n	, i]"


		$rename_subtools .= "`n`n	/*    RENAME SUBTOOLS    */"
		$rename_subtools .= "`n	[Loop, " $tools_count ","
		$rename_subtools .= "`n		[SubToolSelect, 0]	// slect first subtool"
		$rename_subtools .= "`n		[ToolSetPath,, $subt_names(i) ]	// rename subtool"
		$rename_subtools .= "`n		[IKeyPress,SHIFT,[IPress,Tool:SubTool:MoveDown]]	// send subtool to bottom"
		$rename_subtools .= "`n	, i]"


		$show_subtools	:= "`n`n	[ISet,Tool:SubTool:Visible Count," $tools_count "]"

		$show_subtools	.= "`n	[IShow,Tool]`n	[IClick, Tool:SubTool, 1]"
	}


	FileDelete, %$import_zscript%


	FileAppend, %$header%,	%$import_zscript%

	FileAppend, %$new_document%,	%$import_zscript%

	FileAppend, %$define_arrays%,	%$import_zscript%

	FileAppend, %$set_tool_paths%,	%$import_zscript%

	FileAppend, %$import_tools%,	%$import_zscript%

	FileAppend, %$load_first_tool%,	%$import_zscript%

	FileAppend, %$append_subtools%,	%$import_zscript%

	FileAppend, %$rename_subtools%,	%$import_zscript%

	FileAppend, %$select_subtool_1%,	%$import_zscript%

	FileAppend, %$restore_tools%,	%$import_zscript%

	FileAppend, %$enable_perspective%,	%$import_zscript%

	FileAppend, %$footer%,	%$import_zscript%
}


/**
 */
executeKeyboardShortcutInZbrush()
{
	if( $zbrush_window	:= WinExist( "ahk_exe ZBrush.exe" ) )
	{
		WinActivate, ahk_exe ZBrush.exe

		sleep 500

		/*
			Execute command "~VIL-PLUGINS:MaxZbrushSync:Max to Zbrush" in "../../Zbrush/MaxZbrushSync.txt"
		*/
		Send, {Ctrl Down}{Shift Down}{Alt Down}q{Ctrl Up}{Shift Up}{Alt Up}
	}
}

/** EXECUTE
  *
  */
writeImportScript()

;executeKeyboardShortcutInZbrush()
