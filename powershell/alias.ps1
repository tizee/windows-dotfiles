# type is the equivalent cat in powershell
Set-Alias -Name "cat" -Value "type"
Set-Alias -Name "trash" -Value "Remove-ItemSafely"
Set-Alias -Name "rm" -Value "Remove-ItemSafely"

function zai {
  cd e:\AI-models\projects
}

function zvideo {
  cd e:\VideoEdit
}

function zproj {
  cd d:\projects
}

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
