#NoEnv
#SingleInstance Force

/*
Test receiver script.
Shows received parameter from caller script.
*/
;if (0 > 0)
;{
    ;param = %1%
    ;MsgBox, 64, Parameter Received, Caller script name:`n%param%
;}
;else
;{
;    MsgBox, 48, No Parameter, No parameter was passed.
;}


path_to_command = %1%

; Define the input path
;path_to_command := "C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins\INSTALLED\CmdCaller\CmdCallerData\Commands\Tool\Masking\ViewMask.ahk"

; 1. Remove .ahk extension
; We replace ".ahk" with an empty string.
PathNoExt := StrReplace(path_to_command, ".ahk", "")

; 2. Trim everything up to "Commands\" and keep only the part after
; We look for the position of "Commands\" and extract the substring starting after it.
Keyword := "Commands\" ;"
Pos := InStr(PathNoExt, Keyword)

if (Pos > 0)
{
    ; Calculate the starting position of the text AFTER "Commands\"
    ; Pos is the start of "Commands\", so we add the length of "Commands\" (9) to get the end.
    ResultPart := SubStr(PathNoExt, Pos + StrLen(Keyword))
}
else
{
    ResultPart := PathNoExt ; Keyword not found
}

; 3. Replace "/" with ":"
; Note: The input path uses backslashes (\). The code below follows your instruction to replace forward slashes (/).
; If you meant to replace backslashes (\) to create a formatted ID (e.g., Tool:Masking:ViewMask), use the second line below.

FinalResult := StrReplace(ResultPart, "/", ":")

; OPTIONAL: If you intended to replace backslashes (\) instead:
FinalResultWithBackslashReplaced := StrReplace(ResultPart, "\", ":")