#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

/*
Search parent folders for a specific AutoHotkey file
and run it with current script name (without extension) as parameter.
*/
findAndRunParentScript(target_file_name)
{
    SplitPath, A_ScriptFullPath, , current_dir, , current_name

    while (current_dir != "")
    {
        candidate := current_dir "\" target_file_name ;"

        if (FileExist(candidate))
        {
            Run, "%candidate%" "%current_name%"
            return true
        }

        SplitPath, current_dir, , parent_dir
        if (parent_dir = current_dir)
            break

        current_dir := parent_dir
    }

    return false
}

/*
---- TEST CALL ----
Change this file name to whatever you are searching for
*/
if (!findAndRunParentScript("command-executor.ahk"))
{
    MsgBox, 16, Not Found, Target AutoHotkey file was not found in parent folders.
}
