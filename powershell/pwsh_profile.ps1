# install following to PowerShell $profile, which is $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# . $env:USERPROFILE\.config\powershell\pwsh_profile.ps1
# use . $profile to reload powershell configuration

# use double-quoted string to expand env variables
$env:Path += ";C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.5\bin;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.5\libnvvp;"

# Current approach may create duplicate entries when reloading
# Consider using a conditional check before adding paths
if ($env:Path -notmatch ([regex]::Escape("$env:USERPROFILE\.local\bin"))) {
    $env:Path += ";$env:USERPROFILE\.local\bin"
}
# whisper
$env:Path += ";E:\AI-models\whisper"
$env:CUDAToolkit_ROOT = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.5"
# scoop proxy
# $env:HTTPS_PROXY="http://127.0.0.1:7890"
# $env:HTTP_PROXY="http://127.0.0.1:7890"

# type is the equivalent cat in powershell
Set-Alias -Name "cat" -Value "type"
Set-Alias -Name "trash" -Value "Remove-ItemSafely"
Set-Alias -Name "rm" -Value "Remove-ItemSafely"

# alias for dotfiles
function dotconf {
	cd $env:USERPROFILE\.config
}

# alias for Obsidian notes
function notes {
	cd f:\notes
}

Set-Alias -Name "vim" -Value "nvim"
Set-Alias -Name "vi" -Value "nvim"
function view ($file){
	if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) { 
	    Write-Error "nvim not installed" -ErrorAction Stop
	    return
	}
	nvim -R $file
}
Set-Alias -Name "open" -Value "Invoke-Item"

# Keybinds for the PSReadline module
$PSReadLineOptions = @{
    EditMode = "Emacs"
    HistoryNoDuplicates = $true
    PredictionViewStyle = "ListView"
    PredictionSource = "HistoryAndPlugin"
    BellStyle = "None"
    HistorySearchCursorMovesToEnd = $true
    Colors = @{
        "Command" = "#8181f7"
    }
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key "ctrl+d" -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Key "ctrl+l" -Function DeleteLine

# Vi mode
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

$save_command_to_history_parameters = @{
    Key = 'Alt+w'
    BriefDescription = 'SaveInHistory'
    LongDescription = 'Save current line in history but do not execute'
    ScriptBlock = {
      param($key, $arg)   # The arguments are ignored in this example

# GetBufferState gives us the command line (with the cursor position)
      $line = $null
      $cursor = $null
      [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
        [ref]$cursor)

# AddToHistory saves the line in history, but does not execute it.
      [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)

# RevertLine is like pressing Escape.
      [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
  }
}
Set-PSReadLineKeyHandler @save_command_to_history_parameters

function Add-EnvironmentVariable {
    param (
        [Parameter(Mandatory=$true)]
        [string]$VariableName,

        [Parameter(Mandatory=$true)]
        [string]$VariableValue,

        [Parameter(Mandatory=$true)]
        [ValidateSet("User", "Machine", "Process")]
        [string]$Scope
    )

    # Get the current value of the environment variable
    $currentValue = [System.Environment]::GetEnvironmentVariable($VariableName, $Scope)

    # Check if the variable already exists with the same value
    if ($currentValue -eq $VariableValue) {
        # Write-Host "Environment variable '$VariableName' already exists with the value '$VariableValue' in the '$Scope' scope. Skipping setup."
        return
    }

    # If the variable exists but has a different value, update it
    if ($currentValue -ne $null) {
        Write-Host "Environment variable '$VariableName' already exists with a different value. Updating to '$VariableValue'."
    }

    # Set the environment variable based on the specified scope
    [System.Environment]::SetEnvironmentVariable($VariableName, $VariableValue, $Scope)

    # Output a confirmation message
    Write-Host "Environment variable '$VariableName' has been set to '$VariableValue' for the '$Scope' scope."
}

Add-EnvironmentVariable -VariableName "OLLAMA_HOST" -VariableValue "E:\Ollama" -Scope "User"
Add-EnvironmentVariable -VariableName "OLLAMA_MODELS" -VariableValue "E:\Ollama_models" -Scope "User"

# plugins
. $env:USERPROFILE\.config\powershell\llm.ps1
. $env:USERPROFILE\.config\powershell\yogit.ps1
. $env:USERPROFILE\.config\powershell\whisper.ps1
. $env:USERPROFILE\.config\powershell\ffmpeg.ps1
. $env:USERPROFILE\.config\powershell\functions.ps1

