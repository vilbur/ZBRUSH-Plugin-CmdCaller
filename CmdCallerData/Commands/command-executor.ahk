#NoEnv
#SingleInstance Force

/*
Test receiver script.
Shows received parameter from caller script.
*/
;if (0 > 0)
;{
    param = %1%
    MsgBox, 64, Parameter Received, Caller script name:`n%param%
;}
;else
;{
;    MsgBox, 48, No Parameter, No parameter was passed.
;}
