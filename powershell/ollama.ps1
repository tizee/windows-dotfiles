# ollama
Add-EnvironmentVariable -VariableName "OLLAMA_HOST" -VariableValue "localhost" -Scope "User"
Add-EnvironmentVariable -VariableName "OLLAMA_MODELS" -VariableValue "E:\Ollama_models" -Scope "User"

# the number of loaded models
Add-EnvironmentVariable -VariableName "OLLAMA_MAX_LOADED_MODELS" -VariableValue 3 -Scope "User"
# Maximum parallel requests at the same time
Add-EnvironmentVariable -VariableName "OLLAMA_NUM_PARALLEL" -VariableValue 4 -Scope "User"
# Maximum queued requests
Add-EnvironmentVariable -VariableName "OLLAMA_MAX_QUEUE" -VariableValue 512 -Scope "User"
Add-EnvironmentVariable -VariableName "OLLAMA_ORIGINS" -VariableValue "*" -Scope "User"
$env:OLLAMA_ORIGINS = "*"
function ToggleOllamaOrigins{
    if ($env:OLLAMA_ORIGINS) {
        # If the environment variable is set, unset it
        Remove-Item Env:\OLLAMA_ORIGINS
        Write-Host 'Unset $env:OLLAMA_ORIGINS'
    } else {
        # If the environment variable is unset, set it to 1
        $env:OLLAMA_ORIGINS="*"
        Write-Host 'Set $env:SKIP_LLM_GITHOOK=1'
    }
}
