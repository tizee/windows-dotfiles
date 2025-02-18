function Setup-MSVC {
    Start-Process cmd -ArgumentList "/k `""E:\VisualStudio2022\VC\Auxiliary\Build\vcvars64.bat`" && powershell" -NoNewWindow -Wait
}
