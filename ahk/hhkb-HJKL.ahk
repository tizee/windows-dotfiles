#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Alt HJKL -> Arrow
!h::
Send, {Left down}
Send, {Left up}
Return

!j::
Send, {Down down}
Send, {Down up}
Return

!k::
Send, {Up down}
Send, {Up up}
Return

!l::
Send, {Right down}
Send, {Right up}
Return
