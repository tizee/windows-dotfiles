# conda version: 24.11.3
# only supports PowerShell < 7.5.0

# Check if PowerShell version is less than 7.5.0
If ([version]"$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)" -lt [version]"7.5.0") {
	Write-Host "Conda setup triggered for PowerShell version $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
	$moduleLoadTime = Measure-Command {
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
# If (Test-Path "E:\Miniconda3\Scripts\conda.exe") {
#    (& "E:\Miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
# }
#endregion
	$Env:CONDA_EXE = "E:\Miniconda3\Scripts\conda.exe"
	$Env:_CONDA_ROOT = "E:\Miniconda3"
	$Env:_CONDA_EXE = "E:\Miniconda3\Scripts\conda.exe"
	$Env:_CE_M = $null
	$Env:_CE_CONDA = $null
	$CondaModuleArgs = @{ChangePs1 = $False}
	Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs
	#conda activate base
	Remove-Variable CondaModuleArgs
	}
	Write-Host "Time to init conda: $($moduleLoadTime.TotalMilliseconds)ms"
} else {
	Write-Host "Conda setup disabled for PowerShell version $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
}
