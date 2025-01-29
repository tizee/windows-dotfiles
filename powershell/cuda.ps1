
# Current approach may create duplicate entries when reloading
$env:Path += ";C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.5\bin;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.5\libnvvp;"
$env:CUDAToolkit_ROOT = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.5"
Add-EnvironmentVariable -VariableName "CUDA_PATH" -VariableValue "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.5" -Scope "User"
Add-EnvironmentVariable -VariableName "CUDA_BIN_PATH" -VariableValue "%CUDA_PATH%\bin" -Scope "User"
Add-EnvironmentVariable -VariableName "CUDA_LIB_PATH" -VariableValue "%CUDA_PATH%\lib\x64" -Scope "User"
