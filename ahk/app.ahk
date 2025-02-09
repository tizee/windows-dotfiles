blacklist := ["WindowTerminal.exe"]
; ctrl-alt-a
^!a::
    WinGet, activeProcess, ProcessName, A
    ; Check if the process is in the blacklist
    for index, process in blacklist {
        if (activeProcess = process) {
            MsgBox, Script disabled for this application!
            return
        }
    }
    MsgBox, % "Current focused app's process name: " activeProcess
return
