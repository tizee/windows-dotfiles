# conda
$moduleLoadTime = Measure-Command {
$Env:CONDA_EXE = "E:\Miniconda3\Scripts\conda.exe"
$Env:_CE_M = $null
$Env:_CE_CONDA = $null
$Env:_CONDA_ROOT = "E:\Miniconda3"
$Env:_CONDA_EXE = "E:\Miniconda3\Scripts\conda.exe"
$CondaModuleArgs = @{ChangePs1 = $True}
Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs
#conda activate base
Remove-Variable CondaModuleArgs
}
Write-Host "Time to init conda: $($moduleLoadTime.TotalMilliseconds)ms"
