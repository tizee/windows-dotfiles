# use . $profile to reload powershell configuration

# Consider using a conditional check before adding paths
if ($env:Path -notmatch ([regex]::Escape("$env:USERPROFILE\.local\bin"))) {
  $env:Path += ";$env:USERPROFILE\.local\bin"
}
# whisper
$env:Path += ";E:\AI-models\whisper;"

# profile
$env:MyProfile="$Home\.config\powershell\profile.ps1"
$env:EDITOR="nvim"

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
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Alt+j -BriefDescription AccestSuggestionAndExecute -LongDescription "Accept and execute the current suggestion" -ScriptBlock { 
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion(); 
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine() 
}
Set-PSReadLineKeyHandler -Key Ctrl+UpArrow -BriefDescription GoBack -LongDescription "Go back one directory" -ScriptBlock { 
  $currentLocation = Get-Location

    if ($currentLocation.Path -ne $currentLocation.Drive.Root) {
      Set-Location ..
    } else {
      Write-Host "Already at the root directory of the drive." -ForegroundColor Yellow
    }
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

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

# pnpm
Add-EnvironmentVariable -VariableName "PNPM_HOME" -VariableValue "E:\pnpm" -Scope "User"
# chocolatey
Add-EnvironmentVariable -VariableName "ChocolateyInstall" -VariableValue "E:\chocolatey" -Scope "User"

# plugins
# Define the base directory for plugins
$pluginBaseDir = "$env:USERPROFILE\.config\powershell"

# List of plugin scripts to load
$plugins = @(
    "llm.ps1",
    "yogit.ps1",
    "whisper.ps1",
    "ffmpeg.ps1",
    "conda.ps1",
    "posh-git.ps1",
    "cuda.ps1",
    "ollama.ps1",
    "nginx.ps1",
    "uv.ps1",
    "yt-dlp.ps1",
    "pip.ps1",
    "golang.ps1",
    "functions.ps1"
    )

# Loop through the list and load each script if it exists
foreach ($plugin in $plugins) {
  $pluginPath = Join-Path -Path $pluginBaseDir -ChildPath $plugin
    if (Test-Path -Path $pluginPath) {
      . $pluginPath
    } else {
      Write-Warning "Plugin script not found: $pluginPath"
    }
}
